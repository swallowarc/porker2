package poker

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPoint_IsUnspecified(t *testing.T) {
	// PointUnspecified は NewPoint で拒否されるため、ここでは直接参照する。
	assert.True(t, PointUnspecified.IsUnspecified())

	for _, p := range PointList[1:] {
		assert.False(t, p.IsUnspecified(), "raw=%d", p.Int32())
	}
}

func TestPoint_Int32(t *testing.T) {
	for _, p := range PointList {
		// 往復しても同じ値になること
		got, _ := NewPoint(p.Int32())
		assert.Equal(t, p, got)
	}
}
