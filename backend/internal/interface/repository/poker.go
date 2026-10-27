package repository

import (
	"context"
	"log/slog"
	"time"

	"github.com/cenkalti/backoff/v7"

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
	for attempt := 0; attempt <= roomCreateRetry; attempt++ {
		room := poker.NewRoom()

		// 部屋の実体は Stream なので、存在確認に GET を使うと WRONGTYPE エラーになる。
		// 必ず Stream 用の読み出しで確認する。
		_, err := r.GetRoom(ctx, room.RoomID())
		if err == nil {
			continue // room id collision, retry
		}
		if !merror.IsNotFound(err) {
			return poker.RoomID{}, err
		}

		if err := r.publishRoom(ctx, room); err != nil {
			return poker.RoomID{}, err
		}

		return room.RoomID(), nil
	}

	return poker.RoomID{}, merror.NewUnavailable("room creation retry limit has been exceeded")
}

func (r *pokerRepository) UpdateRoomWithLock(ctx context.Context, roomID poker.RoomID, modifier port.RoomModifier) error {
	lockKey := roomLockKey(roomID)

	_, err := backoff.Retry(ctx, func() (struct{}, error) {
		set, err := r.mem.SetNX(ctx, lockKey, []byte{}, roomLockDuration)
		if err != nil {
			return struct{}{}, backoff.Permanent(err)
		} else if !set {
			return struct{}{}, merror.NewUnavailable("lock could not be acquired")
		}
		return struct{}{}, nil
	},
		backoff.WithBackOff(backoff.NewExponentialBackOff()),
		backoff.WithMaxTries(roomLockRetry),
		backoff.WithMaxElapsedTime(roomLockDuration),
	)
	if err != nil {
		return err
	}

	inCtx, cancel := context.WithTimeout(ctx, roomLockDuration)
	defer cancel()

	defer func() {
		if err := r.mem.Del(ctx, lockKey); err != nil {
			if !merror.IsNotFound(err) {
				logger.FromCtx(inCtx).Error("failed to release lock", slog.String("error", err.Error()))
			}
		}
	}()

	room, err := r.GetRoom(inCtx, roomID)
	if err != nil {
		return err
	}

	if err := modifier(inCtx, room); err != nil {
		return err
	}

	return r.publishRoom(inCtx, room)
}

func (r *pokerRepository) publishRoom(ctx context.Context, room *poker.Room) error {
	j, err := encodeRoom(room)
	if err != nil {
		return err
	}

	streamKey := roomKey(room.RoomID())
	if err := r.mem.PublishStream(ctx, streamKey, map[string]any{
		keyRoomConditionMessage: j,
	}); err != nil {
		return err
	}

	return r.mem.Expire(ctx, streamKey, poker.RoomLifetimeDuration)
}

func (r *pokerRepository) GetRoom(ctx context.Context, roomID poker.RoomID) (*poker.Room, error) {
	j, err := r.mem.ReadStreamLatest(ctx, roomKey(roomID), keyRoomConditionMessage)
	if err != nil {
		return nil, err
	}
	if j == "" {
		return nil, merror.NewNotFound("room not found: %s", roomID.String())
	}

	return decodeRoom(j)
}

func (r *pokerRepository) SubscribeRoom(ctx context.Context, roomID poker.RoomID, fn port.RoomSubscriber) error {
	var (
		messageID = "0"
		subscribe = true
	)
	for subscribe {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
			latestMessageID, j, err := r.mem.ReadStream(ctx, roomKey(roomID), keyRoomConditionMessage, messageID)
			if err != nil {
				return err
			}
			if messageID == latestMessageID {
				continue
			}

			messageID = latestMessageID

			room, err := decodeRoom(j)
			if err != nil {
				return err
			}
			if subscribe, err = fn(ctx, room); err != nil {
				return err
			}
		}
	}

	return nil
}
