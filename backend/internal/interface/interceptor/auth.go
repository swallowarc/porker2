package interceptor

import (
	"context"
	"slices"
	"strings"

	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

var noAuthRPCs = []string{
	"Login",
}

func NewAuthUnaryInterceptor() connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			if slices.Contains(noAuthRPCs, getRPCName(req)) {
				return next(ctx, req)
			}

			// TODO: トークンの検証処理を実装する トークンをキーにストアからUserIDを引いてcontextにセットする
			token := req.Header().Get("Authorization")
			if token == "" {
				//return nil, merror.NewUnauthenticated("error: invalid token")
			}
			token = strings.TrimPrefix(token, "Bearer")
			token = strings.TrimSpace(token)

			ctx = user.SetContext(ctx, "11111111-2222-3333-4444-555555555555")
			return next(ctx, req)
		}
	}
}
