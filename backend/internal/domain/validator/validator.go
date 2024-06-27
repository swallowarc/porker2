package validator

import (
	"errors"

	govalidator "github.com/go-playground/validator/v10"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

type (
	Validator interface {
		Var(any, string) (merror.FieldViolations, error)
		VarWithMessage(any, string, string, ...any) error
		Struct(any) (merror.FieldViolations, error)
		StructWithMessage(any, string, ...any) error
	}

	validator struct {
		govalidator *govalidator.Validate
	}

	CustomValidations map[string]govalidator.Func
)

func NewValidator() (Validator, error) {
	validations := presetCustomValidations()
	gv := govalidator.New()
	for tag, fn := range validations {
		if err := gv.RegisterValidation(tag, fn); err != nil {
			return nil, merror.WrapInternal(err, "failed to register validation: %v", err)
		}
	}

	return &validator{
		govalidator: gv,
	}, nil
}

func (v *validator) Var(s any, tag string) (merror.FieldViolations, error) {
	err := v.govalidator.Var(s, tag)
	return v.convertValidationErrors(err)
}

func (v *validator) VarWithMessage(s any, tag, messageFormat string, args ...any) error {
	fvs, err := v.Var(s, tag)
	if err != nil {
		return err
	}
	if len(fvs) > 0 {
		return merror.NewInvalidArgument(fvs, messageFormat, args...)
	}

	return nil
}

func (v *validator) Struct(s any) (merror.FieldViolations, error) {
	err := v.govalidator.Struct(s)
	return v.convertValidationErrors(err)
}

func (v *validator) StructWithMessage(s any, messageFormat string, args ...any) error {
	fvs, err := v.Struct(s)
	if err != nil {
		return err
	}
	if len(fvs) > 0 {
		return merror.NewInvalidArgument(fvs, messageFormat, args...)
	}

	return nil
}

func (v *validator) convertValidationErrors(err error) (merror.FieldViolations, error) {
	if err == nil {
		return merror.FieldViolations{}, nil
	}

	var ves govalidator.ValidationErrors
	if !errors.As(err, &ves) {
		return nil, merror.WrapInternal(err, "failed to cast to ValidationErrors: %v", err)
	}

	fvs := make(merror.FieldViolations, len(ves))
	for i, fe := range ves {
		fv := merror.FieldViolation{
			Field:       fe.Field(),
			Description: fe.Error(),
		}
		fvs[i] = fv
	}

	return fvs, nil
}
