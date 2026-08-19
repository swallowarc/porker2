package poker

import (
	"sort"
)

type (
	// TShirtSize は T シャツサイズ表示モードでのサイズ表記。
	TShirtSize string
)

const (
	TShirtSizeXS  TShirtSize = "XS"
	TShirtSizeS   TShirtSize = "S"
	TShirtSizeM   TShirtSize = "M"
	TShirtSizeL   TShirtSize = "L"
	TShirtSizeXL  TShirtSize = "XL"
	TShirtSizeXXL TShirtSize = "XXL"
)

// tshirtCache はポイントから T シャツサイズへの変換結果のキャッシュ。
// 変換は表示のたびに呼ばれるため、計算結果を再利用する。
var tshirtCache = map[float64]TShirtSize{}

// ToTShirtSize はポイントの数値を T シャツサイズに変換する。
func ToTShirtSize(point float64) TShirtSize {
	if s, ok := tshirtCache[point]; ok {
		return s
	}

	var size TShirtSize
	switch {
	case point <= 0.5:
		size = TShirtSizeXS
	case point <= 2:
		size = TShirtSizeS
	case point < 5:
		size = TShirtSizeM
	case point <= 8:
		size = TShirtSizeL
	case point <= 13:
		size = TShirtSizeXL
	default:
		size = TShirtSizeXXL
	}

	tshirtCache[point] = size

	return size
}

// MedianPoint は投票者のポイントの中央値を返す。
// オブザーバー、および数値を持たないポイントは計算対象から除外する。
func (c *RoomCondition) MedianPoint() float64 {
	values := make([]float64, 0, len(c.Ballots))
	for _, b := range c.Ballots {
		if b.IsObserver() {
			continue
		}

		v, ok := b.Point.Value()
		if !ok {
			continue
		}

		values = append(values, v)
	}

	if len(values) == 0 {
		return 0
	}

	sort.Float64s(values)

	return values[len(values)/2]
}

// AverageTShirtSize は投票者のポイント平均を T シャツサイズで返す。
func (c *RoomCondition) AverageTShirtSize() TShirtSize {
	return ToTShirtSize(c.AveragePoint())
}
