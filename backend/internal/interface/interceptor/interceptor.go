package interceptor

import (
	"log/slog"
	"strings"

	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	Factory struct {
		logger   *slog.Logger
		userRepo port.UserRepository
	}
)

func NewFactory(logger *slog.Logger, userRepo port.UserRepository) *Factory {
	return &Factory{
		logger:   logger,
		userRepo: userRepo,
	}
}

func (f *Factory) LogUnaryInterceptor() connect.UnaryInterceptorFunc {
	return NewLogUnaryInterceptor(f.logger)
}

func (f *Factory) AuthUnaryInterceptor() connect.UnaryInterceptorFunc {
	return NewAuthUnaryInterceptor(f.userRepo)
}

func getRPCName(req connect.AnyRequest) string {
	path := strings.Split(req.Spec().Procedure, "/")
	if len(path) == 0 {
		return ""
	}
	return path[len(path)-1]
}
