package poker

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

func TestNewRoomCondition(t *testing.T) {
	c := NewRoomCondition()

	assert.NotEmpty(t, c.RoomID)
	assert.Equal(t, user.ID(""), c.AdminUserID)
	assert.Equal(t, VoteStateHide, c.VoteState)
	assert.Empty(t, c.Ballots)
	assert.True(t, c.AutoOpen)
	assert.Equal(t, DisplayModePoint, c.DisplayMode)
}

func TestRoomCondition_Join(t *testing.T) {
	c := NewRoomCondition()

	// 最初のユーザーは管理者になる
	err := c.Join("user1", "User 1")
	assert.NoError(t, err)
	assert.Equal(t, user.ID("user1"), c.AdminUserID)
	assert.Len(t, c.Ballots, 1)

	// 2人目のユーザーは通常メンバー
	err = c.Join("user2", "User 2")
	assert.NoError(t, err)
	assert.Equal(t, user.ID("user1"), c.AdminUserID)
	assert.Len(t, c.Ballots, 2)

	// 既に参加しているユーザーが再参加
	err = c.Join("user1", "User 1")
	assert.NoError(t, err)
	assert.Len(t, c.Ballots, 2)

	// 部屋が満員の場合
	maxMembers := MaxMember
	c = NewRoomCondition()
	for i := 0; i < maxMembers; i++ {
		err = c.Join(user.NewID(), user.Name(fmt.Sprintf("User%d", i)))
		assert.NoError(t, err)
	}
	err = c.Join("extra", "Extra")
	assert.ErrorIs(t, err, ErrRoomFull)
}

func TestRoomCondition_Vote(t *testing.T) {
	c := NewRoomCondition()
	assert.NoError(t, c.Join("user1", "User 1"))
	assert.NoError(t, c.Join("user2", "User 2"))

	// 投票
	c.Vote("user1", Point5)
	assert.Equal(t, Point5, c.Ballots[0].Point)

	// 投票状態が開いている場合、投票できない
	c.VoteState = VoteStateOpen
	c.Vote("user2", Point8)
	assert.Equal(t, PointUnspecified, c.Ballots[1].Point)
}

func TestRoomCondition_Leave(t *testing.T) {
	c := NewRoomCondition()
	assert.NoError(t, c.Join("user1", "User 1"))
	assert.NoError(t, c.Join("user2", "User 2"))

	// 通常メンバーの退出
	c.Leave("user2")
	assert.Len(t, c.Ballots, 1)
	assert.Equal(t, user.ID("user1"), c.AdminUserID)

	// 管理者の退出
	c.Join("user2", "User 2")
	c.Leave("user1")
	assert.Len(t, c.Ballots, 1)
	assert.Equal(t, user.ID("user2"), c.AdminUserID)

	// 全員退出
	c.Leave("user2")
	assert.Len(t, c.Ballots, 0)
	assert.Equal(t, user.ID(""), c.AdminUserID)
}

func TestRoomCondition_Open_Reset(t *testing.T) {
	c := NewRoomCondition()
	assert.NoError(t, c.Join("user1", "User 1"))
	c.Vote("user1", Point3)

	// 開票
	c.Open()
	assert.Equal(t, VoteStateOpen, c.VoteState)

	// リセット
	c.Reset()
	assert.Equal(t, VoteStateHide, c.VoteState)
	assert.Equal(t, PointUnspecified, c.Ballots[0].Point)
}

func TestRoomCondition_Kick(t *testing.T) {
	c := NewRoomCondition()
	assert.NoError(t, c.Join("admin", "Admin"))
	assert.NoError(t, c.Join("user1", "User 1"))

	// 管理者がキック
	err := c.Kick("admin", "user1")
	assert.NoError(t, err)
	assert.Len(t, c.Ballots, 1)

	// 管理者でないユーザーがキック
	assert.NoError(t, c.Join("user1", "User 1"))
	err = c.Kick("user1", "admin")
	assert.ErrorIs(t, err, ErrNotAdmin)
}

func TestRoomCondition_UpdateSetting(t *testing.T) {
	c := NewRoomCondition()
	c.UpdateSetting(false, DisplayModeTShirt)
	assert.False(t, c.AutoOpen)
	assert.Equal(t, DisplayModeTShirt, c.DisplayMode)
}

func TestRoomCondition_AutoOpen(t *testing.T) {
	c := NewRoomCondition()
	assert.NoError(t, c.Join("user1", "User 1"))
	assert.NoError(t, c.Join("user2", "User 2"))

	// 全員が投票すると自動的に開票される
	c.Vote("user1", Point3)
	assert.Equal(t, VoteStateHide, c.VoteState)
	c.Vote("user2", Point5)
	assert.Equal(t, VoteStateOpen, c.VoteState)

	// 自動開票が無効の場合
	c.Reset()
	c.UpdateSetting(false, DisplayModePoint)
	c.Vote("user1", Point3)
	c.Vote("user2", Point5)
	assert.Equal(t, VoteStateHide, c.VoteState)
}

func TestRoomCondition_Json(t *testing.T) {
	c := NewRoomCondition()
	assert.NoError(t, c.Join("user1", "User 1"))
	c.Vote("user1", Point5)

	// JSONにシリアライズ
	j, err := c.ToJson()
	assert.NoError(t, err)

	// JSONからデシリアライズ
	c2, err := FromJson(string(j))
	assert.NoError(t, err)

	// 元のオブジェクトと同じ内容か確認
	assert.Equal(t, c.RoomID, c2.RoomID)
	assert.Equal(t, c.AdminUserID, c2.AdminUserID)
	assert.Equal(t, c.VoteState, c2.VoteState)
	assert.Equal(t, c.AutoOpen, c2.AutoOpen)
	assert.Equal(t, c.DisplayMode, c2.DisplayMode)
	assert.Len(t, c2.Ballots, 1)
	assert.Equal(t, c.Ballots[0].UserID, c2.Ballots[0].UserID)
	assert.Equal(t, c.Ballots[0].Point, c2.Ballots[0].Point)
}
