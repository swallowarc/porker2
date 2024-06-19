package interceptor

import (
	"context"
	"strings"

	"connectrpc.com/connect"
)

func NewAuthUnaryInterceptor() connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			// TODO: トークンの検証処理を実装する トークンからUserIDを引いてcontextにセットする
			token := req.Header().Get("Authorization")
			if token == "" {
				//return nil, merror.NewUnauthenticated("error: invalid token")
			}
			token = strings.TrimPrefix(token, "Bearer")
			token = strings.TrimSpace(token)

			return next(ctx, req)
		}
	}
}
