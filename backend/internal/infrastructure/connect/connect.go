package connect

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
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
	opt := connect.WithInterceptors(f.LogUnaryInterceptor())

	mux := http.NewServeMux()
	mux.Handle(pbconn.NewPorker2ServiceHandler(controller, opt))

	md := authn.NewMiddleware(session.VerifyToken)

	handler := h2c.NewHandler(md.Wrap(mux), &http2.Server{})
	if conf.CORSAllowAll {
		handler = cors.AllowAll().Handler(handler)
	}

	return &Server{
		logger: logger,
		httpServer: &http.Server{
			Addr:    fmt.Sprintf("%s:%d", conf.Host, conf.Port),
			Handler: handler,

			ReadTimeout:  time.Duration(conf.ReadTimeoutSec) * time.Second,
			WriteTimeout: time.Duration(conf.WriteTimeoutSec) * time.Second,
			IdleTimeout:  time.Duration(conf.IdleTimeoutSec) * time.Second,
		},
	}
}

func (s *Server) Run() {
	go func() {
		if err := s.httpServer.ListenAndServe(); err != nil {
			if !errors.Is(err, http.ErrServerClosed) {
				s.logger.Error("failed to rest server listen and serve", slog.Any("error", err))
			}
		}
	}()
}

func (s *Server) Shutdown(ctx context.Context) {
	if err := s.httpServer.Shutdown(ctx); err != nil {
		s.logger.Error("failed to shutdown server", slog.Any("error", err))
	}
}
