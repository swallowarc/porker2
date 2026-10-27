package user

import (
	"regexp"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

var (
	nameRegexp = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,10}$`)
)

// Name は英数字とアンダースコア・ハイフンからなる 1〜10 文字のユーザー名。
type Name struct {
	v string
}

// NewName は外部入力から Name を生成する。形式を満たさなければ InvalidArgument を返す。
func NewName(raw string) (Name, error) {
	if !nameRegexp.MatchString(raw) {
		return Name{}, merror.NewInvalidArgument(nil, "user name must be 1-10 chars of [a-zA-Z0-9_-]: %q", raw)
	}
	return Name{v: raw}, nil
}

// MustName は NewName の panic 版。リテラルから作る (テスト等) 用途に限る。
func MustName(raw string) Name {
	n, err := NewName(raw)
	if err != nil {
		panic(err)
	}
	return n
}

func (n Name) String() string {
	return n.v
}
