package config

import (
	"github.com/kelseyhightower/envconfig"

	"github.com/swallowarc/porker2/backend/internal/core/environment"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/redis"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
)

var (
	Env     Environment
	Connect connect.Config
	Redis   redis.Config
	Session session.Config
)

type (
	Environment struct {
		EnvType environment.Type `envconfig:"env" default:"local"`
	}
)

func init() {
	setup()
}

func setup() {
	envconfig.MustProcess("", &Env)
	envconfig.MustProcess("connect", &Connect)
	envconfig.MustProcess("redis", &Redis)
	envconfig.MustProcess("session", &Session)
}
