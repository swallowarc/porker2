package merror

import (
	"errors"
	"fmt"
	"io"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestKindOf(t *testing.T) {
	assert.Equal(t, KindNotFound, KindOf(NewNotFound("x")))
	assert.Equal(t, KindUnknown, KindOf(errors.New("plain")))
	assert.Equal(t, KindUnknown, KindOf(nil))

	// fmt.Errorf の %w で包まれていても種別を辿れる
	wrapped := fmt.Errorf("outer: %w", NewAlreadyExists("x"))
	assert.True(t, IsAlreadyExists(wrapped))
}

func TestWrap_OuterKindWins(t *testing.T) {
	inner := NewNotFound("key missing")
	outer := WrapInternal(inner, "failed to load")

	// 包んだ側の種別が優先される。下位の種別を伝えたいなら Wrap してはいけない。
	assert.True(t, IsInternal(outer))
	assert.False(t, IsNotFound(outer))

	// ただし errors.Is で元エラーには到達できる
	assert.True(t, errors.Is(outer, inner))
	assert.Equal(t, "failed to load: key missing", outer.Error())
}

func TestWrap_PreservesStdlibErrors(t *testing.T) {
	err := WrapInternal(io.EOF, "read failed")
	assert.True(t, errors.Is(err, io.EOF))
}

func TestNewInvalidArgument(t *testing.T) {
	fvs := FieldViolations{{"f1", "d1"}, {"f2", "d2"}}
	err := NewInvalidArgument(fvs, "invalid")

	assert.True(t, IsInvalidArgument(err))
	assert.Equal(t, fvs, FieldViolationsOf(err))
	assert.Nil(t, FieldViolationsOf(NewNotFound("x")))
	assert.Nil(t, FieldViolationsOf(errors.New("plain")))
}

func TestKind_String(t *testing.T) {
	assert.Equal(t, "not_found", KindNotFound.String())
	assert.Equal(t, "kind(99)", Kind(99).String())
}

func TestPredicates(t *testing.T) {
	cases := []struct {
		err  error
		pred func(error) bool
	}{
		{NewNotFound("x"), IsNotFound},
		{NewFailedPrecondition("x"), IsFailedPrecondition},
		{NewPermissionDenied("x"), IsPermissionDenied},
		{NewInvalidArgument(nil, "x"), IsInvalidArgument},
		{NewInternal("x"), IsInternal},
		{NewUnauthenticated("x"), IsUnauthenticated},
		{NewAlreadyExists("x"), IsAlreadyExists},
		{NewUnavailable("x"), IsUnavailable},
		{NewCanceled("x"), IsCanceled},
	}
	for _, c := range cases {
		assert.True(t, c.pred(c.err), "%v", c.err)
		assert.False(t, c.pred(errors.New("plain")))
	}
}
