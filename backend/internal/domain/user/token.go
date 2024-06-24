package user

import "github.com/swallowarc/porker2/backend/internal/core/random"

const (
	tokenLength         = 48
	tokenAvailableChars = "1234567890abcdefghijklmnopqrstuvwxyz!=+*-/&%$#"
)

func NewToken() string {
	return random.RandString6ByParam(tokenLength, tokenAvailableChars)
}
