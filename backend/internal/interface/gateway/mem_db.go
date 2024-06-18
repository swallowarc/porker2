//go:generate mockgen -source=$GOFILE -destination=../../tests/mocks/$GOPACKAGE/mock_$GOFILE -package=mock_$GOPACKAGE
package gateways

import (
	"context"
	"time"
)

type (
	MemDBClient interface {
		Ping(ctx context.Context) error
		Set(ctx context.Context, key string, value interface{}, duration time.Duration) error
		SetNX(ctx context.Context, key string, value interface{}, duration time.Duration) error
		Get(ctx context.Context, key string) (string, error)
		Del(ctx context.Context, key string) error
		SAdd(ctx context.Context, key string, values ...interface{}) error
		SRem(ctx context.Context, key string, members ...interface{}) error
		SMembers(ctx context.Context, key string) ([]string, error)
		PublishStream(ctx context.Context, streamKey string, messages map[string]interface{}) error
		ReadStream(ctx context.Context, streamKey, messageKey, previousID string) (id, message string, err error)
		ReadStreamLatest(ctx context.Context, streamKey, messageKey string) (id, message string, err error)
		Expire(ctx context.Context, key string, duration time.Duration) error
	}
)
