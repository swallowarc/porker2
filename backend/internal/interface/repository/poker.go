package repository

import (
	"context"
	"encoding/json"
	"log/slog"
	"time"

	"github.com/cenkalti/backoff/v4"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

const (
	roomLockDuration = 3 * time.Second
	roomLockRetry    = 5
	roomCreateRetry  = 10
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
	var c *poker.RoomCondition
	for i := 0; i <= roomCreateRetry; i++ {
		c = poker.NewRoomCondition()
		_, err := r.mem.Get(ctx, roomConditionKey(c.RoomID))
		if merror.IsNotFound(err) {
			break
		} else if err != nil {
			return "", merror.WrapInternal(err, "failed to memDBCli.Get")
		}

		if i == roomCreateRetry {
			return "", merror.NewUnavailable("room creation retry limit has been exceeded")
		}
	}

	if err := r.publishRoomStream(ctx, c); err != nil {
		return "", err
	}

	return c.RoomID, nil
}

func (r *pokerRepository) UpdateRoomWithLock(ctx context.Context, roomID poker.RoomID, modifier port.RoomModifier) error {
	bo := backoff.WithMaxRetries(backoff.NewExponentialBackOff(func(b *backoff.ExponentialBackOff) {
		b.MaxElapsedTime = roomLockDuration
	}), roomLockRetry)

	lockKey := roomLockKey(roomID)

	err := backoff.Retry(func() error {
		set, err := r.mem.SetNX(ctx, lockKey, []byte{}, roomLockDuration)
		if err != nil {
			return backoff.Permanent(err)
		} else if !set {
			return merror.NewUnavailable("lock could not be acquired")
		}
		return nil
	}, bo)
	if err != nil {
		return err
	}

	inCtx, cancel := context.WithTimeout(ctx, roomLockDuration)
	defer cancel()

	defer func() {
		if err := r.mem.Del(ctx, lockKey); err != nil {
			if !merror.IsNotFound(err) {
				logger.FromCtx(inCtx).Error("failed to release lock: %s", slog.String("error", err.Error()))
			}
		}
	}()

	c, err := r.GetRoomCondition(inCtx, roomID)
	if err != nil {
		return err
	}

	if err := modifier(inCtx, c); err != nil {
		return err
	}

	return r.publishRoomStream(inCtx, c)
}

func (r *pokerRepository) publishRoomStream(ctx context.Context, condition *poker.RoomCondition) error {
	j, err := condition.ToJson()
	if err != nil {
		return err
	}

	streamKey := roomConditionKey(condition.RoomID)
	if err := r.mem.PublishStream(ctx, roomConditionKey(condition.RoomID), map[string]any{
		keyRoomConditionMessage: j,
	}); err != nil {
		return err
	}

	return r.mem.Expire(ctx, streamKey, poker.RoomLifetime)
}

func (r *pokerRepository) GetRoomCondition(ctx context.Context, roomID poker.RoomID) (*poker.RoomCondition, error) {
	j, err := r.mem.ReadStreamLatest(ctx, roomConditionKey(roomID), keyRoomConditionMessage)
	if err != nil {
		return nil, err
	}
	if j == "" {
		return nil, merror.NewNotFound("room condition not found:%s", roomID)
	}

	var rc poker.RoomCondition
	if err := json.Unmarshal([]byte(j), &rc); err != nil {
		return nil, err
	}

	return &rc, nil
}

func (r *pokerRepository) SubscribeRoomCondition(ctx context.Context, roomID poker.RoomID, fn port.RoomSubscriber) error {
	var (
		messageID = "0"
		subscribe = true
	)
	for subscribe {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
			newMessageID, j, err := r.mem.ReadStream(ctx, roomConditionKey(roomID), keyRoomConditionMessage, messageID)
			if err != nil {
				if merror.IsNotFound(err) {
					continue
				}
				return err
			}
			messageID = newMessageID

			rc, err := poker.FromJson(j)
			if err != nil {
				return err
			}
			if subscribe, err = fn(ctx, rc); err != nil {
				return err
			}
		}
	}

	return nil
}
