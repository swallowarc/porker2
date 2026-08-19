package poker_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
)

func TestPoint_Value(t *testing.T) {
	t.Parallel()

	tests := map[string]struct {
		point poker.Point
		want  float64
		wanOK bool
	}{
		"Point0 は 0":             {point: poker.Point0, want: 0, wanOK: true},
		"Point05 は 0.5":          {point: poker.Point05, want: 0.5, wanOK: true},
		"Point21 は 21":           {point: poker.Point21, want: 21, wanOK: true},
		"PointCoffee は数値を持たない":   {point: poker.PointCoffee, want: 0, wanOK: false},
		"PointQuestion は数値を持たない": {point: poker.PointQuestion, want: 0, wanOK: false},
	}

	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			t.Parallel()

			got, ok := tt.point.Value()
			assert.Equal(t, tt.wanOK, ok)
			assert.InDelta(t, tt.want, got, 0.0001)
		})
	}
}

func TestRoomCondition_AveragePoint(t *testing.T) {
	t.Parallel()

	c := poker.NewRoomCondition()
	assert.NoError(t, c.Join("user1", "user1"))
	assert.NoError(t, c.Join("user2", "user2"))
	c.Vote("user1", poker.Point3)
	c.Vote("user2", poker.Point5)

	assert.InDelta(t, 4.0, c.AveragePoint(), 0.0001)
}
