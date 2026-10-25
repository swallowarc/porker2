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

const testUserID = user.ID("0f2d6c9e-4b1a-4c3d-9e8f-123456789abc")

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

	t.Run("正常系", func(t *testing.T) {
		mem := mock_gateway.NewMockMemDBClient(gomock.NewController(t))
		u := &userModel{ID: testUserID, Name: "alice", Token: "tk", RoomID: "12345"}
		j, err := u.jsonMarshalUserInfo()
		require.NoError(t, err)
		mem.EXPECT().Get(gomock.Any(), userIDKey(testUserID)).Return(j, nil)

		name, token, roomID, err := NewUserRepository(mem).GetByID(context.Background(), testUserID)
		require.NoError(t, err)
		assert.Equal(t, user.Name("alice"), name)
		assert.Equal(t, "tk", token)
		assert.Equal(t, poker.RoomID("12345"), roomID)
	})
}
