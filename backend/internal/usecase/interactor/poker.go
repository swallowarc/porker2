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

func (i *pokerInteractor) CheckRoom(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	rc, err := i.pokerRepo.GetRoom(ctx, roomID)
	if err != nil {
		return err
	}

	// If the user is already in the room, do nothing.
	if rc.IsUserIn(userID) {
		return nil
	}

	if !rc.CanJoin() {
		return poker.ErrRoomFull
	}

	return nil
}

func (i *pokerInteractor) JoinRoom(ctx context.Context, userID user.ID, roomID poker.RoomID, fn port.RoomSubscriber) error {
	userName, _, joinedRoomID, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		return asSessionError(err)
	}

	if !joinedRoomID.IsZero() && joinedRoomID != roomID {
		logger.FromCtx(ctx).Info("leave the room because the user is already in other room",
			slog.String("user_id", userID.String()),
			slog.String("room_id", joinedRoomID.String()),
		)
		if err := i.LeaveRoom(ctx, userID); err != nil {
			return err
		}
	}

	if err := i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		if err := c.Join(userID, userName); err != nil {
			return err
		}
		if err := i.userRepo.UpdateRoomID(ctx, userID, roomID); err != nil {
			c.Leave(userID)
			return asSessionError(err)
		}
		return nil
	}); err != nil {
		return err
	}

	if err := i.pokerRepo.SubscribeRoom(ctx, roomID, func(ctx context.Context, c *poker.Room) (bool, error) {
		if !c.IsUserIn(userID) {
			logger.FromCtx(ctx).Info("stop subscribing room (user is not in the room)")
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
		return asSessionError(err)
	}
	// If the user is not in any room, do nothing.
	if joinedRoomID.IsZero() {
		return nil
	}

	err = i.pokerRepo.UpdateRoomWithLock(ctx, joinedRoomID, func(ctx context.Context, c *poker.Room) error {
		if err := i.userRepo.UpdateRoomID(ctx, userID, ""); err != nil {
			return err
		}
		c.Leave(userID)
		return nil
	})
	if err == nil {
		return nil
	}
	if !merror.IsNotFound(err) {
		return err
	}

	// 部屋が TTL 切れで既に消えている (ユーザーのセッションは部屋より長く生き残り得る)。
	// ここで失敗を返すとユーザーは消えた部屋への参照を持ち続け、Logout するまでどの部屋にも入れなくなる。
	// 部屋側の更新は不要なので、ユーザー側の参照だけ消して成功扱いにする。
	logger.FromCtx(ctx).Info("room already gone, clearing user's room reference",
		slog.String("user_id", userID.String()),
		slog.String("room_id", joinedRoomID.String()),
	)

	return asSessionError(i.userRepo.UpdateRoomID(ctx, userID, ""))
}

func (i *pokerInteractor) CastVote(ctx context.Context, userID user.ID, roomID poker.RoomID, point poker.Point) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		c.Vote(userID, point)
		return nil
	})
}

func (i *pokerInteractor) ShowVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		c.Open()
		return nil
	})
}

func (i *pokerInteractor) ResetVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		c.Reset()
		return nil
	})
}

func (i *pokerInteractor) Kick(ctx context.Context, userID, targetUserID user.ID, roomID poker.RoomID) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		return c.Kick(userID, targetUserID)
	})
}

func (i *pokerInteractor) Update(ctx context.Context, userID user.ID, roomID poker.RoomID, autoOpen bool, displayMode poker.DisplayMode) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		c.UpdateSetting(autoOpen, displayMode)
		return nil
	})
}

func (i *pokerInteractor) ToggleObserverMode(ctx context.Context, userID user.ID, roomID poker.RoomID, isObserver bool) error {
	if err := i.checkUserRoomJoin(ctx, userID, roomID); err != nil {
		return err
	}

	return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
		c.ToggleObserverMode(userID, isObserver)
		return nil
	})
}

func (i *pokerInteractor) checkUserRoomJoin(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	_, _, joinedRoomID, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		return asSessionError(err)
	}

	if roomID != joinedRoomID {
		return merror.NewFailedPrecondition("user is not in the room with specified room_id: %s", roomID)
	}

	return nil
}

// asSessionError は認証済みユーザーのデータが見つからない場合 (トークンだけ生き残った等) を
// Unauthenticated に変換する。クライアントは再ログインで復旧できる。
func asSessionError(err error) error {
	if err == nil {
		return nil
	}
	if merror.IsNotFound(err) {
		return merror.NewUnauthenticated("user session not found, please login again: %v", err)
	}
	return err
}
