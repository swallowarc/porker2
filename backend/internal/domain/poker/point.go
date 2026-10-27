package poker

import (
	"slices"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

// Point は見積もりの投票値。定義済みの値以外は NewPoint で拒否される。
type Point int32

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

// NewPoint は外部入力から Point を生成する。
// PointUnspecified は「未投票に戻す」操作として正当な入力なので許容する。
func NewPoint(raw int32) (Point, error) {
	p := Point(raw)
	if !slices.Contains(PointList, p) {
		return PointUnspecified, merror.NewInvalidArgument(nil, "unknown point: %d", raw)
	}
	return p, nil
}

func (p Point) Int32() int32 { return int32(p) }

func (p Point) IsUnspecified() bool { return p == PointUnspecified }
