package infrastructure

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/infrastructure/config"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/redis"
)

func Module() fx.Option {
	return fx.Module("infrastructure",
		fx.Supply(
			config.Env,
			config.Env.EnvType,
			config.Connect,
			config.Redis,
			config.Session,
		),
		fx.Provide(
			connect.NewServer,
			redis.NewRedisClient,
		),
	)
}
