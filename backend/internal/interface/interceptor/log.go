package interceptor

import (
	"context"
	"log/slog"

	"connectrpc.com/connect"
	"github.com/google/uuid"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
)

type (
	LogInterceptor struct {
		l *slog.Logger
	}
)

func NewLogInterceptor(l *slog.Logger) connect.Interceptor {
	return &LogInterceptor{
		l: l,
	}
}

func (i *LogInterceptor) WrapUnary(next connect.UnaryFunc) connect.UnaryFunc {
	return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		ctx = logger.SetLogger(ctx, i.l.With(
			slog.String("rpc_name", getRPCNameFromSpec(req.Spec())),
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

func (*LogInterceptor) WrapStreamingClient(next connect.StreamingClientFunc) connect.StreamingClientFunc {
	return func(
		ctx context.Context,
		spec connect.Spec,
	) connect.StreamingClientConn {
		conn := next(ctx, spec)
		return conn
	}
}

func (i *LogInterceptor) WrapStreamingHandler(next connect.StreamingHandlerFunc) connect.StreamingHandlerFunc {
	return func(
		ctx context.Context,
		conn connect.StreamingHandlerConn,
	) error {
		ctx = logger.SetLogger(ctx, i.l.With(
			slog.String("rpc_name", getRPCNameFromSpec(conn.Spec())),
			slog.String("request_id", uuid.NewString()),
		))

		logger.FromCtx(ctx).Info("success to connect streaming")

		err := next(ctx, conn)
		if err != nil {
			logger.FromCtx(ctx).Error("failed to streaming", slog.Any("error", err))
		} else {
			logger.FromCtx(ctx).Info("success to disconnect streaming")
		}

		return err
	}
}
