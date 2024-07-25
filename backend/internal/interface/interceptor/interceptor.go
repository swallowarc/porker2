package interceptor

import (
	"log/slog"

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
