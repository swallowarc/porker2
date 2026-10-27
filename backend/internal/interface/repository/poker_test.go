package repository

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"go.uber.org/mock/gomock"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	mock_gateway "github.com/swallowarc/porker2/backend/internal/test/mock/gateway"
)

func TestPokerRepository_CreateRoom(t *testing.T) {
	t.Run("room id が衝突したら別の id で再試行する", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		existing, err := poker.NewRoom().ToJson()
		require.NoError(t, err)

		gomock.InOrder(
			// 1 回目: 既存の部屋が存在する (衝突)
			mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).Return(string(existing), nil),
			// 2 回目: 存在しない
			mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).Return("", nil),
			mem.EXPECT().PublishStream(gomock.Any(), gomock.Any(), gomock.Any()).Return(nil),
			mem.EXPECT().Expire(gomock.Any(), gomock.Any(), poker.RoomLifetimeDuration).Return(nil),
		)

		id, err := NewPokerRepository(mem).CreateRoom(context.Background())
		require.NoError(t, err)
		_, err = poker.NewRoomID(id.String())
		assert.NoError(t, err, "生成された room id は事前条件を満たす")
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
		existing, err := poker.NewRoom().ToJson()
		require.NoError(t, err)
		mem.EXPECT().ReadStreamLatest(gomock.Any(), gomock.Any(), keyRoomConditionMessage).
			Return(string(existing), nil).Times(roomCreateRetry + 1)

		_, err = NewPokerRepository(mem).CreateRoom(context.Background())
		assert.True(t, merror.IsUnavailable(err), "got: %v", err)
	})
}

func TestPokerRepository_GetRoom(t *testing.T) {
	t.Run("存在しない部屋は NotFound", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().ReadStreamLatest(gomock.Any(), roomKey("12345"), keyRoomConditionMessage).Return("", nil)

		_, err := NewPokerRepository(mem).GetRoom(context.Background(), "12345")
		assert.True(t, merror.IsNotFound(err), "got: %v", err)
	})
}
