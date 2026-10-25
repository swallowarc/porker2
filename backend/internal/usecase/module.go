package usecase

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/usecase/interactor"
)

func Module() fx.Option {
	return fx.Module("usecase",
		fx.Provide(
			interactor.NewUser,
			interactor.NewPoker,
		),
	)
}
