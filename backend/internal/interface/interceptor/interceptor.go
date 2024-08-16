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
