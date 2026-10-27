package poker

import (
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

// Ballot は参加者 1 人分の投票。Room の内部でのみ生成・変更される。
type Ballot struct {
	userID   user.ID
	userName user.Name
	point    Point
	role     UserRole
}

func newBallot(userID user.ID, userName user.Name) *Ballot {
	return &Ballot{
		userID:   userID,
		userName: userName,
		point:    PointUnspecified,
		role:     UserRoleVoter,
	}
}

func (b Ballot) UserID() user.ID     { return b.userID }
func (b Ballot) UserName() user.Name { return b.userName }
func (b Ballot) Point() Point        { return b.point }
func (b Ballot) Role() UserRole      { return b.role }

func (b Ballot) IsObserver() bool {
	return b.role == UserRoleObserver
}

func (b *Ballot) reset() {
	b.point = PointUnspecified
}

func (b *Ballot) setObserverMode(isObserver bool) {
	if isObserver {
		b.role = UserRoleObserver
		b.point = PointUnspecified
	} else {
		b.role = UserRoleVoter
	}
}
