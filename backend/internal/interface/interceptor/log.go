package interceptor

import (
	"context"
	"log/slog"

	"connectrpc.com/connect"
	"github.com/google/uuid"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
)

func NewLogUnaryInterceptor(l *slog.Logger) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			l = slog.With(slog.String("request_id", uuid.NewString()))
			ctx = logger.SetLogger(ctx, l)

			return next(ctx, req)
		}
	}
}
