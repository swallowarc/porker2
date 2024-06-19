package interactor

import (
	"context"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	pokerInteractor struct {
		repo port.PokerRepository
	}
)

func NewPoker(repo port.PokerRepository) Poker {
	return &pokerInteractor{repo: repo}
}

func (i *pokerInteractor) CreateRoom(ctx context.Context, userID user.ID) (poker.RoomID, error) {
	//TODO implement me
	panic("implement me")
}

func (i *pokerInteractor) JoinRoom(ctx context.Context, userID user.ID, roomID poker.RoomID, ch chan<- *poker.RoomCondition) error {
	//TODO implement me
	panic("implement me")
}

func (i *pokerInteractor) LeaveRoom(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	//TODO implement me
	panic("implement me")
}

func (i *pokerInteractor) CastVote(ctx context.Context, userID user.ID, roomID poker.RoomID, point poker.Point) error {
	//TODO implement me
	panic("implement me")
}

func (i *pokerInteractor) ShowVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	//TODO implement me
	panic("implement me")
}

func (i *pokerInteractor) ResetVotes(ctx context.Context, userID user.ID, roomID poker.RoomID) error {
	//TODO implement me
	panic("implement me")
}
