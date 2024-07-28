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
			rpcName := getRPCName(req)

			ctx = logger.SetLogger(ctx, l.With(
				slog.String("rpc_name", rpcName),
				slog.String("request_id", uuid.NewString()),
			))

			res, err := next(ctx, req)

			if err != nil {
				logger.FromCtx(ctx).Error("failed to call unary", slog.Any("error", err))
			} else {
				logger.FromCtx(ctx).Info("success to call unary")
			}
			return res, err
		}
	}
}
