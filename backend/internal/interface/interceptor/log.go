package interceptor

import (
	"context"
	"errors"
	"log/slog"
	"uuid"

	"connectrpc.com/connect/v2"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

// NewLogInterceptor は RPC 単位のロガー (rpc_name, request_id 付き) を context に載せ、
// 呼び出し結果をエラーの責任の所在に応じたレベルで記録する ServerInterceptor を返す。
func NewLogInterceptor(l *slog.Logger) connect.ServerInterceptor {
	return func(next connect.ServerFunc) connect.ServerFunc {
		return func(ctx context.Context, spec connect.Spec, stream connect.ServerStream) error {
			ctx = logger.SetLogger(ctx, l.With(
				slog.String("rpc_name", getRPCNameFromSpec(spec)),
				slog.String("request_id", uuid.New().String()),
			))

			if spec.StreamType == connect.StreamTypeUnary {
				err := next(ctx, spec, stream)
				logResult(ctx, "success to call unary", "failed to call unary", err)
				return err
			}

			logger.FromCtx(ctx).Info("success to connect streaming")

			err := next(ctx, spec, stream)
			logResult(ctx, "success to disconnect streaming", "failed to streaming", err)
			return err
		}
	}
}

// logResult は RPC の結果を、エラーの責任の所在に応じたレベルで記録する。
//
//   - 成功 / クライアント切断 (Canceled): INFO。運用上は正常系
//   - クライアント起因 (InvalidArgument, NotFound, 認可・前提条件違反等)、一時的な競合 (Unavailable)、
//     タイムアウト (DeadlineExceeded): WARN
//   - サーバー起因 (Internal) と分類できないもの: ERROR。アラート対象
func logResult(ctx context.Context, successMsg, failMsg string, err error) {
	l := logger.FromCtx(ctx)
	if err == nil {
		l.Info(successMsg)
		return
	}

	l.Log(ctx, levelOf(err), failMsg,
		slog.String("kind", merror.KindOf(err).String()),
		slog.Any("error", err),
	)
}

func levelOf(err error) slog.Level {
	// context エラーは merror の Kind より優先する (rpcerr.ToConnect と同じ方針)。
	// redis クライアントは context エラーも WrapInternal で包むため、Kind を先に見ると ERROR になる
	if errors.Is(err, context.Canceled) {
		return slog.LevelInfo
	}
	if errors.Is(err, context.DeadlineExceeded) {
		return slog.LevelWarn
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
