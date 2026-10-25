package poker

import (
	"regexp"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
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
	// RoomID は 5 桁の数字からなる部屋の識別子。
	// 外部入力からは必ず NewRoomID で生成し、事前条件を満たさない値を作らないこと。
	// ゼロ値は「どの部屋にも属していない」ことを表す (IsZero)。
	RoomID string
)

// NewRoomID は外部入力から RoomID を生成する。形式を満たさなければ InvalidArgument を返す。
func NewRoomID(raw string) (RoomID, error) {
	if !roomIDRegexp.MatchString(raw) {
		return "", merror.NewInvalidArgument(nil, "room id must be %d digits: %q", roomIDLength, raw)
	}
	return RoomID(raw), nil
}

func newRoomID() RoomID {
	return RoomID(random.RandString6ByParam(roomIDLength, roomIDAvailableChars))
}

func (id RoomID) String() string {
	return string(id)
}

func (id RoomID) IsZero() bool {
	return id == ""
}
