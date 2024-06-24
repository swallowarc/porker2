//go:generate mockgen -source=$GOFILE -destination=../../test/mock/$GOPACKAGE/mock_$GOFILE -package=mock_$GOPACKAGE
package interactor

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	User interface {
		// Login creates a new login session and returns user id & access token.
		Login(ctx context.Context, userName user.Name) (user.ID, string, error)
		// Logout deletes the user session.
		Logout(ctx context.Context, userID user.ID) error
	}

	Poker interface {
		// CreateRoom creates a new room and returns the room ID.
		CreateRoom(ctx context.Context) (poker.RoomID, error)
		// JoinRoom joins the room.
		JoinRoom(ctx context.Context, userID user.ID, roomID poker.RoomID, fn port.RoomSubscriber) error
		// LeaveRoom leaves the room.
		LeaveRoom(ctx context.Context, userID user.ID) error
		// CastVote casts a vote.
		CastVote(ctx context.Context, userID user.ID, roomID poker.RoomID, point poker.Point) error
		// ShowVotes shows votes in the room.
		ShowVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error
		// ResetVotes resets votes in the room.
		ResetVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error
		// Kick kicks the target login session.
		Kick(ctx context.Context, userID, targetUserID user.ID, roomID poker.RoomID) error
	}
)
