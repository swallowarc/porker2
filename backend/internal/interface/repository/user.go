package repository

import (
	"context"
	"encoding/json"

	"golang.org/x/sync/errgroup"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
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
	u := newUser(userName)

	set, err := r.mem.SetNX(ctx, userNameKey(userName), u.ID.String(), user.SessionLifetimeDuration)
	if err != nil {
		return "", "", merror.WrapInternal(err, "failed to set user name")
	} else if !set {
		return "", "", merror.NewAlreadyExists("user name already exists")
	}

	j, err := u.jsonMarshalUserInfo()
	if err != nil {
		return "", "", merror.WrapInternal(err, "failed to marshal user")
	}

	set, err = r.mem.SetNX(ctx, userIDKey(u.ID), j, user.SessionLifetimeDuration)
	if err != nil {
		return "", "", merror.WrapInternal(err, "failed to set user id")
	} else if !set {
		return "", "", merror.NewAlreadyExists("user id already exists")
	}

	if _, err := r.mem.SetNX(ctx, userTokenKey(u.Token), u.ID.String(), user.SessionLifetimeDuration); err != nil {
		return "", "", merror.WrapInternal(err, "failed to set user token")
	}

	return u.ID, u.Token, nil
}

func (r *userRepository) UpdateRoomID(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	u, err := r.getUserModel(ctx, userID)
	if err != nil {
		return err
	}

	u.RoomID = roomID

	j, err := u.jsonMarshalUserInfo()
	if err != nil {
		return merror.WrapInternal(err, "failed to marshal user")
	}

	if err := r.mem.Set(ctx, userIDKey(userID), j, user.SessionLifetimeDuration); err != nil {
		return err
	}

	return nil
}

func (r *userRepository) Delete(ctx context.Context, userID user.ID) error {
	u, err := r.getUserModel(ctx, userID)
	if err != nil {
		if merror.IsNotFound(err) {
			return nil
		}
		return err
	}

	var eg errgroup.Group

	eg.Go(func() error {
		return ignoreNotFound(r.mem.Del(ctx, userIDKey(userID)), "failed to delete user id")
	})

	eg.Go(func() error {
		return ignoreNotFound(r.mem.Del(ctx, userNameKey(u.Name)), "failed to delete user name")
	})

	eg.Go(func() error {
		return ignoreNotFound(r.mem.Del(ctx, userTokenKey(u.Token)), "failed to delete user token")
	})

	return eg.Wait()
}

func (r *userRepository) ResetLifetime(ctx context.Context, userID user.ID) error {
	u, err := r.getUserModel(ctx, userID)
	if err != nil {
		return err
	}

	var eg errgroup.Group

	eg.Go(func() error {
		return r.mem.Expire(ctx, userIDKey(userID), user.SessionLifetimeDuration)
	})

	eg.Go(func() error {
		return r.mem.Expire(ctx, userNameKey(u.Name), user.SessionLifetimeDuration)
	})

	eg.Go(func() error {
		return r.mem.Expire(ctx, userTokenKey(u.Token), user.SessionLifetimeDuration)
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
		return "", "", "", err
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

// getUserModel はユーザーを取得する。
// NotFound は呼び出し側 (usecase) が分岐に使うので、ラップせずそのまま返す。
// merror.WrapInternal で包むと外側の CodeInternal が優先され、merror.IsNotFound が false になる。
func (r *userRepository) getUserModel(ctx context.Context, userID user.ID) (*userModel, error) {
	j, err := r.mem.Get(ctx, userIDKey(userID))
	if err != nil {
		if merror.IsNotFound(err) {
			return nil, merror.NewNotFound("user does not exist: %s", userID)
		}
		return nil, merror.WrapInternal(err, "failed to get user")
	}

	var ui userModel
	if err := json.Unmarshal([]byte(j), &ui); err != nil {
		return nil, merror.WrapInternal(err, "failed to unmarshal user")
	}
	return &ui, nil
}

func ignoreNotFound(err error, messageFormat string, args ...any) error {
	if err == nil || merror.IsNotFound(err) {
		return nil
	}
	return merror.WrapInternal(err, messageFormat, args...)
}
