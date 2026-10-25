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
		// SetAllIfAbsent は guardKey が存在しない場合に限り entries を全て duration 付きで保存する (アトミック)。
		// guardKey は entries に含まれていること。保存したら true、guardKey が既に存在すれば false。
		SetAllIfAbsent(ctx context.Context, guardKey string, entries map[string]any, duration time.Duration) (bool, error)
		Get(ctx context.Context, key string) (string, error)
		Del(ctx context.Context, key string) error
		// CompareAndDelete は key の現在値が expected と一致する場合に限り削除する (アトミック)。
		// 削除したら true。key が存在しない、または値が異なれば false。分散ロックの解放に使う。
		CompareAndDelete(ctx context.Context, key string, expected string) (bool, error)
		SAdd(ctx context.Context, key string, values ...any) error
		SRem(ctx context.Context, key string, members ...any) error
		SMembers(ctx context.Context, key string) ([]string, error)
		PublishStream(ctx context.Context, streamKey string, messages map[string]any) error
		ReadStream(ctx context.Context, streamKey, messageKey, previousID string) (id, message string, err error)
		ReadStreamLatest(ctx context.Context, streamKey, messageKey string) (message string, err error)
		Expire(ctx context.Context, key string, duration time.Duration) error
	}
)
