package poker

import (
	"slices"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

type (
	Point    int32
	UserRole int32
)

const (
	PointUnspecified Point = 0
	Point0           Point = 1
	Point05          Point = 2
	Point1           Point = 3
	Point2           Point = 4
	Point3           Point = 5
	Point5           Point = 6
	Point8           Point = 7
	Point13          Point = 8
	Point21          Point = 9
	PointCoffee      Point = 100
	PointQuestion    Point = 101
)

const (
	UserRoleUnspecified UserRole = 0
	UserRoleVoter       UserRole = 1
	UserRoleObserver    UserRole = 2
)

var (
	PointList = []Point{
		PointUnspecified,
		Point0,
		Point05,
		Point1,
		Point2,
		Point3,
		Point5,
		Point8,
		Point13,
		Point21,
		PointCoffee,
		PointQuestion,
	}
)

// NewPoint は外部入力から Point を生成する。
// PointUnspecified は「未投票に戻す」操作として正当な入力なので許容する。
func NewPoint(raw int32) (Point, error) {
	p := Point(raw)
	if !slices.Contains(PointList, p) {
		return PointUnspecified, merror.NewInvalidArgument(nil, "unknown point: %d", raw)
	}
	return p, nil
}

type (
	Ballot struct {
		UserID   user.ID   `json:"user_id"`
		UserName user.Name `json:"user_name"`
		Point    Point     `json:"point"`
		Role     UserRole  `json:"role"`
	}
)

func newBallot(userID user.ID, userName user.Name) *Ballot {
	return &Ballot{
		UserID:   userID,
		UserName: userName,
		Point:    PointUnspecified,
		Role:     UserRoleVoter,
	}
}

func (b *Ballot) Reset() {
	b.Point = PointUnspecified
}

func (b *Ballot) IsObserver() bool {
	return b.Role == UserRoleObserver
}

func (b *Ballot) SetObserverMode(isObserver bool) {
	if isObserver {
		b.Role = UserRoleObserver
		b.Point = PointUnspecified
	} else {
		b.Role = UserRoleVoter
	}
}
