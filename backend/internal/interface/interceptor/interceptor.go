package interceptor

import (
	"log/slog"
	"strings"

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

func (f *Factory) LogInterceptor() connect.Interceptor {
	return NewLogInterceptor(f.logger)
}

func getRPCNameFromSpec(spec connect.Spec) string {
	path := strings.Split(spec.Procedure, "/")
	if len(path) == 0 {
		return ""
	}
	return path[len(path)-1]
}
