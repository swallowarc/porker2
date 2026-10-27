package config

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/environment"
)

func unsetenv(t *testing.T, key string) {
	t.Helper()
	t.Setenv(key, "") // テスト終了時に元の値へ復元させるため
	require.NoError(t, os.Unsetenv(key))
}

func TestLoad(t *testing.T) {
	t.Run("required が未設定なら error を返す (panic しない)", func(t *testing.T) {
		unsetenv(t, "CONNECT_CORS_ALLOW_ORIGINS")

		_, err := Load()
		require.Error(t, err)
		assert.Contains(t, err.Error(), `prefix="connect"`)
		assert.Contains(t, err.Error(), "CORS_ALLOW_ORIGINS")
	})

	t.Run("default と環境変数が反映される", func(t *testing.T) {
		t.Setenv("CONNECT_CORS_ALLOW_ORIGINS", "http://a,http://b")
		t.Setenv("ENV", "prod")
		t.Setenv("REDIS_HOST_PORT", "redis:6380")
		t.Setenv("SESSION_COOKIE_SECURE", "true")
		unsetenv(t, "CONNECT_PORT")

		c, err := Load()
		require.NoError(t, err)
		assert.Equal(t, environment.Prod, c.Env.EnvType)
		assert.Equal(t, []string{"http://a", "http://b"}, c.Connect.CORSAllowOrigins)
		assert.Equal(t, 8080, c.Connect.Port, "default")
		assert.Equal(t, "redis:6380", c.Redis.HostPort)
		assert.True(t, c.Session.CookieSecure)
	})
}
