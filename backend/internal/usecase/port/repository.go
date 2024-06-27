//go:generate mockgen -source=$GOFILE -destination=../../test/mock/$GOPACKAGE/mock_$GOFILE -package=mock_$GOPACKAGE
package port

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

type (
	UserRepository interface {
		Create(ctx context.Context, userName user.Name) (user.ID, string, error)
		UpdateRoomID(ctx context.Context, userID user.ID, roomID poker.RoomID) error
		Delete(ctx context.Context, userID user.ID) error
		ResetLifetime(ctx context.Context, userID user.ID) error

		GetIDByAccessToken(ctx context.Context, token string) (user.ID, error)
		GetByID(ctx context.Context, userID user.ID) (user.Name, string, poker.RoomID, error)
		GetIDByName(ctx context.Context, userName user.Name) (user.ID, error)
	}

	RoomModifier   func(ctx context.Context, condition *poker.RoomCondition) error
	RoomSubscriber func(ctx context.Context, condition *poker.RoomCondition) (bool, error)

	PokerRepository interface {
		CreateRoom(ctx context.Context) (poker.RoomID, error)
		UpdateRoomWithLock(ctx context.Context, roomID poker.RoomID, modifier RoomModifier) error

		GetRoomCondition(ctx context.Context, roomID poker.RoomID) (*poker.RoomCondition, error)
		SubscribeRoomCondition(ctx context.Context, roomID poker.RoomID, fn RoomSubscriber) error
	}
)
