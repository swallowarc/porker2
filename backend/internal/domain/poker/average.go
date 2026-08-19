package poker

// pointValues は Point と見積もりポイントの数値表現の対応表。
// PointCoffee / PointQuestion / PointUnspecified は数値を持たないため含まない。
var pointValues = map[Point]float64{
	Point0:  0,
	Point05: 0.5,
	Point1:  1,
	Point2:  2,
	Point3:  3,
	Point5:  5,
	Point8:  8,
	Point13: 13,
	Point21: 21,
}

// Value は Point の数値表現を返す。
// 数値として扱えない Point の場合、ok は false になる。
func (p Point) Value() (float64, bool) {
	v, ok := pointValues[p]
	return v, ok
}

// AveragePoint は投票者のポイントの平均値を返す。
// オブザーバーは平均の計算対象から除外する。
func (c *RoomCondition) AveragePoint() float64 {
	sum := 0.0
	for _, b := range c.Ballots {
		if b.IsObserver() {
			continue
		}

		v, _ := b.Point.Value()
		sum += v
	}

	return sum / float64(len(c.Ballots))
}
