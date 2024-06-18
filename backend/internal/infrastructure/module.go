package infrastructure

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/env"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/redis"
)

func Module() fx.Option {
	return fx.Module("infrastructure",
		fx.Supply(
			env.Env,
			env.Env.EnvType,
			env.Connect,
			env.Redis,
		),
		fx.Provide(
			connect.NewServer,
			redis.NewRedisClient,
		),
	)
}
