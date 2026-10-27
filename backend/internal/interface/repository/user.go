package repository

import (
	"context"

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
	id := user.NewID()
	token := user.NewToken()
	m := &userModel{ID: id.String(), Name: userName.String(), Token: token}

	set, err := r.mem.SetNX(ctx, userNameKey(userName), id.String(), user.SessionLifetimeDuration)
	if err != nil {
		return user.ID{}, "", merror.WrapInternal(err, "failed to set user name")
	} else if !set {
		return user.ID{}, "", merror.NewAlreadyExists("user name already exists")
	}

	j, err := encodeUser(m)
	if err != nil {
		return user.ID{}, "", err
	}

	set, err = r.mem.SetNX(ctx, userIDKey(id), j, user.SessionLifetimeDuration)
	if err != nil {
		return user.ID{}, "", merror.WrapInternal(err, "failed to set user id")
	} else if !set {
		return user.ID{}, "", merror.NewAlreadyExists("user id already exists")
	}

	if _, err := r.mem.SetNX(ctx, userTokenKey(token), id.String(), user.SessionLifetimeDuration); err != nil {
		return user.ID{}, "", merror.WrapInternal(err, "failed to set user token")
	}

	return id, token, nil
}

func (r *userRepository) UpdateRoomID(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	m, err := r.getUserModel(ctx, userID)
	if err != nil {
		return err
	}

	m.RoomID = roomID.String()

	j, err := encodeUser(m)
	if err != nil {
		return err
	}

	return r.mem.Set(ctx, userIDKey(userID), j, user.SessionLifetimeDuration)
}

func (r *userRepository) Delete(ctx context.Context, userID user.ID) error {
	m, err := r.getUserModel(ctx, userID)
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
		return ignoreNotFound(r.mem.Del(ctx, userNameKeyRaw(m.Name)), "failed to delete user name")
	})

	eg.Go(func() error {
		return ignoreNotFound(r.mem.Del(ctx, userTokenKey(m.Token)), "failed to delete user token")
	})

	return eg.Wait()
}

func (r *userRepository) ResetLifetime(ctx context.Context, userID user.ID) error {
	m, err := r.getUserModel(ctx, userID)
	if err != nil {
		return err
	}

	var eg errgroup.Group

	eg.Go(func() error {
		return r.mem.Expire(ctx, userIDKey(userID), user.SessionLifetimeDuration)
	})

	eg.Go(func() error {
		return r.mem.Expire(ctx, userNameKeyRaw(m.Name), user.SessionLifetimeDuration)
	})

	eg.Go(func() error {
		return r.mem.Expire(ctx, userTokenKey(m.Token), user.SessionLifetimeDuration)
	})

	return eg.Wait()
}

func (r *userRepository) GetIDByAccessToken(ctx context.Context, token string) (user.ID, error) {
	j, err := r.mem.Get(ctx, userTokenKey(token))
	if err != nil {
		if merror.IsNotFound(err) {
			return user.ID{}, merror.NewNotFound("user token does not exist")
		}
		return user.ID{}, merror.WrapInternal(err, "failed to get user token")
	}

	id, err := user.ParseID(j)
	if err != nil {
		return user.ID{}, merror.WrapInternal(err, "corrupted user token entry")
	}

	return id, nil
}

func (r *userRepository) GetByID(ctx context.Context, userID user.ID) (user.Name, string, poker.RoomID, error) {
	m, err := r.getUserModel(ctx, userID)
	if err != nil {
		return user.Name{}, "", poker.RoomID{}, err
	}

	name, roomID, err := m.toDomain()
	if err != nil {
		return user.Name{}, "", poker.RoomID{}, err
	}

	return name, m.Token, roomID, nil
}

func (r *userRepository) GetIDByName(ctx context.Context, userName user.Name) (user.ID, error) {
	j, err := r.mem.Get(ctx, userNameKey(userName))
	if err != nil {
		if merror.IsNotFound(err) {
			return user.ID{}, merror.NewNotFound("user name does not exist")
		}
		return user.ID{}, merror.WrapInternal(err, "failed to get user name")
	}

	id, err := user.ParseID(j)
	if err != nil {
		return user.ID{}, merror.WrapInternal(err, "corrupted user name entry")
	}

	return id, nil
}

// getUserModel はユーザーの永続化モデルを取得する。
// NotFound は呼び出し側 (usecase) が分岐に使うので、ラップせずそのまま返す。
// merror.WrapInternal で包むと外側の KindInternal が優先され、merror.IsNotFound が false になる。
func (r *userRepository) getUserModel(ctx context.Context, userID user.ID) (*userModel, error) {
	j, err := r.mem.Get(ctx, userIDKey(userID))
	if err != nil {
		if merror.IsNotFound(err) {
			return nil, merror.NewNotFound("user does not exist: %s", userID.String())
		}
		return nil, merror.WrapInternal(err, "failed to get user")
	}

	return decodeUser(j)
}

func ignoreNotFound(err error, messageFormat string, args ...any) error {
	if err == nil || merror.IsNotFound(err) {
		return nil
	}
	return merror.WrapInternal(err, messageFormat, args...)
}
