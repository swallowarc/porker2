package rpcerr

import (
	"context"
	"errors"
	"fmt"
	"testing"

	"connectrpc.com/authn"
	"connectrpc.com/connect"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/genproto/googleapis/rpc/errdetails"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

func codeOf(t *testing.T, err error) connect.Code {
	t.Helper()
	var cerr *connect.Error
	require.True(t, errors.As(err, &cerr), "not a connect error: %v", err)
	return cerr.Code()
}

func TestToConnect_Nil(t *testing.T) {
	assert.NoError(t, ToConnect(nil))
}

func TestToConnect_KindMapping(t *testing.T) {
	cases := map[connect.Code]error{
		connect.CodeInvalidArgument:    merror.NewInvalidArgument(nil, "x"),
		connect.CodeNotFound:           merror.NewNotFound("x"),
		connect.CodeAlreadyExists:      merror.NewAlreadyExists("x"),
		connect.CodePermissionDenied:   merror.NewPermissionDenied("x"),
		connect.CodeUnauthenticated:    merror.NewUnauthenticated("x"),
		connect.CodeFailedPrecondition: merror.NewFailedPrecondition("x"),
		connect.CodeUnavailable:        merror.NewUnavailable("x"),
		connect.CodeInternal:           merror.NewInternal("x"),
		connect.CodeCanceled:           merror.NewCanceled("x"),
		connect.CodeUnknown:            merror.New(merror.KindUnknown, "x"),
	}
	for want, err := range cases {
		assert.Equal(t, want, codeOf(t, ToConnect(err)), "%v", err)
	}
}

func TestToConnect_WrappedMerrorIsStillResolved(t *testing.T) {
	err := fmt.Errorf("outer: %w", merror.NewNotFound("x"))
	assert.Equal(t, connect.CodeNotFound, codeOf(t, ToConnect(err)))
}

func TestToConnect_OriginalErrorIsReachable(t *testing.T) {
	orig := merror.NewNotFound("x")
	converted := ToConnect(orig)
	assert.True(t, errors.Is(converted, orig))
	assert.True(t, merror.IsNotFound(converted), "変換後も merror の種別判定が効くこと (ログ出力等で使う)")
}

func TestToConnect_FieldViolationsBecomeDetails(t *testing.T) {
	err := merror.NewInvalidArgument(merror.FieldViolations{{Field: "room_id", Description: "bad"}, {Field: "point", Description: "bad"}}, "invalid")

	var cerr *connect.Error
	require.True(t, errors.As(ToConnect(err), &cerr))
	assert.Equal(t, connect.CodeInvalidArgument, cerr.Code())

	details := cerr.Details()
	require.Len(t, details, 2)
	msg, derr := details[0].Value()
	require.NoError(t, derr)
	fv, ok := msg.(*errdetails.BadRequest_FieldViolation)
	require.True(t, ok)
	assert.Equal(t, "room_id", fv.Field)
}

func TestToConnect_ExistingConnectErrorPassesThrough(t *testing.T) {
	err := authn.Errorf("unable to authenticate")
	assert.Same(t, err, ToConnect(err))

	wrapped := fmt.Errorf("outer: %w", connect.NewError(connect.CodeResourceExhausted, errors.New("x")))
	assert.Equal(t, connect.CodeResourceExhausted, codeOf(t, ToConnect(wrapped)))
}

func TestToConnect_ContextErrors(t *testing.T) {
	assert.Equal(t, connect.CodeCanceled, codeOf(t, ToConnect(context.Canceled)))
	assert.Equal(t, connect.CodeDeadlineExceeded, codeOf(t, ToConnect(context.DeadlineExceeded)))
	assert.Equal(t, connect.CodeCanceled, codeOf(t, ToConnect(fmt.Errorf("wrapped: %w", context.Canceled))))
}

func TestToConnect_UnclassifiedIsInternal(t *testing.T) {
	assert.Equal(t, connect.CodeInternal, codeOf(t, ToConnect(errors.New("plain"))))
}
