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
