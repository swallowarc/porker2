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

// Login はユーザーを作成しセッションを開始する。
// 名前の重複は Create がアトミックに検出して AlreadyExists を返すため、事前チェックはしない
// (事前チェックは競合時に守りにならず、RTT を 1 回増やすだけ)。
func (i *userInteractor) Login(ctx context.Context, userName user.Name) (user.ID, string, error) {
	return i.userRepo.Create(ctx, userName)
}

// Logout はセッションを破棄する。冪等であり、ユーザーや部屋が既に消えていても成功を返す。
func (i *userInteractor) Logout(ctx context.Context, userID user.ID) error {
	_, _, roomID, err := i.userRepo.GetByID(ctx, userID)
	if err != nil {
		if merror.IsNotFound(err) {
			return nil
		}
		return err
	}

	var eg errgroup.Group

	if !roomID.IsZero() {
		eg.Go(func() error {
			err := i.pokerRepo.UpdateRoomWithLock(ctx, roomID, func(ctx context.Context, c *poker.Room) error {
				c.Leave(userID)
				return nil
			})
			if err != nil && !merror.IsNotFound(err) {
				return err
			}
			// 部屋が TTL 切れで既に消えている場合は退室処理は不要
			return nil
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
		return user.Name{}, asSessionError(err)
	}

	return name, nil
}
