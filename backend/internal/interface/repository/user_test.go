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

var testUserID = user.ID("0f2d6c9e-4b1a-4c3d-9e8f-123456789abc")

func TestUserRepository_NotFoundIsPreserved(t *testing.T) {
	// usecase 層は merror.IsNotFound で分岐するので、repository は NotFound を Internal に包んではいけない。
	notFound := merror.NewNotFound("key does not exist")

	t.Run("GetByID", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return("", notFound)

		_, _, _, err := NewUserRepository(mem).GetByID(context.Background(), testUserID)
		assert.True(t, merror.IsNotFound(err), "got: %v", err)
	})

	t.Run("UpdateRoomID", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return("", notFound)

		err := NewUserRepository(mem).UpdateRoomID(context.Background(), testUserID, poker.RoomID("12345"))
		assert.True(t, merror.IsNotFound(err), "got: %v", err)
	})

	t.Run("ResetLifetime", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return("", notFound)

		err := NewUserRepository(mem).ResetLifetime(context.Background(), testUserID)
		assert.True(t, merror.IsNotFound(err), "got: %v", err)
	})

	t.Run("Delete は NotFound を成功として扱う", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return("", notFound)

		assert.NoError(t, NewUserRepository(mem).Delete(context.Background(), testUserID))
	})
}

func TestUserRepository_GetByID(t *testing.T) {
	t.Run("壊れた JSON は Internal", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return("{broken", nil)

		_, _, _, err := NewUserRepository(mem).GetByID(context.Background(), testUserID)
		assert.True(t, merror.IsInternal(err), "got: %v", err)
	})

	t.Run("事前条件を満たさない値は Internal (ドメイン型に復元できない)", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).
			Return(`{"id":"`+testUserID.String()+`","name":"alice","token":"tk","room_id":"abc"}`, nil)

		_, _, _, err := NewUserRepository(mem).GetByID(context.Background(), testUserID)
		assert.True(t, merror.IsInternal(err), "got: %v", err)
	})

	t.Run("正常系", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		j, err := encodeUser(&userModel{ID: testUserID.String(), Name: "alice", Token: "tk", RoomID: "12345"})
		require.NoError(t, err)
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return(j, nil)

		name, token, roomID, err := NewUserRepository(mem).GetByID(context.Background(), testUserID)
		require.NoError(t, err)
		assert.Equal(t, user.Name("alice"), name)
		assert.Equal(t, "tk", token)
		assert.Equal(t, poker.RoomID("12345"), roomID)
	})

	t.Run("未参加 (room_id 省略) はゼロ値の RoomID", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).
			Return(`{"id":"`+testUserID.String()+`","name":"alice","token":"tk"}`, nil)

		_, _, roomID, err := NewUserRepository(mem).GetByID(context.Background(), testUserID)
		require.NoError(t, err)
		assert.True(t, roomID.IsZero())
	})
}

func TestUserRepository_UpdateRoomID_ClearsWithZeroValue(t *testing.T) {
	mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
	j, err := encodeUser(&userModel{ID: testUserID.String(), Name: "alice", Token: "tk", RoomID: "12345"})
	require.NoError(t, err)
	mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return(j, nil)
	mem.EXPECT().Set(gomock.Any(), userIDKey(testUserID), gomock.Any(), user.SessionLifetimeDuration).
		DoAndReturn(func(_ context.Context, _ string, v any, _ any) error {
			m, err := decodeUser(v.(string))
			require.NoError(t, err)
			assert.Equal(t, "", m.RoomID, "ゼロ値の RoomID は room_id を空にする")
			return nil
		})

	assert.NoError(t, NewUserRepository(mem).UpdateRoomID(context.Background(), testUserID, poker.RoomID("")))
}
