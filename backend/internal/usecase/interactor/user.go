package interactor

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	userInteractor struct {
		repo port.UserRepository
	}
)

func NewUser(repo port.UserRepository) User {
	return &userInteractor{repo: repo}
}

func (i *userInteractor) Login(ctx context.Context, loginName user.Name) (user.ID, error) {
	//TODO implement me
	panic("implement me")
}

func (i *userInteractor) Logout(ctx context.Context, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}
