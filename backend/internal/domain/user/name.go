package user

import (
	"regexp"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

// Name は英数字とアンダースコア・ハイフンからなる 1〜10 文字のユーザー名。
// 外部入力からは必ず NewName で生成すること。
type Name string

var (
	nameRegexp = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,10}$`)
)

// NewName は外部入力から Name を生成する。形式を満たさなければ InvalidArgument を返す。
func NewName(raw string) (Name, error) {
	n := Name(raw)
	if !nameRegexp.MatchString(raw) {
		return "", merror.NewInvalidArgument(nil, "user name must be 1-10 chars of [a-zA-Z0-9_-]: %q", raw)
	}
	return n, nil
}

func (n Name) String() string {
	return string(n)
}
