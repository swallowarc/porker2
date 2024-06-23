package interactor

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	userInteractor struct {
		userRepo  port.UserRepository
		pokerRepo port.PokerRepository
	}
)

func NewUser(repo port.UserRepository, pokerRepo port.PokerRepository) User {
	return &userInteractor{userRepo: repo}
}

func (i *userInteractor) Login(ctx context.Context, userName user.Name) (user.ID, string, error) {
	id, token, err := i.userRepo.Create(ctx, userName)
	if err != nil {
		return "", "", err
	}

	return id, token, nil
}

func (i *userInteractor) Logout(ctx context.Context, userID user.ID) error {
	if err := i.pokerRepo.RemoveRoomUser(ctx, userID); err != nil {
		return err
	}

	if err := i.userRepo.Delete(ctx, userID); err != nil {
		return err
	}

	return nil
}
