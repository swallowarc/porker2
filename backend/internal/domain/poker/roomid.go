package poker

import (
	"regexp"

	"github.com/swallowarc/porker2/backend/internal/core/random"
)

const (
	roomIDLength         = 5
	roomIDAvailableChars = "1234567890"
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

func (id RoomID) String() string {
	return string(id)
}

func (id RoomID) Valid() bool {
	return roomIDRegexp.MatchString(string(id))
}
