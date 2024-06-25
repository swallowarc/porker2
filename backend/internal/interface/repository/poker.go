package repository

import (
	"context"
	"encoding/json"
	"time"

	"github.com/cenkalti/backoff/v4"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

const (
	roomLockDuration = 3 * time.Second
	roomLockRetry    = 5
)

type (
	pokerRepository struct {
		mem gateway.MemDBClient
	}
)

func NewPokerRepository(mem gateway.MemDBClient) port.PokerRepository {
	return &pokerRepository{
		mem: mem,
	}
}

func (r *pokerRepository) CreateRoom(ctx context.Context) (poker.RoomID, error) {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) GetRoomIDByUserID(ctx context.Context, userID user.ID) (poker.RoomID, error) {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) GetRoomCondition(ctx context.Context, roomID poker.RoomID) (*poker.RoomCondition, error) {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) AddRoomUser(ctx context.Context, roomID poker.RoomID, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) RemoveRoomUser(ctx context.Context, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) UpdateBallot(ctx context.Context, roomID poker.RoomID, userID user.ID, point poker.Point) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) UpdateVoteState(ctx context.Context, roomID poker.RoomID, state poker.VoteState) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) ResetRoomCondition(ctx context.Context, roomID poker.RoomID) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) SubscribeRoomCondition(ctx context.Context, block time.Duration, fn port.RoomSubscriber) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) getRoomCondition(ctx context.Context, roomID poker.RoomID) (*poker.RoomCondition, error) {
	// TODO: streamからの取得に直す
	j, err := r.mem.Get(ctx, roomConditionKey(roomID))
	if err != nil {
		return nil, err
	}

	var rc poker.RoomCondition
	if err := json.Unmarshal([]byte(j), &rc); err != nil {
		return nil, err
	}

	return &rc, nil
}

func (r *pokerRepository) Lock(ctx context.Context, roomID poker.RoomID, f func(ctx context.Context, c *poker.RoomCondition) error) error {
	bo := backoff.WithMaxRetries(backoff.NewExponentialBackOff(func(b *backoff.ExponentialBackOff) {
		b.MaxElapsedTime = roomLockDuration
	}), roomLockRetry)

	lockKey := roomLockKey(roomID)
	return backoff.Retry(func() error {
		set, err := r.mem.SetNX(ctx, lockKey, []byte{}, roomLockDuration)
		if err != nil {
			return backoff.Permanent(err)
		} else if !set {
			return merror.NewUnavailable("lock could not be acquired")
		}

		defer func() {
			if err := r.mem.Del(ctx, lockKey); err != nil {
				logger.FromCtx(ctx).Error("failed to release lock: %s", err.Error())
			}
		}()

		c, err := r.getRoomCondition(ctx, roomID)
		if err != nil {
			return backoff.Permanent(err)
		}

		return backoff.Permanent(f(ctx, c))
	}, bo)
}
