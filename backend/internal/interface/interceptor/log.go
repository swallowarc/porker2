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
			l = l.With(slog.String("request_id", uuid.NewString()))
			ctx = logger.SetLogger(ctx, l)

			res, err := next(ctx, req)

			if err != nil {
				l.Error("failed to call unary", slog.Any("error", err))
			} else {
				l.Info("success to call unary")
			}
			return res, err
		}
	}
}
