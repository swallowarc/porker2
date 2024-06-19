package usecase

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/usecase/interactor"
)

func Module() fx.Option {
	return fx.Module("infrastructure",
		fx.Provide(
			interactor.NewUser,
			interactor.NewPoker,
		),
	)
}
