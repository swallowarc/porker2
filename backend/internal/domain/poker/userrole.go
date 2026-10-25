package poker

import "github.com/swallowarc/porker2/backend/internal/core/merror"

// UserRole は部屋における参加者の役割。
type UserRole struct {
	v int32
}

var (
	UserRoleUnspecified = UserRole{0}
	UserRoleVoter       = UserRole{1}
	UserRoleObserver    = UserRole{2}
)

// NewUserRole は永続化された値などから UserRole を復元する。Unspecified は許容しない。
func NewUserRole(raw int32) (UserRole, error) {
	r := UserRole{raw}
	if r != UserRoleVoter && r != UserRoleObserver {
		return UserRoleUnspecified, merror.NewInvalidArgument(nil, "user role must be voter(%d) or observer(%d): %d", UserRoleVoter.v, UserRoleObserver.v, raw)
	}
	return r, nil
}

func (r UserRole) Int32() int32 { return r.v }
