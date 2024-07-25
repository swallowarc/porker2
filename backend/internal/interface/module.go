package interfaces

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/interface/controller"
	"github.com/swallowarc/porker2/backend/internal/interface/interceptor"
	"github.com/swallowarc/porker2/backend/internal/interface/repository"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
)

func Module() fx.Option {
	return fx.Module("interface",
		fx.Provide(
			controller.NewPorker2Controller,
			interceptor.NewFactory,
			session.NewManager,
			repository.NewUserRepository,
			repository.NewPokerRepository,
		),
	)
}
