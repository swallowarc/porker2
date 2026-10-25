package controller

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
)

func TestRequestFields_Valid(t *testing.T) {
	var f requestFields
	uid := user.NewID()

	assert.Equal(t, poker.MustRoomID("12345"), f.roomID("12345"))
	assert.Equal(t, user.MustName("alice"), f.userName("alice"))
	assert.Equal(t, uid, f.userID("target_user_id", uid.String()))
	assert.Equal(t, poker.Point5, f.point(pb.Point_POINT_5))
	assert.Equal(t, poker.PointUnspecified, f.point(pb.Point_POINT_UNSPECIFIED), "未投票に戻す操作として許容")
	assert.Equal(t, poker.DisplayModeTShirt, f.displayMode(pb.DisplayMode_DISPLAY_MODE_TSHIRT))

	assert.NoError(t, f.err())
}

func TestRequestFields_CollectsAllViolations(t *testing.T) {
	var f requestFields
	f.roomID("abc")
	f.userName("")
	f.userID("target_user_id", "not-uuid")
	f.point(pb.Point(42))
	f.displayMode(pb.DisplayMode_DISPLAY_MODE_UNSPECIFIED)

	err := f.err()
	require.True(t, merror.IsInvalidArgument(err), "got: %v", err)

	fvs := merror.FieldViolationsOf(err)
	fields := make([]string, 0, len(fvs))
	for _, fv := range fvs {
		fields = append(fields, fv.Field)
		assert.NotEmpty(t, fv.Description)
	}
	assert.Equal(t, []string{"room_id", "user_name", "target_user_id", "point", "display_mode"}, fields,
		"全フィールドの違反が proto のフィールド名付きで報告されること")
}

func TestRequestFields_EmptyRoomIDIsRejected(t *testing.T) {
	var f requestFields
	f.roomID("")
	assert.True(t, merror.IsInvalidArgument(f.err()))
}
