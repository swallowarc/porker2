package poker

import (
	"slices"
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

// ToTShirtSize はポイントの数値を T シャツサイズに変換する。
func ToTShirtSize(point float64) TShirtSize {
	switch {
	case point <= 0.5:
		return TShirtSizeXS
	case point <= 2:
		return TShirtSizeS
	case point <= 5:
		return TShirtSizeM
	case point <= 8:
		return TShirtSizeL
	case point <= 13:
		return TShirtSizeXL
	default:
		return TShirtSizeXXL
	}
}

// MedianPoint は投票者のポイントの中央値を返す。
// 計算対象が偶数件の場合は中央 2 件の平均を返す。
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

	slices.Sort(values)

	mid := len(values) / 2
	if len(values)%2 == 0 {
		return (values[mid-1] + values[mid]) / 2
	}

	return values[mid]
}

// AverageTShirtSize は投票者のポイント平均を T シャツサイズで返す。
func (c *RoomCondition) AverageTShirtSize() TShirtSize {
	return ToTShirtSize(c.AveragePoint())
}
