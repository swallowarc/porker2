package interactor

import (
	"context"
	"log/slog"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	pokerInteractor struct {
		userRepo  port.UserRepository
		pokerRepo port.PokerRepository
	}
)

func NewPoker(userRepo port.UserRepository, pokerRepo port.PokerRepository) Poker {
	return &pokerInteractor{
		userRepo:  userRepo,
		pokerRepo: pokerRepo,
	}
}

func (i *pokerInteractor) CreateRoom(ctx context.Context) (poker.RoomID, error) {
	id, err := i.pokerRepo.CreateRoom(ctx)
	if err != nil {
		return "", err
	}

	logger.FromCtx(ctx).Debug("room created", slog.String("room_id", id.String()))

	return id, nil
}

func (i *pokerInteractor) JoinRoom(ctx context.Context, userID user.ID, roomID poker.RoomID, fn port.RoomSubscriber) error {
	userName, _, joinedRoomID, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		if !merror.IsNotFound(err) {
			return err
		}
	} else {
		if joinedRoomID != "" && joinedRoomID != roomID {
			logger.FromCtx(ctx).Info("leave the room because the user is already in other room",
				slog.String("user_id", userID.String()),
				slog.String("room_id", joinedRoomID.String()),
			)
			if err := i.LeaveRoom(ctx, userID); err != nil {
				return err
			}
		}
	}

	if err := i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) error {
		if err := i.userRepo.UpdateRoomID(ctx, userID, roomID); err != nil {
			return err
		}
		return c.Join(userID, userName)
	}); err != nil {
		return err
	}

	if err := i.pokerRepo.SubscribeRoomCondition(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) (bool, error) {
		if !c.IsUserIn(userID) {
			logger.FromCtx(ctx).Info("stop subscribing room condition (user is not in the room)")
			return false, nil
		}
		return fn(ctx, c)

	}); err != nil {
		return err
	}

	return nil
}

func (i *pokerInteractor) LeaveRoom(ctx context.Context, userID user.ID) error {
	_, _, joinedRoomID, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		return err
	}
	// If the user is not in any room, do nothing.
	if joinedRoomID == "" {
		return nil
	}

	if err := i.pokerRepo.UpdateRoomWithLock(ctx, joinedRoomID, func(ctx context.Context, c *poker.RoomCondition) error {
		if err := i.userRepo.UpdateRoomID(ctx, userID, joinedRoomID); err != nil {
			return err
		}
		c.Leave(userID)
		return nil
	}); err != nil {
		return err
	}

	return nil
}

func (i *pokerInteractor) CastVote(ctx context.Context, userID user.ID, roomID poker.RoomID, point poker.Point) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) error {
		c.Vote(userID, point)
		return nil
	})
}

func (i *pokerInteractor) ShowVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) error {
		c.Open()
		return nil
	})
}

func (i *pokerInteractor) ResetVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) error {
		c.Reset()
		return nil
	})
}

func (i *pokerInteractor) Kick(ctx context.Context, userID, targetUserID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) error {
		return c.Kick(userID, targetUserID)
	})
}

func (i *pokerInteractor) checkUserRoomJoin(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	_, _, joinedRoomID, err := i.userRepo.GetByID(ctx, userID)
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
