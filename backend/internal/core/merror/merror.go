package merror

import (
	"errors"
	"fmt"

	"connectrpc.com/connect/v2"
	"connectrpc.com/connect/v2/connectproto"
	"google.golang.org/genproto/googleapis/rpc/errdetails"
)

func ViolationTypeFromError(e error) string {
	var connErr *connect.Error
	if errors.As(e, &connErr) {
		details := connErr.Details()
		for _, detail := range details {
			pb, err := connectproto.UnmarshalErrorDetail(detail)
			if err != nil {
				continue
			}
			if violation, ok := pb.(*errdetails.PreconditionFailure_Violation); ok {
				return violation.Type
			}
		}
	}
	return ""
}

func CodeFromError(err error) connect.Code {
	var connErr *connect.Error
	if errors.As(err, &connErr) {
		return connErr.Code()
	}
	return connect.CodeUnknown
}

func NewNotFound(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeNotFound, messageFormat, args...)
}

func IsNotFound(err error) bool {
	return CodeFromError(err) == connect.CodeNotFound
}

func NewFailedPrecondition(violationType string, messageFormat string, args ...any) error {
	ret := connect.Errorf(connect.CodeFailedPrecondition, messageFormat, args...)

	if violationType == "" {
		return ret
	}

	edt := &errdetails.PreconditionFailure_Violation{
		Type: violationType,
	}
	detail, err := connectproto.NewErrorDetail(edt)
	if err != nil {
		return err
	}
	ret = ret.WithDetail(detail)

	return ret
}

func IsFailedPrecondition(err error) bool {
	return CodeFromError(err) == connect.CodeFailedPrecondition
}

type (
	FieldViolation struct {
		Field       string
		Description string
	}

	FieldViolations []FieldViolation
)

func (f *FieldViolation) toProto() *errdetails.BadRequest_FieldViolation {
	return &errdetails.BadRequest_FieldViolation{
		Field:       f.Field,
		Description: f.Description,
	}
}

func NewPermissionDenied(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodePermissionDenied, messageFormat, args...)
}

func NewInvalidArgument(fvs FieldViolations, messageFormat string, args ...any) error {
	ret := connect.Errorf(connect.CodeInvalidArgument, messageFormat, args...)
	if len(fvs) == 0 {
		return ret
	}

	for _, fv := range fvs {
		detail, err := connectproto.NewErrorDetail(fv.toProto())
		if err != nil {
			return err
		}
		ret = ret.WithDetail(detail)
	}

	return ret
}

func IsInvalidArgument(err error) bool {
	return CodeFromError(err) == connect.CodeInvalidArgument
}

func NewInternal(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeInternal, messageFormat, args...)
}

func WrapInternal(err error, messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeInternal, "%s: %v", fmt.Sprintf(messageFormat, args...), err).WithCause(err)
}

func IsInternal(err error) bool {
	return CodeFromError(err) == connect.CodeInternal
}

func NewUnauthenticated(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeUnauthenticated, messageFormat, args...)
}

func NewAlreadyExists(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeAlreadyExists, messageFormat, args...)
}

func IsAlreadyExists(err error) bool {
	return CodeFromError(err) == connect.CodeAlreadyExists
}

func NewUnavailable(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeUnavailable, messageFormat, args...)
}

func IsCanceled(err error) bool {
	return CodeFromError(err) == connect.CodeCanceled
}

func NewCanceled(messageFormat string, args ...any) error {
	return connect.Errorf(connect.CodeCanceled, messageFormat, args...)
}
