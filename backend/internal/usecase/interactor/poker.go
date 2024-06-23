package interactor

import (
	"context"
	"time"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

const roomSubscribeInterval = 3 * time.Second

type (
	pokerInteractor struct {
		repo port.PokerRepository
	}
)

func NewPoker(repo port.PokerRepository) Poker {
	return &pokerInteractor{repo: repo}
}

func (i *pokerInteractor) CreateRoom(ctx context.Context) (poker.RoomID, error) {
	return i.repo.CreateRoom(ctx)
}

func (i *pokerInteractor) JoinRoom(ctx context.Context, userID user.ID, roomID poker.RoomID, fn port.RoomSubscribeFunc) error {
	condition, err := i.repo.GetRoomCondition(ctx, roomID)
	if err != nil {
		return err
	}
	if !condition.CanJoin() {
		return merror.NewFailedPrecondition("", "room is not joinable")
	}

	joinedRoomID, err := i.repo.GetRoomIDByUserID(ctx, userID)
	if err != nil {
		if !merror.IsNotFound(err) {
			return err
		}
	} else {
		if joinedRoomID != roomID {
			// Leave the room if the user is already in other room.
			if err := i.repo.RemoveRoomUser(ctx, userID); err != nil {
				return err
			}
		}
	}

	for {
		if err := i.repo.SubscribeRoomCondition(ctx, roomSubscribeInterval, func(ctx context.Context, condition *poker.RoomCondition) error {
			if err := fn(ctx, condition); err != nil {
				return err
			}
			return nil
		}); err != nil {
			return err
		}
	}
}

func (i *pokerInteractor) LeaveRoom(ctx context.Context, userID user.ID) error {
	return i.repo.RemoveRoomUser(ctx, userID)
}

func (i *pokerInteractor) CastVote(ctx context.Context, userID user.ID, roomID poker.RoomID, point poker.Point) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}
	return i.repo.UpdateBallot(ctx, roomID, userID, point)
}

func (i *pokerInteractor) ShowVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.repo.UpdateVoteState(ctx, roomID, poker.VoteStateOpen)
}

func (i *pokerInteractor) ResetVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.repo.ResetRoomCondition(ctx, roomID)
}

func (i *pokerInteractor) Kick(ctx context.Context, userID, targetUserID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	condition, err := i.repo.GetRoomCondition(ctx, roomID)
	if err != nil {
		return err
	}
	if !condition.IsAdmin(userID) {
		return merror.NewPermissionDenied("", "user is not admin")
	}

	return i.repo.RemoveRoomUser(ctx, targetUserID)
}

func (i *pokerInteractor) checkUserRoomJoin(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	joinedRoomID, err := i.repo.GetRoomIDByUserID(ctx, userID)
	if err != nil {
		if merror.IsNotFound(err) {
			return merror.NewFailedPrecondition("", "user is not in any room")
		}
		return err
	}

	if roomID != joinedRoomID {
		return merror.NewFailedPrecondition("", "user is not in the room with specified room_id: %s", roomID)
	}

	return nil
}
