package interactor

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	mock_port "github.com/swallowarc/porker2/backend/internal/test/mock/port"
)

func newUserInteractorWithMocks(t *testing.T) (*userInteractor, *mock_port.MockUserRepository, *mock_port.MockPokerRepository) {
	ctrl := gomock.NewController(t)
	userRepo := mock_port.NewMockUserRepository(ctrl)
	pokerRepo := mock_port.NewMockPokerRepository(ctrl)
	return NewUser(userRepo, pokerRepo).(*userInteractor), userRepo, pokerRepo
}

func TestUserInteractor_Logout(t *testing.T) {
	t.Run("部屋が既に TTL 切れで消えていても Logout は成功する", func(t *testing.T) {
		itr, userRepo, pokerRepo := newUserInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", testRoomID, nil)
		pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), testRoomID, gomock.Any()).
			Return(merror.NewNotFound("room condition not found"))
		userRepo.EXPECT().Delete(gomock.Any(), testUserID).Return(nil)

		assert.NoError(t, itr.Logout(context.Background(), testUserID))
	})

	t.Run("ユーザーが既に消えていても Logout は成功する (冪等)", func(t *testing.T) {
		itr, userRepo, _ := newUserInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(user.Name{}, "", poker.RoomID{}, merror.NewNotFound("user does not exist"))

		assert.NoError(t, itr.Logout(context.Background(), testUserID))
	})

	t.Run("部屋側の NotFound 以外のエラーは返す", func(t *testing.T) {
		itr, userRepo, pokerRepo := newUserInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", testRoomID, nil)
		pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), testRoomID, gomock.Any()).
			Return(merror.NewUnavailable("lock could not be acquired"))
		userRepo.EXPECT().Delete(gomock.Any(), testUserID).Return(nil)

		err := itr.Logout(context.Background(), testUserID)
		assert.True(t, merror.IsUnavailable(err), "got: %v", err)
	})
}

func TestUserInteractor_GetUser(t *testing.T) {
	t.Run("ユーザーデータが消えていたら Unauthenticated", func(t *testing.T) {
		itr, userRepo, _ := newUserInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(user.Name{}, "", poker.RoomID{}, merror.NewNotFound("user does not exist"))

		_, err := itr.GetUser(context.Background(), testUserID)
		assert.True(t, merror.IsUnauthenticated(err), "got: %v", err)
	})
}

func TestUserInteractor_Login(t *testing.T) {
	t.Run("正常系", func(t *testing.T) {
		itr, userRepo, _ := newUserInteractorWithMocks(t)
		userRepo.EXPECT().Create(gomock.Any(), testUserName).Return(testUserID, "tk", nil)

		id, token, err := itr.Login(context.Background(), testUserName)
		assert.NoError(t, err)
		assert.Equal(t, testUserID, id)
		assert.Equal(t, "tk", token)
	})

	t.Run("名前重複は Create の AlreadyExists をそのまま返す", func(t *testing.T) {
		itr, userRepo, _ := newUserInteractorWithMocks(t)
		userRepo.EXPECT().Create(gomock.Any(), testUserName).Return(user.ID{}, "", merror.NewAlreadyExists("dup"))

		_, _, err := itr.Login(context.Background(), testUserName)
		assert.True(t, merror.IsAlreadyExists(err))
	})
}
