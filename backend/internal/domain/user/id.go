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
type ID string

func NewID() ID {
	return ID(uuid.New().String())
}

// ParseID は外部入力から ID を生成する。UUID として解釈できなければ InvalidArgument を返す。
func ParseID(raw string) (ID, error) {
	if _, err := uuid.Parse(raw); err != nil {
		return "", merror.NewInvalidArgument(nil, "user id must be uuid: %q", raw)
	}
	return ID(raw), nil
}

func (s ID) String() string {
	return string(s)
}

func (s ID) IsZero() bool {
	return s == ""
}
