package poker_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
)

func TestToTShirtSize(t *testing.T) {
	tests := map[string]struct {
		point float64
		want  poker.TShirtSize
	}{
		"0 は XS":    {point: 0, want: poker.TShirtSizeXS},
		"0.5 は XS":  {point: 0.5, want: poker.TShirtSizeXS},
		"1 は S":     {point: 1, want: poker.TShirtSizeS},
		"2 は S":     {point: 2, want: poker.TShirtSizeS},
		"3 は M":     {point: 3, want: poker.TShirtSizeM},
		"8 は L":     {point: 8, want: poker.TShirtSizeL},
		"13 は XL":   {point: 13, want: poker.TShirtSizeXL},
		"21 は XXL":  {point: 21, want: poker.TShirtSizeXXL},
		"100 は XXL": {point: 100, want: poker.TShirtSizeXXL},
	}

	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			assert.Equal(t, tt.want, poker.ToTShirtSize(tt.point))
		})
	}
}

func TestRoomCondition_MedianPoint(t *testing.T) {
	t.Run("投票者が奇数人の場合、中央の値を返す", func(t *testing.T) {
		c := poker.NewRoomCondition()
		assert.NoError(t, c.Join("user1", "user1"))
		assert.NoError(t, c.Join("user2", "user2"))
		assert.NoError(t, c.Join("user3", "user3"))
		c.Vote("user1", poker.Point8)
		c.Vote("user2", poker.Point2)
		c.Vote("user3", poker.Point5)

		assert.InDelta(t, 5.0, c.MedianPoint(), 0.0001)
	})

	t.Run("計算対象が居ない場合は 0 を返す", func(t *testing.T) {
		c := poker.NewRoomCondition()

		assert.InDelta(t, 0.0, c.MedianPoint(), 0.0001)
	})
}

func TestRoomCondition_AverageTShirtSize(t *testing.T) {
	c := poker.NewRoomCondition()
	assert.NoError(t, c.Join("user1", "user1"))
	assert.NoError(t, c.Join("user2", "user2"))
	c.Vote("user1", poker.Point1)
	c.Vote("user2", poker.Point3)

	assert.Equal(t, poker.TShirtSizeS, c.AverageTShirtSize())
}
