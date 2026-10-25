package redis

import (
	"context"
	"os"
	"testing"
	"time"
	"uuid"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
)

// 実 Redis に対する結合テスト。REDIS_TEST_ADDR (例: localhost:6379) が設定されている場合のみ実行する。
func newTestClient(t *testing.T) gateway.MemDBClient {
	t.Helper()
	addr := os.Getenv("REDIS_TEST_ADDR")
	if addr == "" {
		t.Skip("REDIS_TEST_ADDR is not set")
	}
	cli := NewRedisClient(Config{HostPort: addr, Password: os.Getenv("REDIS_TEST_PASSWORD"), DB: 15})
	require.NoError(t, cli.Ping(context.Background()))
	return cli
}

func testKey(t *testing.T) string {
	t.Helper()
	return "porker2_test:" + t.Name() + ":" + uuid.New().String()
}

func TestRedisClient_CompareAndDelete(t *testing.T) {
	cli := newTestClient(t)
	ctx := context.Background()
	key := testKey(t)
	defer cli.Del(ctx, key)

	t.Run("key が無ければ false", func(t *testing.T) {
		ok, err := cli.CompareAndDelete(ctx, key, "token-a")
		require.NoError(t, err)
		assert.False(t, ok)
	})

	set, err := cli.SetNX(ctx, key, "token-a", time.Minute)
	require.NoError(t, err)
	require.True(t, set)

	t.Run("値が異なれば削除しない", func(t *testing.T) {
		ok, err := cli.CompareAndDelete(ctx, key, "token-b")
		require.NoError(t, err)
		assert.False(t, ok)
		v, err := cli.Get(ctx, key)
		require.NoError(t, err)
		assert.Equal(t, "token-a", v)
	})

	t.Run("値が一致すれば削除する", func(t *testing.T) {
		ok, err := cli.CompareAndDelete(ctx, key, "token-a")
		require.NoError(t, err)
		assert.True(t, ok)
		_, err = cli.Get(ctx, key)
		assert.True(t, merror.IsNotFound(err))
	})
}

func TestRedisClient_SetAllIfAbsent(t *testing.T) {
	cli := newTestClient(t)
	ctx := context.Background()
	guard, k2, k3 := testKey(t), testKey(t), testKey(t)
	defer func() {
		for _, k := range []string{guard, k2, k3} {
			_ = cli.Del(ctx, k)
		}
	}()

	entries := map[string]any{guard: "g", k2: "v2", k3: "v3"}

	t.Run("guard が無ければ全て保存される", func(t *testing.T) {
		ok, err := cli.SetAllIfAbsent(ctx, guard, entries, time.Minute)
		require.NoError(t, err)
		assert.True(t, ok)
		for k, want := range entries {
			v, err := cli.Get(ctx, k)
			require.NoError(t, err)
			assert.Equal(t, want, v)
		}
	})

	t.Run("guard が既にあれば何も保存しない", func(t *testing.T) {
		require.NoError(t, cli.Del(ctx, k2))
		ok, err := cli.SetAllIfAbsent(ctx, guard, map[string]any{guard: "g2", k2: "new", k3: "new"}, time.Minute)
		require.NoError(t, err)
		assert.False(t, ok)

		_, err = cli.Get(ctx, k2)
		assert.True(t, merror.IsNotFound(err), "k2 は書き戻されていない")
		v, err := cli.Get(ctx, k3)
		require.NoError(t, err)
		assert.Equal(t, "v3", v, "k3 は上書きされていない")
	})

	t.Run("guard が entries に無ければエラー", func(t *testing.T) {
		_, err := cli.SetAllIfAbsent(ctx, "missing", map[string]any{k2: "x"}, time.Minute)
		assert.True(t, merror.IsInternal(err))
	})
}

func TestRedisClient_Stream(t *testing.T) {
	cli := newTestClient(t)
	ctx := context.Background()
	key := testKey(t)
	defer cli.Del(ctx, key)

	v, err := cli.ReadStreamLatest(ctx, key, "m")
	require.NoError(t, err)
	assert.Equal(t, "", v, "存在しない stream は空文字")

	require.NoError(t, cli.PublishStream(ctx, key, map[string]any{"m": "first"}))
	require.NoError(t, cli.PublishStream(ctx, key, map[string]any{"m": "second"}))

	v, err = cli.ReadStreamLatest(ctx, key, "m")
	require.NoError(t, err)
	assert.Equal(t, "second", v, "MaxLen 1 なので最新だけ残る")

	id, msg, err := cli.ReadStream(ctx, key, "m", "0")
	require.NoError(t, err)
	assert.NotEmpty(t, id)
	assert.Equal(t, "second", msg)
}
