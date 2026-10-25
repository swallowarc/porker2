package interactor

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"go.uber.org/mock/gomock"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	mock_port "github.com/swallowarc/porker2/backend/internal/test/mock/port"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

var (
	testUserID   = user.NewID()
	testUserName = user.MustName("alice")
	testRoomID   = poker.MustRoomID("12345")
)

func newPokerInteractorWithMocks(t *testing.T) (*pokerInteractor, *mock_port.MockUserRepository, *mock_port.MockPokerRepository) {
	ctrl := gomock.NewController(t)
	userRepo := mock_port.NewMockUserRepository(ctrl)
	pokerRepo := mock_port.NewMockPokerRepository(ctrl)
	return NewPoker(userRepo, pokerRepo).(*pokerInteractor), userRepo, pokerRepo
}

// runModifier は UpdateRoomWithLock のモックとして、渡された modifier を実際の Room に適用する。
func runModifier(room *poker.Room) func(context.Context, poker.RoomID, port.RoomModifier) error {
	return func(ctx context.Context, _ poker.RoomID, modifier port.RoomModifier) error {
		return modifier(ctx, room)
	}
}

func TestPokerInteractor_LeaveRoom(t *testing.T) {
	t.Run("通常の退室", func(t *testing.T) {
		itr, userRepo, pokerRepo := newPokerInteractorWithMocks(t)
		rc := poker.NewRoom()
		require.NoError(t, rc.Join(testUserID, testUserName))

		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", testRoomID, nil)
		pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), testRoomID, gomock.Any()).DoAndReturn(runModifier(rc))
		userRepo.EXPECT().UpdateRoomID(gomock.Any(), testUserID, poker.RoomID{}).Return(nil)

		assert.NoError(t, itr.LeaveRoom(context.Background(), testUserID))
		assert.False(t, rc.IsUserIn(testUserID))
	})

	t.Run("部屋が既に TTL 切れで消えていてもユーザーの部屋参照はクリアされる", func(t *testing.T) {
		itr, userRepo, pokerRepo := newPokerInteractorWithMocks(t)

		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", testRoomID, nil)
		pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), testRoomID, gomock.Any()).
			Return(merror.NewNotFound("room condition not found"))
		// fallback: 部屋側の更新はスキップし、ユーザー側の参照だけ消す
		userRepo.EXPECT().UpdateRoomID(gomock.Any(), testUserID, poker.RoomID{}).Return(nil)

		assert.NoError(t, itr.LeaveRoom(context.Background(), testUserID))
	})

	t.Run("どの部屋にも入っていなければ何もしない", func(t *testing.T) {
		itr, userRepo, _ := newPokerInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", poker.RoomID{}, nil)

		assert.NoError(t, itr.LeaveRoom(context.Background(), testUserID))
	})

	t.Run("ユーザーデータが消えていたら Unauthenticated", func(t *testing.T) {
		itr, userRepo, _ := newPokerInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(user.Name{}, "", poker.RoomID{}, merror.NewNotFound("user does not exist"))

		err := itr.LeaveRoom(context.Background(), testUserID)
		assert.True(t, merror.IsUnauthenticated(err), "got: %v", err)
	})

	t.Run("Redis 障害など NotFound 以外のエラーはそのまま返す", func(t *testing.T) {
		itr, userRepo, pokerRepo := newPokerInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", testRoomID, nil)
		pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), testRoomID, gomock.Any()).
			Return(merror.NewUnavailable("lock could not be acquired"))

		err := itr.LeaveRoom(context.Background(), testUserID)
		assert.True(t, merror.IsUnavailable(err), "got: %v", err)
	})
}

func TestPokerInteractor_JoinRoom(t *testing.T) {
	t.Run("ユーザーデータが消えていたら Unauthenticated を返し部屋には触らない", func(t *testing.T) {
		itr, userRepo, _ := newPokerInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(user.Name{}, "", poker.RoomID{}, merror.NewNotFound("user does not exist"))

		err := itr.JoinRoom(context.Background(), testUserID, testRoomID, nil)
		assert.True(t, merror.IsUnauthenticated(err), "got: %v", err)
	})

	t.Run("別の部屋にいた場合は先に退室してから参加する", func(t *testing.T) {
		itr, userRepo, pokerRepo := newPokerInteractorWithMocks(t)
		oldRoomID := poker.MustRoomID("99999")
		oldRoom := poker.NewRoom()
		require.NoError(t, oldRoom.Join(testUserID, testUserName))
		newRoom := poker.NewRoom()

		gomock.InOrder(
			userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", oldRoomID, nil),
			// LeaveRoom
			userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", oldRoomID, nil),
			pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), oldRoomID, gomock.Any()).DoAndReturn(runModifier(oldRoom)),
			userRepo.EXPECT().UpdateRoomID(gomock.Any(), testUserID, poker.RoomID{}).Return(nil),
			// Join
			pokerRepo.EXPECT().UpdateRoomWithLock(gomock.Any(), testRoomID, gomock.Any()).DoAndReturn(runModifier(newRoom)),
			userRepo.EXPECT().UpdateRoomID(gomock.Any(), testUserID, testRoomID).Return(nil),
			pokerRepo.EXPECT().SubscribeRoom(gomock.Any(), testRoomID, gomock.Any()).Return(nil),
		)

		assert.NoError(t, itr.JoinRoom(context.Background(), testUserID, testRoomID, nil))
		assert.False(t, oldRoom.IsUserIn(testUserID))
		assert.True(t, newRoom.IsUserIn(testUserID))
	})
}

func TestPokerInteractor_checkUserRoomJoin(t *testing.T) {
	t.Run("ユーザーデータが消えていたら Unauthenticated", func(t *testing.T) {
		itr, userRepo, _ := newPokerInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(user.Name{}, "", poker.RoomID{}, merror.NewNotFound("user does not exist"))

		err := itr.CastVote(context.Background(), testUserID, testRoomID, poker.Point1)
		assert.True(t, merror.IsUnauthenticated(err), "got: %v", err)
	})

	t.Run("別の部屋を指定したら FailedPrecondition", func(t *testing.T) {
		itr, userRepo, _ := newPokerInteractorWithMocks(t)
		userRepo.EXPECT().GetByID(gomock.Any(), testUserID).Return(testUserName, "tk", poker.MustRoomID("99999"), nil)

		err := itr.CastVote(context.Background(), testUserID, testRoomID, poker.Point1)
		assert.True(t, merror.IsFailedPrecondition(err), "got: %v", err)
	})
}
