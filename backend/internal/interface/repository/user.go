package repository

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	userRepository struct {
		mem gateway.MemDBClient
	}
)

func NewUserRepository(mem gateway.MemDBClient) port.UserRepository {
	return &userRepository{
		mem: mem,
	}
}

func (r *userRepository) Create(ctx context.Context, userName user.Name) (user.ID, string, error) {
	//TODO implement me
	panic("implement me")
}

func (r *userRepository) Delete(ctx context.Context, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}

func (r *userRepository) ResetLifetime(ctx context.Context, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}

func (r *userRepository) GetIDByAccessToken(ctx context.Context, token string) (user.ID, error) {
	//TODO implement me
	panic("implement me")
}

func (r *userRepository) GetNameByID(ctx context.Context, userID user.ID) (user.Name, error) {
	//TODO implement me
	panic("implement me")
}
