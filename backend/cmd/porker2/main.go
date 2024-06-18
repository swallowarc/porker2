package main

import (
	"context"
	"log"
	"log/slog"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"

	"github.com/swallowarc/porker2/backend/internal/core"
	"github.com/swallowarc/porker2/backend/internal/infrastructure"
	"github.com/swallowarc/porker2/backend/internal/infrastructure/connect"
	_interface "github.com/swallowarc/porker2/backend/internal/interface"
)

func main() {
	app := fx.New(
		fx.WithLogger(func(logger *slog.Logger) fxevent.Logger {
			return &fxevent.SlogLogger{Logger: logger}
		}),
		core.Module(),
		infrastructure.Module(),
		_interface.Module(),
		//usecase.Module(),
		fx.Invoke(invoke),
	)
	if err := app.Err(); err != nil {
		log.Fatalf(err.Error())
	}

	app.Run()
}

func invoke(lc fx.Lifecycle, logger *slog.Logger, server *connect.Server) {
	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			logger.Info("app start")
			server.Run()
			return nil
		},
		OnStop: func(ctx context.Context) error {
			server.Shutdown(ctx)
			logger.Info("app stop")
			return nil
		},
	})
}
