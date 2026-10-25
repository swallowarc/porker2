package interceptor

import (
	"context"
	"errors"
	"log/slog"
	"uuid"

	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
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
			slog.String("request_id", uuid.New().String()),
		))

		res, err := next(ctx, req)
		logResult(ctx, "unary", err)

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
			slog.String("request_id", uuid.New().String()),
		))

		logger.FromCtx(ctx).Info("streaming connected")

		err := next(ctx, conn)
		logResult(ctx, "streaming", err)

		return err
	}
}

// logResult は RPC の結果を、エラーの責任の所在に応じたレベルで記録する。
//
//   - 成功 / クライアント切断 (Canceled): INFO。運用上は正常系
//   - クライアント起因 (InvalidArgument, NotFound, 認可・前提条件違反等) と一時的な競合 (Unavailable): WARN
//   - サーバー起因 (Internal) と分類できないもの: ERROR。アラート対象
func logResult(ctx context.Context, kind string, err error) {
	l := logger.FromCtx(ctx)
	if err == nil {
		l.Info("success to call " + kind)
		return
	}

	l.Log(ctx, levelOf(err), "failed to call "+kind,
		slog.String("kind", merror.KindOf(err).String()),
		slog.Any("error", err),
	)
}

func levelOf(err error) slog.Level {
	if errors.Is(err, context.Canceled) {
		return slog.LevelInfo
	}

	switch merror.KindOf(err) {
	case merror.KindCanceled:
		return slog.LevelInfo
	case merror.KindInvalidArgument,
		merror.KindNotFound,
		merror.KindAlreadyExists,
		merror.KindPermissionDenied,
		merror.KindUnauthenticated,
		merror.KindFailedPrecondition,
		merror.KindUnavailable:
		return slog.LevelWarn
	case merror.KindInternal:
		return slog.LevelError
	}

	// merror 以外 (ErrorInterceptor は外側にあるので、ここに来る connect.Error は
	// ハンドラが直接返したもの)。connect のコードで判定する
	var cerr *connect.Error
	if errors.As(err, &cerr) {
		switch cerr.Code() {
		case connect.CodeCanceled:
			return slog.LevelInfo
		case connect.CodeInternal, connect.CodeUnknown, connect.CodeDataLoss, connect.CodeUnimplemented:
			return slog.LevelError
		default:
			return slog.LevelWarn
		}
	}

	return slog.LevelError
}
