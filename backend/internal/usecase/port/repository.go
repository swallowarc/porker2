//go:generate mockgen -source=$GOFILE -destination=../../test/mock/$GOPACKAGE/mock_$GOFILE -package=mock_$GOPACKAGE
package port

import (
	"context"
	"time"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

type (
	UserRepository interface {
		Create(ctx context.Context, userName user.Name) (user.ID, string, error)
		Delete(ctx context.Context, userID user.ID) error
		ResetLifetime(ctx context.Context, userID user.ID) error
		GetIDByAccessToken(ctx context.Context, token string) (user.ID, error)
		GetNameByID(ctx context.Context, userID user.ID) (user.Name, error)
		GetIDByName(ctx context.Context, userName user.Name) (user.ID, error)
	}

	RoomSubscriber func(ctx context.Context, condition *poker.RoomCondition) error

	PokerRepository interface {
		CreateRoom(ctx context.Context) (poker.RoomID, error)
		GetRoomIDByUserID(ctx context.Context, userID user.ID) (poker.RoomID, error)
		GetRoomCondition(ctx context.Context, roomID poker.RoomID) (*poker.RoomCondition, error)
		AddRoomUser(ctx context.Context, roomID poker.RoomID, userID user.ID) error
		RemoveRoomUser(ctx context.Context, userID user.ID) error
		UpdateBallot(ctx context.Context, roomID poker.RoomID, userID user.ID, point poker.Point) error
		UpdateVoteState(ctx context.Context, roomID poker.RoomID, state poker.VoteState) error
		ResetRoomCondition(ctx context.Context, roomID poker.RoomID) error
		SubscribeRoomCondition(ctx context.Context, block time.Duration, fn RoomSubscriber) error
	}
)
