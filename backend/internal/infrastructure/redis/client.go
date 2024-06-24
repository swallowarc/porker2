package redis

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"github.com/redis/go-redis/v9"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	gateways "github.com/swallowarc/porker2/backend/internal/interface/gateway"
)

const (
	maxRetries = 5
)

type (
	redisClient struct {
		cli redis.Cmdable
	}
)

func NewRedisClient(config Config) gateways.MemDBClient {
	return &redisClient{
		cli: redis.NewClient(&redis.Options{
			Addr:       config.HostPort,
			Password:   config.Password, // no password set
			DB:         config.DB,       // use default DB
			MaxRetries: maxRetries,
		}),
	}
}

func (c *redisClient) Ping(ctx context.Context) error {
	if err := c.cli.Ping(ctx).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis Ping")
	}
	return nil
}

func (c *redisClient) Set(ctx context.Context, key string, value interface{}, duration time.Duration) error {
	if err := c.cli.Set(ctx, key, value, duration).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis Set")
	}
	return nil
}

func (c *redisClient) SetNX(ctx context.Context, key string, value interface{}, duration time.Duration) (bool, error) {
	ret, err := c.cli.SetNX(ctx, key, value, duration).Result()
	if err != nil {
		return false, merror.WrapInternal(err, "failed to redis SetNX")
	}

	return ret, nil
}

func (c *redisClient) Get(ctx context.Context, key string) (string, error) {
	val, err := c.cli.Get(ctx, key).Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return "", merror.NewNotFound(fmt.Sprintf("%s does not exist", key))
		}
		return "", merror.WrapInternal(err, "failed to redis Get")
	}
	return val, nil
}

func (c *redisClient) Del(ctx context.Context, key string) error {
	err := c.cli.Del(ctx, key).Err()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return merror.NewNotFound(fmt.Sprintf("%s does not exist", key))
		}
		return merror.WrapInternal(err, "failed to redis Del")
	}
	return nil
}

func (c *redisClient) SAdd(ctx context.Context, key string, values ...interface{}) error {
	if err := c.cli.SAdd(ctx, key, values...).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis SAdd")
	}
	return nil
}

func (c *redisClient) SRem(ctx context.Context, key string, members ...interface{}) error {
	err := c.cli.SRem(ctx, key, members...).Err()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return merror.NewNotFound(fmt.Sprintf("not exist. key: %s, members: %v, ", key, members))
		}
		return merror.WrapInternal(err, "failed to redis SRem")
	}
	return nil
}

func (c *redisClient) SMembers(ctx context.Context, key string) ([]string, error) {
	members, err := c.cli.SMembers(ctx, key).Result()
	if err != nil {
		return nil, merror.WrapInternal(err, "failed to redis SMembers")
	}
	if members == nil {
		return []string{}, nil
	}
	return members, nil
}

func (c *redisClient) PublishStream(ctx context.Context, streamKey string, messages map[string]interface{}) error {
	values := make([]interface{}, 0, len(messages)*2)
	for k, v := range messages {
		values = append(values, k, v)
	}

	if err := c.cli.XAdd(ctx, &redis.XAddArgs{
		Stream: streamKey,
		MaxLen: 1,
		ID:     "*",
		Values: values,
	}).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis XAdd")
	}
	return nil
}

func (c *redisClient) ReadStream(ctx context.Context, streamKey, messageKey, previousID string) (id, message string, err error) {
	const subscribeDuration = 3 * time.Second

	cmd := c.cli.XRead(ctx, &redis.XReadArgs{
		Streams: []string{streamKey, previousID},
		Block:   subscribeDuration,
	})
	streams, err := cmd.Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return "", "", merror.NewNotFound("response nil from stream")
		}
		return "", "", merror.WrapInternal(err, "failed to redis XRead")
	}

	stream := streams[0]
	msg := stream.Messages[len(stream.Messages)-1]
	v, ok := msg.Values[messageKey].(string)
	if !ok {
		logger.FromCtx(ctx).Warn("cast to string from stream message failed", slog.Any("message", msg))
		return "", "", nil
	}

	return msg.ID, v, nil
}

func (c *redisClient) ReadStreamLatest(ctx context.Context, streamKey, messageKey string) (id, message string, err error) {
	return c.ReadStream(ctx, streamKey, messageKey, "0")
}

func (c *redisClient) Expire(ctx context.Context, key string, duration time.Duration) error {
	if err := c.cli.Expire(ctx, key, duration).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis Expire")
	}

	return nil
}
