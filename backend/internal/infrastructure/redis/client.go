package redis

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"github.com/redis/go-redis/v9"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	gateways "github.com/swallowarc/porker2/backend/internal/interface/gateway"
)

const (
	maxRetries    = 5
	latestEntry   = "+"
	earliestEntry = "-"
)

var (
	// compareAndDeleteScript: 値が一致する場合のみ削除する。ロック解放で他者のロックを消さないために使う。
	compareAndDeleteScript = redis.NewScript(`
if redis.call("GET", KEYS[1]) == ARGV[1] then
  return redis.call("DEL", KEYS[1])
end
return 0`)

	// setAllIfAbsentScript: KEYS[1] (guard) が無い場合のみ、全 KEYS を ARGV の対応値で SET する。
	// 最後の ARGV は TTL (ミリ秒)。
	setAllIfAbsentScript = redis.NewScript(`
if redis.call("EXISTS", KEYS[1]) == 1 then
  return 0
end
for i = 1, #KEYS do
  redis.call("SET", KEYS[i], ARGV[i], "PX", ARGV[#ARGV])
end
return 1`)
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

func (c *redisClient) Set(ctx context.Context, key string, value any, duration time.Duration) error {
	if err := c.cli.Set(ctx, key, value, duration).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis Set")
	}
	return nil
}

func (c *redisClient) SetNX(ctx context.Context, key string, value any, duration time.Duration) (bool, error) {
	ret, err := c.cli.SetNX(ctx, key, value, duration).Result()
	if err != nil {
		return false, merror.WrapInternal(err, "failed to redis SetNX")
	}

	return ret, nil
}

func (c *redisClient) SetAllIfAbsent(ctx context.Context, guardKey string, entries map[string]any, duration time.Duration) (bool, error) {
	guardValue, ok := entries[guardKey]
	if !ok {
		return false, merror.NewInternal("guard key %q must be included in entries", guardKey)
	}

	keys := make([]string, 0, len(entries))
	args := make([]any, 0, len(entries)+1)
	keys = append(keys, guardKey)
	args = append(args, guardValue)
	for k, v := range entries {
		if k == guardKey {
			continue
		}
		keys = append(keys, k)
		args = append(args, v)
	}
	args = append(args, duration.Milliseconds())

	n, err := setAllIfAbsentScript.Run(ctx, c.cli, keys, args...).Int()
	if err != nil {
		return false, merror.WrapInternal(err, "failed to redis SetAllIfAbsent")
	}

	return n == 1, nil
}

func (c *redisClient) Get(ctx context.Context, key string) (string, error) {
	val, err := c.cli.Get(ctx, key).Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return "", merror.NewNotFound("%s does not exist", key)
		}
		return "", merror.WrapInternal(err, "failed to redis Get")
	}
	return val, nil
}

func (c *redisClient) Del(ctx context.Context, key string) error {
	err := c.cli.Del(ctx, key).Err()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return merror.NewNotFound("%s does not exist", key)
		}
		return merror.WrapInternal(err, "failed to redis Del")
	}
	return nil
}

func (c *redisClient) CompareAndDelete(ctx context.Context, key string, expected string) (bool, error) {
	n, err := compareAndDeleteScript.Run(ctx, c.cli, []string{key}, expected).Int()
	if err != nil {
		return false, merror.WrapInternal(err, "failed to redis CompareAndDelete")
	}

	return n == 1, nil
}

func (c *redisClient) SAdd(ctx context.Context, key string, values ...any) error {
	if err := c.cli.SAdd(ctx, key, values...).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis SAdd")
	}
	return nil
}

func (c *redisClient) SRem(ctx context.Context, key string, members ...any) error {
	err := c.cli.SRem(ctx, key, members...).Err()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return merror.NewNotFound("not exist. key: %s, members: %v", key, members)
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

func (c *redisClient) PublishStream(ctx context.Context, streamKey string, messages map[string]any) error {
	values := make([]any, 0, len(messages)*2)
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
	// Streamの存在確認
	exists, err := c.cli.Exists(ctx, streamKey).Result()
	if err != nil {
		return "", "", merror.WrapInternal(err, "failed to redis Exists")
	}
	if exists == 0 { // 保存期間超過などでキーが存在しない
		return "", "", merror.NewNotFound("stream key does not exist: %s", streamKey)
	}

	// 最新のメッセージを取得する
	const subscribeDuration = 3 * time.Second
	cmd := c.cli.XRead(ctx, &redis.XReadArgs{
		Streams: []string{streamKey, previousID},
		Block:   subscribeDuration,
	})

	streams, err := cmd.Result()
	if err != nil {
		// Streamに更新がない場合はNilが返却される
		if errors.Is(err, redis.Nil) {
			return previousID, "", nil
		}
		return "", "", merror.WrapInternal(err, "failed to redis XRead")
	}

	stream := streams[0]
	msg := stream.Messages[len(stream.Messages)-1] // latest message
	v, ok := msg.Values[messageKey].(string)
	if !ok {
		logger.FromCtx(ctx).Warn("cast to string from stream message failed", slog.Any("message", msg))
		return "", "", nil
	}

	return msg.ID, v, nil
}

func (c *redisClient) ReadStreamLatest(ctx context.Context, streamKey, messageKey string) (message string, err error) {
	cmd := c.cli.XRevRangeN(ctx, streamKey, latestEntry, earliestEntry, 1)
	messages, err := cmd.Result()
	if err != nil {
		return "", merror.WrapInternal(err, "failed to redis XRevRangeN")
	}
	if len(messages) == 0 {
		return "", nil
	}

	msg, ok := messages[0].Values[messageKey].(string)
	if !ok {
		logger.FromCtx(ctx).Warn("cast to string from stream message failed", slog.Any("message", msg))
		return "", nil
	}

	return msg, nil
}

func (c *redisClient) Expire(ctx context.Context, key string, duration time.Duration) error {
	if err := c.cli.Expire(ctx, key, duration).Err(); err != nil {
		return merror.WrapInternal(err, "failed to redis Expire")
	}

	return nil
}
