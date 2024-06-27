//go:generate mockgen -source=$GOFILE -destination=../../test/mock/$GOPACKAGE/mock_$GOFILE -package=mock_$GOPACKAGE
package gateway

import (
	"context"
	"time"
)

type (
	MemDBClient interface {
		Ping(ctx context.Context) error
		Set(ctx context.Context, key string, value any, duration time.Duration) error
		SetNX(ctx context.Context, key string, value any, duration time.Duration) (bool, error)
		Get(ctx context.Context, key string) (string, error)
		Del(ctx context.Context, key string) error
		SAdd(ctx context.Context, key string, values ...any) error
		SRem(ctx context.Context, key string, members ...any) error
		SMembers(ctx context.Context, key string) ([]string, error)
		PublishStream(ctx context.Context, streamKey string, messages map[string]any) error
		ReadStream(ctx context.Context, streamKey, messageKey, previousID string) (id, message string, err error)
		ReadStreamLatest(ctx context.Context, streamKey, messageKey string) (message string, err error)
		Expire(ctx context.Context, key string, duration time.Duration) error
	}
)
