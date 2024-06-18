package merror

import (
	"errors"
	"fmt"

	"connectrpc.com/connect"
	"google.golang.org/genproto/googleapis/rpc/errdetails"
)

func ViolationTypeFromError(e error) string {
	var connErr *connect.Error
	if errors.As(e, &connErr) {
		details := connErr.Details()
		for _, detail := range details {
			pb, err := detail.Value()
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

func NewNotFound(text string) error {
	return connect.NewError(connect.CodeNotFound, fmt.Errorf(text))
}

func IsNotFound(err error) bool {
	return CodeFromError(err) == connect.CodeNotFound
}

func NewFailedPrecondition(text string, violationType string) error {
	ret := connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf(text))

	if violationType == "" {
		return ret
	}

	edt := &errdetails.PreconditionFailure_Violation{
		Type: violationType,
	}
	detail, err := connect.NewErrorDetail(edt)
	if err != nil {
		return err
	}
	ret.AddDetail(detail)

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
)

func (f *FieldViolation) toProto() *errdetails.BadRequest_FieldViolation {
	return &errdetails.BadRequest_FieldViolation{
		Field:       f.Field,
		Description: f.Description,
	}
}

func NewInvalidArgument(text string, fvs ...FieldViolation) error {
	ret := connect.NewError(connect.CodeInvalidArgument, fmt.Errorf(text))

	if len(fvs) == 0 {
		return ret
	}

	for _, fv := range fvs {
		detail, err := connect.NewErrorDetail(fv.toProto())
		if err != nil {
			return err
		}
		ret.AddDetail(detail)
	}

	return ret
}

func IsInvalidArgument(err error) bool {
	return CodeFromError(err) == connect.CodeInvalidArgument
}

func NewInternal(text string) error {
	return connect.NewError(connect.CodeInternal, fmt.Errorf(text))
}

func WrapInternal(err error, message string) error {
	return connect.NewError(connect.CodeInternal, fmt.Errorf("%s: %w", message, err))
}

func IsInternal(err error) bool {
	return CodeFromError(err) == connect.CodeInternal
}

func NewUnauthenticated(text string) error {
	return connect.NewError(connect.CodeUnauthenticated, fmt.Errorf(text))
}
