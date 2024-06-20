package repository

import "github.com/swallowarc/porker2/backend/internal/usecase/port"

type (
	pokerRepository struct {
	}
)

func NewPokerRepository() port.PokerRepository {
	return &pokerRepository{}
}
