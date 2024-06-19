package validator

import (
	"strconv"

	govalidator "github.com/go-playground/validator/v10"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

const (
	TagRoomID   = "room_id"
	TagPoint    = "point"
	TagUserName = "user_name"
	TagUserID   = "user_id"
)

func presetCustomValidations() CustomValidations {
	return CustomValidations{
		TagRoomID:   roomID,
		TagPoint:    point,
		TagUserName: userName,
		TagUserID:   userID,
	}
}

func roomID(fl govalidator.FieldLevel) bool {
	v := fl.Field().String()
	if v == "" {
		return true
	}

	return poker.RoomID(v).Valid()
}

func point(fl govalidator.FieldLevel) bool {
	v := fl.Field().String()
	n, err := strconv.Atoi(v)
	if err != nil {
		return false
	}

	return poker.Point(n).Valid()
}

func userName(fl govalidator.FieldLevel) bool {
	v := fl.Field().String()
	return user.Name(v).Valid()
}

func userID(fl govalidator.FieldLevel) bool {
	v := fl.Field().String()
	return user.ID(v).Valid()
}
