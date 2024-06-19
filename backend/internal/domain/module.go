package domain

import (
	"go.uber.org/fx"

	"github.com/swallowarc/porker2/backend/internal/domain/validator"
)

func Module() fx.Option {
	return fx.Module("domain",
		fx.Provide(
			validator.NewValidator,
		),
	)
}
