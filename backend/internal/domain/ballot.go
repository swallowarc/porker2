package domain

type (
	Point int32

	Ballot struct {
		UserID string
		Point  Point
	}
)

const (
	Point_POINT_UNSPECIFIED Point = 0
	Point_POINT_0           Point = 1
	Point_POINT_0_5         Point = 2
	Point_POINT_1           Point = 3
	Point_POINT_2           Point = 4
	Point_POINT_3           Point = 5
	Point_POINT_5           Point = 6
	Point_POINT_8           Point = 7
	Point_POINT_13          Point = 8
	Point_POINT_21          Point = 9
	Point_POINT_COFFEE      Point = 100
	Point_POINT_QUESTION    Point = 101
)
