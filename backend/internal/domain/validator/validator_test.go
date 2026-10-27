package validator

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

func TestValidator_Struct_ExportedFields(t *testing.T) {
	v, err := NewValidator()
	require.NoError(t, err)

	vs := struct {
		RoomID       poker.RoomID      `validate:"room_id"`
		TargetUserID user.ID           `validate:"user_id"`
		DisplayMode  poker.DisplayMode `validate:"display_mode"`
	}{
		RoomID:       "abc",
		TargetUserID: "not-a-uuid",
		DisplayMode:  poker.DisplayModeUnspecified,
	}

	fvs, err := v.Struct(vs)
	require.NoError(t, err)
	assert.Len(t, fvs, 3, "3 つのフィールド全てが違反として報告されること")

	err = v.StructWithMessage(vs, "invalid argument")
	assert.True(t, merror.IsInvalidArgument(err))
}

func TestValidator_Struct_UnexportedFieldsAreSkipped(t *testing.T) {
	// go-playground/validator は非公開フィールドを検証しない。
	// この挙動に依存して検証漏れを起こさないよう、仕様として固定しておく。
	v, err := NewValidator()
	require.NoError(t, err)

	vs := struct {
		roomID poker.RoomID `validate:"room_id"`
	}{
		roomID: "abc",
	}

	fvs, err := v.Struct(vs)
	require.NoError(t, err)
	assert.Empty(t, fvs, "非公開フィールドは検証対象にならない (検証したい構造体のフィールドは必ず公開する)")
}

func TestValidator_Var(t *testing.T) {
	v, err := NewValidator()
	require.NoError(t, err)

	assert.NoError(t, v.VarWithMessage("12345", TagRoomID, "x"))
	assert.NoError(t, v.VarWithMessage("", TagRoomID, "x"))
	assert.True(t, merror.IsInvalidArgument(v.VarWithMessage("1234", TagRoomID, "x")))
	assert.True(t, merror.IsInvalidArgument(v.VarWithMessage("あ", TagUserName, "x")))
	assert.NoError(t, v.VarWithMessage(user.NewID().String(), TagUserID, "x"))
}
