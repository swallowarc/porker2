package core

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
)

func Module() fx.Option {
	return fx.Module("core",
		fx.Provide(
			logger.NewLogger,
		),
	)
}
