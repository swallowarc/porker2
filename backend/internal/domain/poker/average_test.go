package poker_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

func TestPoint_Value(t *testing.T) {
	tests := map[string]struct {
		point  poker.Point
		want   float64
		wantOK bool
	}{
		"Point0 は 0":    {point: poker.Point0, want: 0, wantOK: true},
		"Point05 は 0.5": {point: poker.Point05, want: 0.5, wantOK: true},
		"Point21 は 21":  {point: poker.Point21, want: 21, wantOK: true},
		"PointUnspecified は数値を持たない": {point: poker.PointUnspecified, want: 0, wantOK: false},
		"PointCoffee は数値を持たない":      {point: poker.PointCoffee, want: 0, wantOK: false},
		"PointQuestion は数値を持たない":    {point: poker.PointQuestion, want: 0, wantOK: false},
	}

	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			got, ok := tt.point.Value()
			assert.Equal(t, tt.wantOK, ok)
			assert.InDelta(t, tt.want, got, 0.0001)
		})
	}
}

func TestRoomCondition_AveragePoint(t *testing.T) {
	t.Run("投票者全員が数値ポイントに投票した場合、その平均を返す", func(t *testing.T) {
		c := poker.NewRoomCondition()
		assert.NoError(t, c.Join("user1", "user1"))
		assert.NoError(t, c.Join("user2", "user2"))
		c.Vote("user1", poker.Point3)
		c.Vote("user2", poker.Point5)

		assert.InDelta(t, 4.0, c.AveragePoint(), 0.0001)
	})

	t.Run("オブザーバーは分母に含まれない", func(t *testing.T) {
		c := poker.NewRoomCondition()
		assert.NoError(t, c.Join("user1", "user1"))
		assert.NoError(t, c.Join("user2", "user2"))
		assert.NoError(t, c.Join("observer", "observer"))
		c.ToggleObserverMode("observer", true)
		c.Vote("user1", poker.Point3)
		c.Vote("user2", poker.Point5)

		assert.InDelta(t, 4.0, c.AveragePoint(), 0.0001)
	})

	t.Run("未投票 / Coffee / Question は分母に含まれない", func(t *testing.T) {
		c := poker.NewRoomCondition()
		for _, id := range []user.ID{"user1", "user2", "coffee", "question", "unvoted"} {
			assert.NoError(t, c.Join(id, user.Name(id)))
		}
		c.Vote("user1", poker.Point3)
		c.Vote("user2", poker.Point5)
		c.Vote("coffee", poker.PointCoffee)
		c.Vote("question", poker.PointQuestion)

		assert.InDelta(t, 4.0, c.AveragePoint(), 0.0001)
	})

	t.Run("計算対象が居ない場合は 0 を返す", func(t *testing.T) {
		c := poker.NewRoomCondition()
		assert.InDelta(t, 0.0, c.AveragePoint(), 0.0001)

		assert.NoError(t, c.Join("user1", "user1"))
		assert.InDelta(t, 0.0, c.AveragePoint(), 0.0001, "未投票のみの場合も 0")

		c.ToggleObserverMode("user1", true)
		assert.InDelta(t, 0.0, c.AveragePoint(), 0.0001, "全員オブザーバーの場合も 0")
	})
}
