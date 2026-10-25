// Package config は環境変数からアプリケーション設定を読み込む。
// init() では読まず Load を fx に Provide することで、設定の読み込み失敗が起動エラーとして
// 報告され、config を import するだけのテストが環境変数を要求されなくなる。
package config

import (
	"fmt"

	"github.com/kelseyhightower/envconfig"

	"github.com/swallowarc/porker2/backend/internal/core/environment"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/redis"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
)

type (
	Config struct {
		Env     Environment
		Connect connect.Config
		Redis   redis.Config
		Session session.Config
	}

	Environment struct {
		EnvType environment.Type `envconfig:"env" default:"local"`
	}
)

// Load は環境変数から全設定を読み込む。prefix はそれぞれ ""(ENV), CONNECT_, REDIS_, SESSION_。
func Load() (Config, error) {
	var c Config
	for _, s := range []struct {
		prefix string
		spec   any
	}{
		{"", &c.Env},
		{"connect", &c.Connect},
		{"redis", &c.Redis},
		{"session", &c.Session},
	} {
		if err := envconfig.Process(s.prefix, s.spec); err != nil {
			return Config{}, fmt.Errorf("failed to load config (prefix=%q): %w", s.prefix, err)
		}
	}
	return c, nil
}
