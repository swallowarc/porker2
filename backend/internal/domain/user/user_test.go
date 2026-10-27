package user

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

func TestNewName(t *testing.T) {
	for _, raw := range []string{"a", "alice", "Al1ce_-", "0123456789"} {
		n, err := NewName(raw)
		assert.NoError(t, err, raw)
		assert.Equal(t, raw, n.String())
		assert.Equal(t, Name(raw), n)
	}
	for _, raw := range []string{"", "01234567890", "あ", "a b", "a.b", "a@b"} {
		_, err := NewName(raw)
		assert.True(t, merror.IsInvalidArgument(err), "raw=%q err=%v", raw, err)
	}
}

func TestParseID(t *testing.T) {
	id := NewID()
	assert.False(t, id.IsZero())

	parsed, err := ParseID(id.String())
	assert.NoError(t, err)
	assert.Equal(t, id, parsed)
	assert.Equal(t, id, ID(id.String()))

	for _, raw := range []string{"", "not-uuid", "0f2d6c9e-4b1a-4c3d-9e8f"} {
		_, err := ParseID(raw)
		assert.True(t, merror.IsInvalidArgument(err), "raw=%q err=%v", raw, err)
	}

	assert.True(t, ID("").IsZero())
}
