package interceptor

import (
	"context"
	"log/slog"
	"uuid"

	"connectrpc.com/connect/v2"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
)

// NewLogInterceptor は RPC 単位のロガー (rpc_name, request_id 付き) を context に載せ、
// 呼び出し結果をログ出力する ServerInterceptor を返す。
func NewLogInterceptor(l *slog.Logger) connect.ServerInterceptor {
	return func(next connect.ServerFunc) connect.ServerFunc {
		return func(ctx context.Context, spec connect.Spec, stream connect.ServerStream) error {
			ctx = logger.SetLogger(ctx, l.With(
				slog.String("rpc_name", getRPCNameFromSpec(spec)),
				slog.String("request_id", uuid.New().String()),
			))

			if spec.StreamType == connect.StreamTypeUnary {
				err := next(ctx, spec, stream)
				if err != nil {
					logger.FromCtx(ctx).Error("failed to call unary", slog.Any("error", err))
				} else {
					logger.FromCtx(ctx).Info("success to call unary")
				}
				return err
			}

			logger.FromCtx(ctx).Info("success to connect streaming")

			if err := next(ctx, spec, stream); err != nil {
				logger.FromCtx(ctx).Error("failed to streaming", slog.Any("error", err))
				return err
			}

			logger.FromCtx(ctx).Info("success to disconnect streaming")

			return nil
		}
	}
}
