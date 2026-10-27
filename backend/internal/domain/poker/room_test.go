package poker

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

// join は新しいユーザーを部屋に参加させ、その ID を返す。
func join(t *testing.T, r *Room, name string) user.ID {
	t.Helper()
	id := user.NewID()
	require.NoError(t, r.Join(id, user.MustName(name)))
	return id
}

func ballotOf(t *testing.T, r *Room, id user.ID) Ballot {
	t.Helper()
	for _, b := range r.Ballots() {
		if b.UserID() == id {
			return b
		}
	}
	t.Fatalf("ballot not found: %s", id)
	return Ballot{}
}

func TestNewRoom(t *testing.T) {
	r := NewRoom()

	assert.False(t, r.RoomID().IsZero())
	assert.True(t, r.AdminUserID().IsZero())
	assert.Equal(t, VoteStateHide, r.VoteState())
	assert.Empty(t, r.Ballots())
	assert.True(t, r.AutoOpen())
	assert.Equal(t, DisplayModePoint, r.DisplayMode())
	assert.Equal(t, int32(0), r.ObserverCount())
}

func TestRoom_Join(t *testing.T) {
	r := NewRoom()

	// 最初のユーザーは管理者になる
	u1 := join(t, r, "User1")
	assert.Equal(t, u1, r.AdminUserID())
	assert.Len(t, r.Ballots(), 1)

	// 2人目のユーザーは通常メンバー
	join(t, r, "User2")
	assert.Equal(t, u1, r.AdminUserID())
	assert.Len(t, r.Ballots(), 2)

	// 既に参加しているユーザーが再参加しても増えない
	assert.NoError(t, r.Join(u1, user.MustName("User1")))
	assert.Len(t, r.Ballots(), 2)

	// 部屋が満員の場合
	r = NewRoom()
	for i := range MaxMember {
		join(t, r, fmt.Sprintf("User%d", i))
	}
	assert.ErrorIs(t, r.Join(user.NewID(), user.MustName("Extra")), ErrRoomFull)
	assert.False(t, r.CanJoin())
}

func TestRoom_Vote(t *testing.T) {
	r := NewRoom()
	u1 := join(t, r, "User1")
	u2 := join(t, r, "User2")

	r.Vote(u1, Point5)
	assert.Equal(t, Point5, ballotOf(t, r, u1).Point())

	// 開票後は投票できない
	r.Open()
	r.Vote(u2, Point8)
	assert.Equal(t, PointUnspecified, ballotOf(t, r, u2).Point())

	// 観戦者は投票できない
	r.Reset()
	r.ToggleObserverMode(u2, true)
	r.Vote(u2, Point8)
	assert.Equal(t, PointUnspecified, ballotOf(t, r, u2).Point())

	// 部屋にいないユーザーの投票は無視される
	r.Vote(user.NewID(), Point8)
	assert.Len(t, r.Ballots(), 2)
}

func TestRoom_Leave(t *testing.T) {
	r := NewRoom()
	u1 := join(t, r, "User1")
	u2 := join(t, r, "User2")

	// 通常メンバーの退出
	r.Leave(u2)
	assert.Len(t, r.Ballots(), 1)
	assert.Equal(t, u1, r.AdminUserID())

	// 管理者の退出で管理者が引き継がれる
	u2 = join(t, r, "User2")
	r.Leave(u1)
	assert.Len(t, r.Ballots(), 1)
	assert.Equal(t, u2, r.AdminUserID())

	// 全員退出
	r.Leave(u2)
	assert.Empty(t, r.Ballots())
	assert.True(t, r.AdminUserID().IsZero())
}

func TestRoom_Open_Reset(t *testing.T) {
	r := NewRoom()
	u1 := join(t, r, "User1")
	r.UpdateSetting(false, DisplayModePoint)
	r.Vote(u1, Point3)

	r.Open()
	assert.Equal(t, VoteStateOpen, r.VoteState())
	assert.False(t, r.CanVote())

	r.Reset()
	assert.Equal(t, VoteStateHide, r.VoteState())
	assert.Equal(t, PointUnspecified, ballotOf(t, r, u1).Point())
}

