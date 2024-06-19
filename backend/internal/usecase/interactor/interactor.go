package interactor

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain"
)

type (
	User interface {
		// Login creates a new login session and returns access token.
		Login(ctx context.Context, loginName string) (string, error)
		// Logout deletes the login session.
		Logout(ctx context.Context, userID string) error
		// Kick kicks the target login session.
		Kick(ctx context.Context, userID, targetUserID string) error
	}

	Porker interface {
		// CreateRoom creates a new room and returns the room ID.
		CreateRoom(ctx context.Context, userID string) (domain.RoomID, error)
		// JoinRoom joins the room.
		JoinRoom(ctx context.Context, userID string, roomID domain.RoomID) (<-chan *domain.RoomCondition, error)
		// LeaveRoom leaves the room.
		LeaveRoom(ctx context.Context, userID string, roomID domain.RoomID) error
		// CastVote casts a vote.
		CastVote(ctx context.Context, userID string, roomID domain.RoomID, point domain.Point) error
		// ShowVotes shows votes in the room.
		ShowVotes(ctx context.Context, userID string, roomID domain.RoomID) ([]domain.Ballot, error)
		// ResetVotes resets votes in the room.
		ResetVotes(ctx context.Context, userID string, roomID domain.RoomID) error
	}
)
