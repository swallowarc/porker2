package poker

var pointScores = map[Point]float64{
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

// Score はポイントに対応する見積り値を返す。
// 数値を持たないポイント（未投票・コーヒー・?）は false を返す。
func (p Point) Score() (float64, bool) {
	s, ok := pointScores[p]
	return s, ok
}

// AveragePoint は投票されたポイントの平均値を返す。
func AveragePoint(ballots []*Ballot) float64 {
	var sum float64
	for _, b := range ballots {
		s, _ := b.Point.Score()
		sum += s
	}
	return sum / float64(len(ballots))
}
