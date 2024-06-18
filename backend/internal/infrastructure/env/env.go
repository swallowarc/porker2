package env

import (
	"github.com/kelseyhightower/envconfig"

	"github.com/swallowarc/porker2/backend/internal/core/environment"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/redis"
)

var (
	Env     Environment
	Connect connect.Config
	Redis   redis.Config
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
}
