package interceptor

import (
	"context"

	"connectrpc.com/connect/v2"

	"github.com/swallowarc/porker2/backend/internal/interface/rpcerr"
)

// NewErrorInterceptor はハンドラが返したアプリケーションエラーを connect のエラーに変換する
// ServerInterceptor を返す。最も外側に配置し、内側の interceptor (ログ等) は変換前の merror を参照できるようにする。
func NewErrorInterceptor() connect.ServerInterceptor {
	return func(next connect.ServerFunc) connect.ServerFunc {
		return func(ctx context.Context, spec connect.Spec, stream connect.ServerStream) error {
			return rpcerr.ToConnect(next(ctx, spec, stream))
		}
	}
}
