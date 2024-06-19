package domain

import (
	"fmt"

	"github.com/swallowarc/porker2/backend/internal/core/random"
)

const (
	roomIDPattern       = "1234567890"
	roomIDKeyPrefix     = "porker2_room_id"
	roomMemberKeyPrefix = "porker2_room_member"
	roomStreamKeyPrefix = "porker2_room_stream"
)

type (
	RoomID string
)

func NewRoomID() RoomID {
	return RoomID(random.RandString6ByParam(5, roomIDPattern))
}

func (id RoomID) IDKey() string {
	return fmt.Sprintf("%s:%s", roomIDKeyPrefix, id)
}

func (id RoomID) MemberKey() string {
	return fmt.Sprintf("%s:%s", roomMemberKeyPrefix, id)
}

func (id RoomID) StreamKey() string {
	return fmt.Sprintf("%s:%s", roomStreamKeyPrefix, id)
}

func (id RoomID) String() string {
	return string(id)
}
