package poker

import (
	"slices"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

type (
	Point int32
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

func (p Point) Valid() bool {
	return slices.Contains(PointList, p)
}

type (
	Ballot struct {
		UserID   user.ID   `validate:"user_id" json:"user_id"`
		UserName user.Name `json:"user_name"`
		Point    Point     `validate:"point" json:"point"`
	}
)

func newBallot(userID user.ID, userName user.Name) *Ballot {
	return &Ballot{
		UserID:   userID,
		UserName: userName,
		Point:    PointUnspecified,
	}
}

func (b *Ballot) Reset() {
	b.Point = PointUnspecified
}
