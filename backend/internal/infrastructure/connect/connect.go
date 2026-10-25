package connect

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net"
	"net/http"
	"time"

	"connectrpc.com/authn"
	"connectrpc.com/connect"
	"github.com/rs/cors"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	"github.com/swallowarc/porker2/backend/internal/interface/interceptor"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
)

type (
	Server struct {
		logger     *slog.Logger
		httpServer *http.Server
	}
)

func NewServer(logger *slog.Logger, conf Config, controller pbconn.Porker2ServiceHandler, session session.Manager, f *interceptor.Factory) *Server {
	// 先頭が最も外側。ErrorInterceptor を外側に置き、LogInterceptor は変換前のアプリケーションエラーを見る。
	opt := connect.WithInterceptors(f.ErrorInterceptor(), f.LogInterceptor())

	mux := http.NewServeMux()
	mux.Handle(pbconn.NewPorker2ServiceHandler(controller, opt))

	md := authn.NewMiddleware(session.VerifyToken)

	handler := h2c.NewHandler(md.Wrap(mux), &http2.Server{})

	// see https://connectrpc.com/docs/cors/#preflight-response
	c := cors.New(cors.Options{
		AllowedOrigins:   conf.CORSAllowOrigins,
		AllowCredentials: true, // Necessary to use cookies
		AllowedMethods:   []string{"POST"},
		AllowedHeaders:   []string{"Content-Type", "Connect-Protocol-Version", "Connect-Timeout-Ms"},
	})

	return &Server{
		logger: logger,
		httpServer: &http.Server{
			Addr:    fmt.Sprintf("%s:%d", conf.Host, conf.Port),
			Handler: c.Handler(handler),

			ReadTimeout:  time.Duration(conf.ReadTimeoutSec) * time.Second,
			WriteTimeout: time.Duration(conf.WriteTimeoutSec) * time.Second,
			IdleTimeout:  time.Duration(conf.IdleTimeoutSec) * time.Second,
		},
	}
}

// Start は listen を同期的に行い、失敗 (ポート使用中等) を起動エラーとして返す。
// 受け付けループだけを別 goroutine で回す。
func (s *Server) Start(_ context.Context) error {
	ln, err := net.Listen("tcp", s.httpServer.Addr)
	if err != nil {
		return fmt.Errorf("failed to listen on %s: %w", s.httpServer.Addr, err)
	}

	s.logger.Info("server listening", slog.String("addr", ln.Addr().String()))

	go func() {
		if err := s.httpServer.Serve(ln); err != nil && !errors.Is(err, http.ErrServerClosed) {
			s.logger.Error("server stopped unexpectedly", slog.Any("error", err))
		}
	}()

	return nil
}

func (s *Server) Shutdown(ctx context.Context) error {
	if err := s.httpServer.Shutdown(ctx); err != nil {
		return fmt.Errorf("failed to shutdown server: %w", err)
	}
	return nil
}
