// Package rpcerr はアプリケーションエラー (merror) を connect のエラーに変換する。
// 変換はこのパッケージに集約し、usecase や domain が connect を知らずに済むようにする。
package rpcerr

import (
	"context"
	"errors"

	"connectrpc.com/connect"
	"google.golang.org/genproto/googleapis/rpc/errdetails"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

var kindToCode = map[merror.Kind]connect.Code{
	merror.KindInvalidArgument:    connect.CodeInvalidArgument,
	merror.KindNotFound:           connect.CodeNotFound,
	merror.KindAlreadyExists:      connect.CodeAlreadyExists,
	merror.KindPermissionDenied:   connect.CodePermissionDenied,
	merror.KindUnauthenticated:    connect.CodeUnauthenticated,
	merror.KindFailedPrecondition: connect.CodeFailedPrecondition,
	merror.KindUnavailable:        connect.CodeUnavailable,
	merror.KindInternal:           connect.CodeInternal,
	merror.KindCanceled:           connect.CodeCanceled,
}

// ToConnect はエラーを *connect.Error に変換する。nil は nil のまま返す。
//
//   - 既に *connect.Error を含むもの (authn.Errorf 等) はそのまま
//   - context の Canceled / DeadlineExceeded は対応するコード
//   - merror.Error は Kind に対応するコード。FieldViolations は BadRequest_FieldViolation detail に載せる
//   - それ以外の未分類エラーはサーバー側の不具合とみなし Internal
func ToConnect(err error) error {
	if err == nil {
		return nil
	}

	var cerr *connect.Error
	if errors.As(err, &cerr) {
		return err
	}

	if errors.Is(err, context.Canceled) {
		return connect.NewError(connect.CodeCanceled, err)
	}
	if errors.Is(err, context.DeadlineExceeded) {
		return connect.NewError(connect.CodeDeadlineExceeded, err)
	}

	var merr *merror.Error
	if !errors.As(err, &merr) {
		return connect.NewError(connect.CodeInternal, err)
	}

	code, ok := kindToCode[merr.Kind()]
	if !ok {
		code = connect.CodeUnknown
	}

	cerr = connect.NewError(code, err)
	for _, fv := range merr.FieldViolations() {
		detail, derr := connect.NewErrorDetail(&errdetails.BadRequest_FieldViolation{
			Field:       fv.Field,
			Description: fv.Description,
		})
		if derr != nil {
			// detail の付与失敗で本来のエラーを握りつぶさない
			continue
		}
		cerr.AddDetail(detail)
	}

	return cerr
}
