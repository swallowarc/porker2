package poker

import (
	"fmt"
	"regexp"

	"github.com/swallowarc/porker2/backend/internal/core/random"
)

const (
	roomIDLength         = 5
	roomIDAvailableChars = "1234567890"
	roomIDKeyPrefix      = "porker2_room_id"
	roomMemberKeyPrefix  = "porker2_room_member"
	roomStreamKeyPrefix  = "porker2_room_stream"
)

var (
	roomIDRegexp = regexp.MustCompile(`^[0-9]{5}$`)
)

type (
	RoomID string
)

func NewRoomID() RoomID {
	return RoomID(random.RandString6ByParam(roomIDLength, roomIDAvailableChars))
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

func (id RoomID) Valid() bool {
	return roomIDRegexp.MatchString(string(id))
}
