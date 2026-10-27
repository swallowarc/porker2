package repository

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"go.uber.org/mock/gomock"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	mock_gateway "github.com/swallowarc/porker2/backend/internal/test/mock/gateway"
)

func TestPokerRepository_CreateRoom(t *testing.T) {
	t.Run("room id が衝突したら別の id で再試行する", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		existing, err := encodeRoom(poker.NewRoom())
		require.NoError(t, err)

		gomock.InOrder(
			// 1 回目: 既存の部屋が存在する (衝突)
			mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).Return(existing, nil),
			// 2 回目: 存在しない
			mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).Return("", nil),
			mem.EXPECT().PublishStream(gomock.Any(), gomock.Any(), gomock.Any()).Return(nil),
			mem.EXPECT().Expire(gomock.Any(), gomock.Any(), poker.RoomLifetimeDuration).Return(nil),
		)

		id, err := NewPokerRepository(mem).CreateRoom(context.Background())
		require.NoError(t, err)
		assert.False(t, id.IsZero())
	})

	t.Run("存在確認が NotFound 以外で失敗したらそのまま返す", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).
			Return("", merror.NewInternal("redis down"))

		_, err := NewPokerRepository(mem).CreateRoom(context.Background())
		assert.True(t, merror.IsInternal(err), "got: %v", err)
	})

	t.Run("リトライ上限を超えたら Unavailable", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		existing, err := encodeRoom(poker.NewRoom())
		require.NoError(t, err)
		mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).
			Return(existing, nil).Times(roomCreateRetry + 1)

		_, err = NewPokerRepository(mem).CreateRoom(context.Background())
		assert.True(t, merror.IsUnavailable(err), "got: %v", err)
	})
}

func TestPokerRepository_GetRoom(t *testing.T) {
	roomID := poker.MustRoomID("12345")

	t.Run("存在しない部屋は NotFound", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().ReadStreamLatest(gomock.Any(), roomKey(roomID), keyRoomConditionMessage).Return("", nil)

		_, err := NewPokerRepository(mem).GetRoom(context.Background(), roomID)
		assert.True(t, merror.IsNotFound(err), "got: %v", err)
	})

	t.Run("壊れたデータは Internal", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().ReadStreamLatest(gomock.Any(), roomKey(roomID), keyRoomConditionMessage).
			Return(`{"room_id":"12345","vote_state":9}`, nil)

		_, err := NewPokerRepository(mem).GetRoom(context.Background(), roomID)
		assert.True(t, merror.IsInternal(err), "got: %v", err)
	})
}

func TestRoomModel_RoundTrip(t *testing.T) {
	room := poker.NewRoom()
	u1 := user.NewID()
	require.NoError(t, room.Join(u1, user.MustName("alice")))
	require.NoError(t, room.Join(user.NewID(), user.MustName("bob")))
	room.Vote(u1, poker.Point5)
	room.UpdateSetting(false, poker.DisplayModeTShirt)

	j, err := encodeRoom(room)
	require.NoError(t, err)

	restored, err := decodeRoom(j)
	require.NoError(t, err)
	assert.Equal(t, room.RoomID(), restored.RoomID())
	assert.Equal(t, room.AdminUserID(), restored.AdminUserID())
	assert.Equal(t, room.VoteState(), restored.VoteState())
	assert.Equal(t, room.AutoOpen(), restored.AutoOpen())
	assert.Equal(t, room.DisplayMode(), restored.DisplayMode())
	assert.Equal(t, room.Ballots(), restored.Ballots())
}

func TestRoomModel_LegacyJSONIsReadable(t *testing.T) {
	// 旧バージョンが保存した形式 (observer_count フィールドを含む) もそのまま読める
	u1 := user.NewID()
	legacy := `{"room_id":"12345","admin_user_id":"` + u1.String() + `","vote_state":1,` +
		`"ballots":[{"user_id":"` + u1.String() + `","user_name":"n","point":0,"role":2}],` +
		`"auto_open":true,"display_mode":1,"observer_count":99}`

	room, err := decodeRoom(legacy)
	require.NoError(t, err)
	assert.Equal(t, poker.MustRoomID("12345"), room.RoomID())
	assert.Equal(t, u1, room.AdminUserID())
	assert.Equal(t, int32(1), room.ObserverCount(), "observer_count は無視され ballots から導出される")
	assert.True(t, room.Ballots()[0].IsObserver())
}

func TestPokerRepository_UpdateRoomWithLock(t *testing.T) {
	roomID := poker.MustRoomID("12345")
	// publish 先のキーは GetRoom が返した部屋の ID から決まるので、固定 ID の部屋を復元して使う
	room, err := poker.RestoreRoom(poker.RoomSnapshot{
		RoomID:      roomID.String(),
		VoteState:   poker.VoteStateHide.Int32(),
		AutoOpen:    true,
		DisplayMode: poker.DisplayModePoint.Int32(),
	})
	require.NoError(t, err)
	encoded, err := encodeRoom(room)
	require.NoError(t, err)

	t.Run("取得したトークンと同じ値でロックを解放する", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		var token string
		gomock.InOrder(
			mem.EXPECT().SetNX(gomock.Any(), roomLockKey(roomID), gomock.Any(), roomLockDuration).
				DoAndReturn(func(_ context.Context, _ string, v any, _ any) (bool, error) {
					token = v.(string)
					assert.NotEmpty(t, token, "ロック値は一意なトークン")
					return true, nil
				}),
			mem.EXPECT().ReadStreamLatest(gomock.Any(), roomKey(roomID), keyRoomConditionMessage).Return(encoded, nil),
			mem.EXPECT().PublishStream(gomock.Any(), roomKey(roomID), gomock.Any()).Return(nil),
			mem.EXPECT().Expire(gomock.Any(), roomKey(roomID), poker.RoomLifetimeDuration).Return(nil),
			mem.EXPECT().CompareAndDelete(gomock.Any(), roomLockKey(roomID), gomock.Any()).
				DoAndReturn(func(_ context.Context, _ string, expected string) (bool, error) {
					assert.Equal(t, token, expected, "SetNX で置いたトークンで解放する")
					return true, nil
				}),
		)

		called := false
		err := NewPokerRepository(mem).UpdateRoomWithLock(context.Background(), roomID, func(_ context.Context, r *poker.Room) error {
			called = true
			return nil
		})
		require.NoError(t, err)
		assert.True(t, called)
	})

	t.Run("modifier が失敗しても publish せずロックは解放する", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		gomock.InOrder(
			mem.EXPECT().SetNX(gomock.Any(), roomLockKey(roomID), gomock.Any(), roomLockDuration).Return(true, nil),
			mem.EXPECT().ReadStreamLatest(gomock.Any(), roomKey(roomID), keyRoomConditionMessage).Return(encoded, nil),
			mem.EXPECT().CompareAndDelete(gomock.Any(), roomLockKey(roomID), gomock.Any()).Return(true, nil),
		)

		err := NewPokerRepository(mem).UpdateRoomWithLock(context.Background(), roomID, func(_ context.Context, _ *poker.Room) error {
			return poker.ErrNotAdmin
		})
		assert.ErrorIs(t, err, poker.ErrNotAdmin)
	})
}
