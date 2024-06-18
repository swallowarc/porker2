package interceptor

import (
	"log/slog"

	"connectrpc.com/connect"
)

type (
	Factory struct {
		logger *slog.Logger
	}
)

func NewFactory(logger *slog.Logger) *Factory {
	return &Factory{
		logger: logger,
	}
}

func (f *Factory) LogUnaryInterceptor() connect.UnaryInterceptorFunc {
	return NewLogUnaryInterceptor(f.logger)
}

func (f *Factory) AuthUnaryInterceptor() connect.UnaryInterceptorFunc {
	return NewAuthUnaryInterceptor()
}
