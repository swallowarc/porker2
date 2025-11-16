package interactor

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
)

type (
	healthInteractor struct {
		memDBClient gateway.MemDBClient
	}
)

func NewHealth(memDBClient gateway.MemDBClient) Health {
	return &healthInteractor{
		memDBClient: memDBClient,
	}
}

func (i *healthInteractor) Check(ctx context.Context) error {
	// Check Redis connectivity
	if err := i.memDBClient.Ping(ctx); err != nil {
		return err
	}

	return nil
}
