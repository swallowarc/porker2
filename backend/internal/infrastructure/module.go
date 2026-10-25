package infrastructure

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/core/environment"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/config"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/redis"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
)

func Module() fx.Option {
	return fx.Module("infrastructure",
		fx.Provide(
			config.Load,
			func(c config.Config) environment.Type { return c.Env.EnvType },
			func(c config.Config) connect.Config { return c.Connect },
			func(c config.Config) redis.Config { return c.Redis },
			func(c config.Config) session.Config { return c.Session },

			connect.NewServer,
			redis.NewRedisClient,
		),
	)
}
