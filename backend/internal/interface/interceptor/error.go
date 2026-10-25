package interceptor

import (
	"context"

	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/interface/rpcerr"
)

type (
	// ErrorInterceptor はハンドラが返したアプリケーションエラーを connect のエラーに変換する。
	// 最も外側に配置し、内側の interceptor (ログ等) は変換前の merror を参照できるようにする。
	ErrorInterceptor struct{}
)

func NewErrorInterceptor() connect.Interceptor {
	return &ErrorInterceptor{}
}

func (*ErrorInterceptor) WrapUnary(next connect.UnaryFunc) connect.UnaryFunc {
	return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		res, err := next(ctx, req)
		return res, rpcerr.ToConnect(err)
	}
}

func (*ErrorInterceptor) WrapStreamingClient(next connect.StreamingClientFunc) connect.StreamingClientFunc {
	return next
}

func (*ErrorInterceptor) WrapStreamingHandler(next connect.StreamingHandlerFunc) connect.StreamingHandlerFunc {
	return func(ctx context.Context, conn connect.StreamingHandlerConn) error {
		return rpcerr.ToConnect(next(ctx, conn))
	}
}
