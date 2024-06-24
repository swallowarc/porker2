package repository

import (
	"context"
	"log/slog"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

const (
	idGenerateRetryLimit = 10
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
	var (
		userID  user.ID
		nameKey = nameIDKey(userName)
	)

	for i := 0; i <= idGenerateRetryLimit; i++ {
		userID = user.NewID()
		idKey := idNameKey(userID)

		set, err := r.mem.SetNX(ctx, idKey, userName, user.SessionLifetime)
		if err != nil {
			return "", "", merror.WrapInternal(err, "failed to set user id")
		}
		if !set {
			continue
		}

		set, err = r.mem.SetNX(ctx, nameKey, userID, user.SessionLifetime)
		if err != nil {
			return "", "", merror.WrapInternal(err, "failed to set user name")
		}
		if !set {
			if err := r.mem.Del(ctx, idKey); err != nil {
				logger.FromCtx(ctx).Error("failed to delete user id", slog.String("err", err.Error()))
			}
			return "", "", merror.NewAlreadyExists("", "user name already exists")
		}
		break
	}

	token := user.NewToken()
	if _, err := r.mem.SetNX(ctx, tokenKey(token), userID, user.SessionLifetime); err != nil {
		return "", "", merror.WrapInternal(err, "failed to set user token")
	}

	return userID, token, nil
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

func (r *userRepository) GetIDByName(ctx context.Context, userName user.Name) (user.ID, error) {
	//TODO implement me
	panic("implement me")
}
