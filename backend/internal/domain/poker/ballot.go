package poker

import (
	"slices"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

type (
	Point int32

	Ballot struct {
		UerName user.Name
		UserID  user.ID `validate:"user_id"`
		Point   Point   `validate:"point"`
	}
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
