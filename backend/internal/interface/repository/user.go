package repository

import "github.com/swallowarc/porker2/backend/internal/usecase/port"

type (
	userRepository struct {
	}
)

func NewUserRepository() port.UserRepository {
	return &userRepository{}
}
