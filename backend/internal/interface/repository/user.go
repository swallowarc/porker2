package repository

import (
	"context"
	"encoding/json"
	"log/slog"

	"golang.org/x/sync/errgroup"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
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

	userModel struct {
		ID     user.ID      `json:"id"`
		Name   user.Name    `json:"name"`
		Token  string       `json:"token"`
		RoomID poker.RoomID `json:"room_id,omitempty"`
	}
)

func (m *userModel) jsonMarshalUserInfo() (string, error) {
	j, err := json.Marshal(m)
	return string(j), err
}

func NewUserRepository(mem gateway.MemDBClient) port.UserRepository {
	return &userRepository{
		mem: mem,
	}
}

func (r *userRepository) Create(ctx context.Context, userName user.Name) (user.ID, string, error) {
	var (
		u       *userModel
		nameKey = userNameKey(userName)
	)

	// Retry to generate a unique user ID.
	for i := 0; i <= idGenerateRetryLimit; i++ {
		u = &userModel{
			ID:    user.NewID(),
			Name:  userName,
			Token: user.NewToken(),
		}
		idKey := userIDKey(u.ID)

		j, err := u.jsonMarshalUserInfo()
		if err != nil {
			return "", "", merror.WrapInternal(err, "failed to marshal user")
		}

		set, err := r.mem.SetNX(ctx, idKey, j, user.SessionLifetime)
		if err != nil {
			return "", "", merror.WrapInternal(err, "failed to set user id")
		}
		if !set {
			continue
		}

		set, err = r.mem.SetNX(ctx, nameKey, u.ID.String(), user.SessionLifetime)
		if err != nil {
			return "", "", merror.WrapInternal(err, "failed to set user name")
		}
		if !set {
			if err := r.mem.Del(ctx, idKey); err != nil {
				logger.FromCtx(ctx).Error("failed to delete user id", slog.String("err", err.Error()))
			}
			return "", "", merror.NewAlreadyExists("user name already exists")
		}
		break
	}

	if _, err := r.mem.SetNX(ctx, userTokenKey(u.Token), u.ID.String(), user.SessionLifetime); err != nil {
		return "", "", merror.WrapInternal(err, "failed to set user token")
	}

	return u.ID, u.Token, nil
}

func (r *userRepository) Delete(ctx context.Context, userID user.ID) error {
	u, err := r.getUserModel(ctx, userID)
	if err != nil {
		if merror.IsNotFound(err) {
			return nil
		}
		return merror.WrapInternal(err, "failed to unmarshal user")
	}

	var eg errgroup.Group

	eg.Go(func() error {
		if err := r.mem.Del(ctx, userIDKey(userID)); err != nil {
			if !merror.IsNotFound(err) {
				return merror.WrapInternal(err, "failed to delete user name")
			}
		}
		return nil
	})

	eg.Go(func() error {
		if err := r.mem.Del(ctx, userNameKey(u.Name)); err != nil {
			if !merror.IsNotFound(err) {
				return merror.WrapInternal(err, "failed to delete user name")
			}
		}
		return nil
	})

	eg.Go(func() error {
		if err := r.mem.Del(ctx, userTokenKey(u.Token)); err != nil {
			if !merror.IsNotFound(err) {
				return merror.WrapInternal(err, "failed to delete user name")
			}
		}
		return nil
	})

	return eg.Wait()
}

func (r *userRepository) ResetLifetime(ctx context.Context, userID user.ID) error {
	u, err := r.getUserModel(ctx, userID)
	if err != nil {
		return merror.WrapInternal(err, "failed to unmarshal user")
	}

	var eg errgroup.Group

	eg.Go(func() error {
		return r.mem.Expire(ctx, userIDKey(userID), user.SessionLifetime)
	})

	eg.Go(func() error {
		return r.mem.Expire(ctx, userNameKey(u.Name), user.SessionLifetime)
	})

	eg.Go(func() error {
		return r.mem.Expire(ctx, userTokenKey(u.Token), user.SessionLifetime)
	})

	return eg.Wait()
}

func (r *userRepository) GetIDByAccessToken(ctx context.Context, token string) (user.ID, error) {
	j, err := r.mem.Get(ctx, userTokenKey(token))
	if err != nil {
		if merror.IsNotFound(err) {
			return "", merror.NewNotFound("user token does not exist")
		}
		return "", merror.WrapInternal(err, "failed to get user token")
	}

	return user.ID(j), nil
}

func (r *userRepository) GetByID(ctx context.Context, userID user.ID) (user.Name, string, poker.RoomID, error) {
	u, err := r.getUserModel(ctx, userID)
	if err != nil {
		return "", "", "", merror.WrapInternal(err, "failed to unmarshal user")
	}

	return u.Name, u.Token, u.RoomID, nil
}

func (r *userRepository) GetIDByName(ctx context.Context, userName user.Name) (user.ID, error) {
	j, err := r.mem.Get(ctx, userNameKey(userName))
	if err != nil {
		if merror.IsNotFound(err) {
			return "", merror.NewNotFound("user name does not exist")
		}
		return "", merror.WrapInternal(err, "failed to get user name")
	}

	return user.ID(j), nil
}

func (r *userRepository) getUserModel(ctx context.Context, userID user.ID) (*userModel, error) {
	j, err := r.mem.Get(ctx, userIDKey(userID))
	if err != nil {
		return nil, err
	}

	var ui userModel
	if err := json.Unmarshal([]byte(j), &ui); err != nil {
		return nil, err
	}
	return &ui, nil
}
