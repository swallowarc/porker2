package interactor

import (
	"context"

	"golang.org/x/sync/errgroup"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
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
	return &userInteractor{
		userRepo:  repo,
		pokerRepo: pokerRepo,
	}
}

func (i *userInteractor) Login(ctx context.Context, userName user.Name) (user.ID, string, error) {
	// Check if the userName already exists.
	if _, err := i.userRepo.GetIDByName(ctx, userName); err == nil {
		return "", "", merror.NewAlreadyExists("user name already exists")
	} else if !merror.IsNotFound(err) {
		return "", "", merror.WrapInternal(err, "failed to get user name")
	}

	id, token, err := i.userRepo.Create(ctx, userName)
	if err != nil {
		return "", "", err
	}

	return id, token, nil
}

func (i *userInteractor) Logout(ctx context.Context, userID user.ID) error {
	_, _, roomID, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		return err
	}

	var eg errgroup.Group

	if roomID != "" {
		eg.Go(func() error {
			return i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.RoomCondition) error {
				c.Leave(userID)
				return nil
			})
		})
	}

	eg.Go(func() error {
		return i.userRepo.Delete(ctx, userID)
	})

	return eg.Wait()
}

func (i *userInteractor) GetUser(ctx context.Context, userID user.ID) (user.Name, error) {
	name, _, _, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		return "", err
	}

	return name, nil
}
