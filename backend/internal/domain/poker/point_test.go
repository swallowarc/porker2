package poker

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPoint_IsUnspecified(t *testing.T) {
	// PointUnspecified は PointList の先頭要素なので、[1:] で除外して確認する。
	assert.True(t, PointUnspecified.IsUnspecified())

	for _, p := range PointList[1:] {
		assert.False(t, p.IsUnspecified(), "raw=%d", p.Int32())
	}
}

func TestPoint_Int32(t *testing.T) {
	for _, p := range PointList {
		// 往復しても同じ値になること
		got, err := NewPoint(p.Int32())
		assert.NoError(t, err, "raw=%d", p.Int32())
		assert.Equal(t, p, got)
	}
}

func TestNewPoint_Unknown(t *testing.T) {
	for _, raw := range []int32{-1, 999} {
		got, err := NewPoint(raw)
		assert.Error(t, err, "raw=%d", raw)
		assert.Equal(t, PointUnspecified, got, "raw=%d", raw)
	}
}
