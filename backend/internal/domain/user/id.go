package user

import (
	"time"
	"uuid"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

const (
	SessionLifetimeMinutes  = 180
	SessionLifetimeDuration = SessionLifetimeMinutes * time.Minute
)

// ID は UUID 形式のユーザー識別子。
// 新規発行は NewID、外部入力からの復元は ParseID を使う。ゼロ値は「ユーザー不在」を表す (IsZero)。
type ID struct {
	v string
}

func NewID() ID {
	return ID{v: uuid.New().String()}
}

// ParseID は外部入力から ID を生成する。UUID として解釈できなければ InvalidArgument を返す。
func ParseID(raw string) (ID, error) {
	if _, err := uuid.Parse(raw); err != nil {
		return ID{}, merror.NewInvalidArgument(nil, "user id must be uuid: %q", raw)
	}
	return ID{v: raw}, nil
}

// MustParseID は ParseID の panic 版。リテラルから作る (テスト等) 用途に限る。
func MustParseID(raw string) ID {
	id, err := ParseID(raw)
	if err != nil {
		panic(err)
	}
	return id
}

func (s ID) String() string {
	return s.v
}

func (s ID) IsZero() bool {
	return s.v == ""
}
