package poker

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

func TestNewRoomID(t *testing.T) {
	id, err := NewRoomID("12345")
	assert.NoError(t, err)
	assert.Equal(t, RoomID("12345"), id)

	for _, raw := range []string{"", "1234", "123456", "abcde", "1234a", " 12345"} {
		_, err := NewRoomID(raw)
		assert.True(t, merror.IsInvalidArgument(err), "raw=%q err=%v", raw, err)
	}
}

func Test_newRoomID(t *testing.T) {
	for range 100 {
		_, err := NewRoomID(newRoomID().String())
		assert.NoError(t, err, "生成した RoomID は常に事前条件を満たす")
	}
}