func TestRoom_Kick(t *testing.T) {
	t.Run("管理者がキック", func(t *testing.T) {
		r := NewRoom()
		admin := join(t, r, "Admin")
		u1 := join(t, r, "User1")

		assert.NoError(t, r.Kick(admin, u1))
		assert.Len(t, r.Ballots(), 1)
		assert.False(t, r.IsUserIn(u1))
	})

	t.Run("管理者でないユーザーはキックできない", func(t *testing.T) {
		r := NewRoom()
		admin := join(t, r, "Admin")
		u1 := join(t, r, "User1")

		assert.ErrorIs(t, r.Kick(u1, admin), ErrNotAdmin)
		assert.Len(t, r.Ballots(), 2)
	})

	t.Run("管理者が自分自身をキックすると管理者が引き継がれる", func(t *testing.T) {
		r := NewRoom()
		admin := join(t, r, "Admin")
		u1 := join(t, r, "User1")

		assert.NoError(t, r.Kick(admin, admin))
		assert.Len(t, r.Ballots(), 1)
		assert.False(t, r.IsUserIn(admin))
		assert.Equal(t, u1, r.AdminUserID())
	})

	t.Run("未投票者をキックすると残り全員投票済みになり自動開票", func(t *testing.T) {
		r := NewRoom()
		admin := join(t, r, "Admin")
		u1 := join(t, r, "User1")
		r.Vote(admin, Point3)
		assert.Equal(t, VoteStateHide, r.VoteState())

		assert.NoError(t, r.Kick(admin, u1))
		assert.Equal(t, VoteStateOpen, r.VoteState())
	})
}

func TestRoom_UpdateSetting(t *testing.T) {
	r := NewRoom()
	r.UpdateSetting(false, DisplayModeTShirt)
	assert.False(t, r.AutoOpen())
	assert.Equal(t, DisplayModeTShirt, r.DisplayMode())
}

func TestRoom_AutoOpen(t *testing.T) {
	r := NewRoom()
	u1 := join(t, r, "User1")
	u2 := join(t, r, "User2")

	// 全員が投票すると自動的に開票される
	r.Vote(u1, Point3)
	assert.Equal(t, VoteStateHide, r.VoteState())
	r.Vote(u2, Point5)
	assert.Equal(t, VoteStateOpen, r.VoteState())

	// 自動開票が無効の場合
	r.Reset()
	r.UpdateSetting(false, DisplayModePoint)
	r.Vote(u1, Point3)
	r.Vote(u2, Point5)
	assert.Equal(t, VoteStateHide, r.VoteState())
}

func TestRoom_ObserverCount(t *testing.T) {
	r := NewRoom()
	admin := join(t, r, "Admin")
	u1 := join(t, r, "User1")
	u2 := join(t, r, "User2")
	assert.Equal(t, int32(0), r.ObserverCount())

	r.ToggleObserverMode(u1, true)
	r.ToggleObserverMode(u2, true)
	assert.Equal(t, int32(2), r.ObserverCount())
	assert.True(t, ballotOf(t, r, u1).IsObserver())
	assert.Equal(t, UserRoleObserver, ballotOf(t, r, u1).Role())

	// 観戦者が退室したら減る
	r.Leave(u1)
	assert.Equal(t, int32(1), r.ObserverCount())

	// 観戦者がキックされたら減る
	assert.NoError(t, r.Kick(admin, u2))
	assert.Equal(t, int32(0), r.ObserverCount())

	r.ToggleObserverMode(admin, true)
	assert.Equal(t, int32(1), r.ObserverCount())
	r.ToggleObserverMode(admin, false)
	assert.Equal(t, int32(0), r.ObserverCount())
	assert.Equal(t, UserRoleVoter, ballotOf(t, r, admin).Role())
}

func TestRoom_Ballots_IsCopy(t *testing.T) {
	r := NewRoom()
	u1 := join(t, r, "User1")

	ballots := r.Ballots()
	ballots[0] = Ballot{}
	ballots = append(ballots, Ballot{})

	assert.Len(t, ballots, 2)
	assert.Len(t, r.Ballots(), 1, "返り値の変更は部屋に影響しない")
	assert.Equal(t, u1, r.Ballots()[0].UserID())
}
