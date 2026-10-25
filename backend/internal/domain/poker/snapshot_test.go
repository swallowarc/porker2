package poker

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

func TestRoom_Snapshot_Restore_RoundTrip(t *testing.T) {
	r := NewRoom()
	u1 := join(t, r, "User1")
	u2 := join(t, r, "User2")
	r.Vote(u1, Point5)
	r.ToggleObserverMode(u2, true)
	r.UpdateSetting(false, DisplayModeTShirt)

	restored, err := RestoreRoom(r.Snapshot())
	require.NoError(t, err)

	assert.Equal(t, r.RoomID(), restored.RoomID())
	assert.Equal(t, r.AdminUserID(), restored.AdminUserID())
	assert.Equal(t, r.VoteState(), restored.VoteState())
	assert.Equal(t, r.AutoOpen(), restored.AutoOpen())
	assert.Equal(t, r.DisplayMode(), restored.DisplayMode())
	assert.Equal(t, r.Ballots(), restored.Ballots())
	assert.Equal(t, int32(1), restored.ObserverCount())
}

func TestRoom_Snapshot_EmptyRoom(t *testing.T) {
	s := NewRoom().Snapshot()
	assert.Equal(t, "", s.AdminUserID, "部屋が空なら管理者は空文字")
	assert.Empty(t, s.Ballots)

	restored, err := RestoreRoom(s)
	require.NoError(t, err)
	assert.True(t, restored.AdminUserID().IsZero())
}

func TestRestoreRoom_CorruptedDataIsInternal(t *testing.T) {
	valid := func() RoomSnapshot {
		r := NewRoom()
		join(t, r, "User1")
		return r.Snapshot()
	}

	cases := map[string]func(s *RoomSnapshot){
		"room id":      func(s *RoomSnapshot) { s.RoomID = "abc" },
		"admin id":     func(s *RoomSnapshot) { s.AdminUserID = "not-uuid" },
		"vote state":   func(s *RoomSnapshot) { s.VoteState = 0 },
		"display mode": func(s *RoomSnapshot) { s.DisplayMode = 9 },
		"ballot id":    func(s *RoomSnapshot) { s.Ballots[0].UserID = "x" },
		"ballot name":  func(s *RoomSnapshot) { s.Ballots[0].UserName = "" },
		"ballot point": func(s *RoomSnapshot) { s.Ballots[0].Point = 42 },
		"ballot role":  func(s *RoomSnapshot) { s.Ballots[0].Role = 0 },
	}
	for name, corrupt := range cases {
		t.Run(name, func(t *testing.T) {
			s := valid()
			corrupt(&s)
			_, err := RestoreRoom(s)
			assert.True(t, merror.IsInternal(err), "got: %v", err)
		})
	}
}

func TestEnumConstructors(t *testing.T) {
	for _, p := range PointList {
		got, err := NewPoint(p.Int32())
		assert.NoError(t, err)
		assert.Equal(t, p, got)
	}
	for _, raw := range []int32{10, 99, 102, -1} {
		_, err := NewPoint(raw)
		assert.True(t, merror.IsInvalidArgument(err), "point raw=%d err=%v", raw, err)
	}

	for _, want := range []DisplayMode{DisplayModePoint, DisplayModeTShirt} {
		got, err := NewDisplayMode(want.Int32())
		assert.NoError(t, err)
		assert.Equal(t, want, got)
	}
	for _, raw := range []int32{0, 3, -1} {
		_, err := NewDisplayMode(raw)
		assert.True(t, merror.IsInvalidArgument(err), "display mode raw=%d err=%v", raw, err)
	}

	for _, want := range []VoteState{VoteStateHide, VoteStateOpen} {
		got, err := NewVoteState(want.Int32())
		assert.NoError(t, err)
		assert.Equal(t, want, got)
	}
	_, err := NewVoteState(0)
	assert.True(t, merror.IsInvalidArgument(err))

	for _, want := range []UserRole{UserRoleVoter, UserRoleObserver} {
		got, err := NewUserRole(want.Int32())
		assert.NoError(t, err)
		assert.Equal(t, want, got)
	}
	_, err = NewUserRole(0)
	assert.True(t, merror.IsInvalidArgument(err))

	_ = user.NewID()
}
