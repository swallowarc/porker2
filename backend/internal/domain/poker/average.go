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
// オブザーバー、および数値を持たないポイント（未投票 / Coffee / Question）は
// 平均の計算対象から除外する。計算対象が 1 件も無い場合は 0 を返す。
func (c *RoomCondition) AveragePoint() float64 {
	sum := 0.0
	count := 0
	for _, b := range c.Ballots {
		if b.IsObserver() {
			continue
		}

		v, ok := b.Point.Value()
		if !ok {
			continue
		}

		sum += v
		count++
	}

	if count == 0 {
		return 0
	}

	return sum / float64(count)
}
