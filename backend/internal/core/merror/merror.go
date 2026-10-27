// Package merror はアプリケーション全体で使うエラー表現を提供する。
// RPC フレームワークには依存しない。connect のエラーコードへの変換は interface 層 (rpcerr) が担う。
package merror

import (
	"errors"
	"fmt"
)

// Kind はエラーの種別。クライアントへの応答コードを決める根拠になる。
type Kind int

const (
	KindUnknown Kind = iota
	KindInvalidArgument
	KindNotFound
	KindAlreadyExists
	KindPermissionDenied
	KindUnauthenticated
	KindFailedPrecondition
	KindUnavailable
	KindInternal
	KindCanceled
)

var kindNames = map[Kind]string{
	KindUnknown:            "unknown",
	KindInvalidArgument:    "invalid_argument",
	KindNotFound:           "not_found",
	KindAlreadyExists:      "already_exists",
	KindPermissionDenied:   "permission_denied",
	KindUnauthenticated:    "unauthenticated",
	KindFailedPrecondition: "failed_precondition",
	KindUnavailable:        "unavailable",
	KindInternal:           "internal",
	KindCanceled:           "canceled",
}

func (k Kind) String() string {
	if s, ok := kindNames[k]; ok {
		return s
	}
	return fmt.Sprintf("kind(%d)", int(k))
}

type (
	// FieldViolation は InvalidArgument におけるフィールド単位の違反内容。
	FieldViolation struct {
		Field       string
		Description string
	}

	FieldViolations []FieldViolation

	// Error は種別付きのアプリケーションエラー。
	Error struct {
		kind            Kind
		msg             string
		err             error
		fieldViolations FieldViolations
	}
)

func (e *Error) Error() string {
	if e.err != nil {
		return e.msg + ": " + e.err.Error()
	}
	return e.msg
}

func (e *Error) Unwrap() error { return e.err }

func (e *Error) Kind() Kind { return e.kind }

func (e *Error) FieldViolations() FieldViolations { return e.fieldViolations }

// New は種別とメッセージからエラーを作る。
func New(kind Kind, messageFormat string, args ...any) error {
	return &Error{kind: kind, msg: fmt.Sprintf(messageFormat, args...)}
}

// Wrap は既存のエラーを種別付きで包む。
// 包んだ側の種別が優先される (KindOf は最も外側の *Error を見る)。
// 下位層の種別を呼び出し側に伝えたい場合は Wrap せずそのまま返すこと。
func Wrap(kind Kind, err error, messageFormat string, args ...any) error {
	return &Error{kind: kind, msg: fmt.Sprintf(messageFormat, args...), err: err}
}

// KindOf はエラーの種別を返す。*Error を含まないエラーは KindUnknown。
func KindOf(err error) Kind {
	var e *Error
	if errors.As(err, &e) {
		return e.kind
	}
	return KindUnknown
}

// FieldViolationsOf はエラーに含まれるフィールド違反を返す。なければ nil。
func FieldViolationsOf(err error) FieldViolations {
	var e *Error
	if errors.As(err, &e) {
		return e.fieldViolations
	}
	return nil
}

func NewNotFound(messageFormat string, args ...any) error {
	return New(KindNotFound, messageFormat, args...)
}

func IsNotFound(err error) bool { return KindOf(err) == KindNotFound }

func NewFailedPrecondition(messageFormat string, args ...any) error {
	return New(KindFailedPrecondition, messageFormat, args...)
}

func IsFailedPrecondition(err error) bool { return KindOf(err) == KindFailedPrecondition }

func NewPermissionDenied(messageFormat string, args ...any) error {
	return New(KindPermissionDenied, messageFormat, args...)
}

func IsPermissionDenied(err error) bool { return KindOf(err) == KindPermissionDenied }

func NewInvalidArgument(fvs FieldViolations, messageFormat string, args ...any) error {
	return &Error{
		kind:            KindInvalidArgument,
		msg:             fmt.Sprintf(messageFormat, args...),
		fieldViolations: fvs,
	}
}

func IsInvalidArgument(err error) bool { return KindOf(err) == KindInvalidArgument }

func NewInternal(messageFormat string, args ...any) error {
	return New(KindInternal, messageFormat, args...)
}

func WrapInternal(err error, messageFormat string, args ...any) error {
	return Wrap(KindInternal, err, messageFormat, args...)
}

func IsInternal(err error) bool { return KindOf(err) == KindInternal }

func NewUnauthenticated(messageFormat string, args ...any) error {
	return New(KindUnauthenticated, messageFormat, args...)
}

func IsUnauthenticated(err error) bool { return KindOf(err) == KindUnauthenticated }

func NewAlreadyExists(messageFormat string, args ...any) error {
	return New(KindAlreadyExists, messageFormat, args...)
}

func IsAlreadyExists(err error) bool { return KindOf(err) == KindAlreadyExists }

func NewUnavailable(messageFormat string, args ...any) error {
	return New(KindUnavailable, messageFormat, args...)
}

func IsUnavailable(err error) bool { return KindOf(err) == KindUnavailable }

func NewCanceled(messageFormat string, args ...any) error {
	return New(KindCanceled, messageFormat, args...)
}

func IsCanceled(err error) bool { return KindOf(err) == KindCanceled }
