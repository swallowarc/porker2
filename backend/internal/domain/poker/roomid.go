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

// RoomID は 5 桁の数字からなる部屋の識別子。
// 非公開フィールドのため、NewRoomID / MustRoomID / 部屋の新規作成以外では生成できない。
// ゼロ値は「どの部屋にも属していない」ことを表す (IsZero)。
type RoomID struct {
	v string
}

// NewRoomID は外部入力から RoomID を生成する。形式を満たさなければ InvalidArgument を返す。
func NewRoomID(raw string) (RoomID, error) {
	if !roomIDRegexp.MatchString(raw) {
		return RoomID{}, merror.NewInvalidArgument(nil, "room id must be %d digits: %q", roomIDLength, raw)
	}
	return RoomID{v: raw}, nil
}

// MustRoomID は NewRoomID の panic 版。リテラルから作る (テスト等) 用途に限る。
func MustRoomID(raw string) RoomID {
	id, err := NewRoomID(raw)
	if err != nil {
		panic(err)
	}
	return id
}

func newRoomID() RoomID {
	return RoomID{v: random.RandString6ByParam(roomIDLength, roomIDAvailableChars)}
}

func (id RoomID) String() string {
	return id.v
}

func (id RoomID) IsZero() bool {
	return id.v == ""
}
