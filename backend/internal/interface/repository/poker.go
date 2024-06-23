package repository

import (
	"context"
	"time"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/interface/gateway"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

type (
	pokerRepository struct {
		mem gateway.MemDBClient
	}
)

func NewPokerRepository(mem gateway.MemDBClient) port.PokerRepository {
	return &pokerRepository{
		mem: mem,
	}
}

func (r *pokerRepository) CreateRoom(ctx context.Context) (poker.RoomID, error) {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) GetRoomIDByUserID(ctx context.Context, userID user.ID) (poker.RoomID, error) {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) GetRoomCondition(ctx context.Context, roomID poker.RoomID) (*poker.RoomCondition, error) {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) AddRoomUser(ctx context.Context, roomID poker.RoomID, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) RemoveRoomUser(ctx context.Context, userID user.ID) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) UpdateBallot(ctx context.Context, roomID poker.RoomID, userID user.ID, point poker.Point) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) UpdateVoteState(ctx context.Context, roomID poker.RoomID, state poker.VoteState) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) ResetRoomCondition(ctx context.Context, roomID poker.RoomID) error {
	//TODO implement me
	panic("implement me")
}

func (r *pokerRepository) SubscribeRoomCondition(ctx context.Context, block time.Duration, fn port.RoomSubscribeFunc) error {
	//TODO implement me
	panic("implement me")
}
