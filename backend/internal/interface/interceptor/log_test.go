package interceptor

import (
	"bytes"
	"context"
	"errors"
	"log/slog"
	"strings"
	"testing"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
)

func Test_levelOf(t *testing.T) {
	cases := []struct {
		name string
		err  error
		want slog.Level
	}{
		{"InvalidArgument はクライアント起因なので WARN", merror.NewInvalidArgument(nil, "x"), slog.LevelWarn},
		{"NotFound", merror.NewNotFound("x"), slog.LevelWarn},
		{"AlreadyExists", merror.NewAlreadyExists("x"), slog.LevelWarn},
		{"PermissionDenied", merror.NewPermissionDenied("x"), slog.LevelWarn},
		{"Unauthenticated", merror.NewUnauthenticated("x"), slog.LevelWarn},
		{"FailedPrecondition", merror.NewFailedPrecondition("x"), slog.LevelWarn},
		{"Unavailable (ロック競合など一時的)", merror.NewUnavailable("x"), slog.LevelWarn},
		{"Internal はサーバー起因なので ERROR", merror.NewInternal("x"), slog.LevelError},
		{"WrapInternal で包まれたものも ERROR", merror.WrapInternal(merror.NewNotFound("x"), "y"), slog.LevelError},
		{"Canceled はクライアント切断なので INFO", merror.NewCanceled("x"), slog.LevelInfo},
		{"context.Canceled", context.Canceled, slog.LevelInfo},
		{"ラップされた context.Canceled", merror.WrapInternal(context.Canceled, "stream"), slog.LevelInfo},
		{"未分類の error は ERROR", errors.New("plain"), slog.LevelError},
		{"Kind 不明の merror は ERROR", merror.New(merror.KindUnknown, "x"), slog.LevelError},
		{"connect.Error (client code)", connect.NewError(connect.CodeInvalidArgument, errors.New("x")), slog.LevelWarn},
		{"connect.Error (server code)", connect.NewError(connect.CodeInternal, errors.New("x")), slog.LevelError},
		{"connect.Error (canceled)", connect.NewError(connect.CodeCanceled, errors.New("x")), slog.LevelInfo},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			assert.Equal(t, c.want, levelOf(c.err), "err=%v", c.err)
		})
	}
}

func TestLogInterceptor_WrapUnary(t *testing.T) {
	spec := connect.Spec{Procedure: "/porker.v2.Porker2Service/CastVote"}

	run := func(t *testing.T, handlerErr error) string {
		var buf bytes.Buffer
		l := slog.New(slog.NewTextHandler(&buf, &slog.HandlerOptions{Level: slog.LevelDebug}))

		next := func(ctx context.Context, _ connect.AnyRequest) (connect.AnyResponse, error) {
			return nil, handlerErr
		}
		req := connect.NewRequest(&struct{}{})
		_, err := NewLogInterceptor(l).WrapUnary(next)(context.Background(), &specRequest{AnyRequest: req, spec: spec})
		require.Equal(t, handlerErr, err, "interceptor はエラーを書き換えない")
		return buf.String()
	}

	t.Run("成功は INFO", func(t *testing.T) {
		out := run(t, nil)
		assert.Contains(t, out, "level=INFO")
		assert.Contains(t, out, "rpc_name=CastVote")
		assert.Contains(t, out, "request_id=")
	})

	t.Run("クライアント起因は WARN で kind 付き", func(t *testing.T) {
		out := run(t, merror.NewFailedPrecondition("not in room"))
		assert.Contains(t, out, "level=WARN")
		assert.Contains(t, out, "kind=failed_precondition")
		assert.Contains(t, out, "not in room")
	})

	t.Run("サーバー起因は ERROR", func(t *testing.T) {
		out := run(t, merror.WrapInternal(errors.New("redis down"), "failed"))
		assert.Contains(t, out, "level=ERROR")
		assert.Contains(t, out, "kind=internal")
	})

	t.Run("ERROR 以外の経路で ERROR が出ていない", func(t *testing.T) {
		out := run(t, merror.NewInvalidArgument(nil, "bad"))
		assert.False(t, strings.Contains(out, "level=ERROR"), out)
	})
}

// specRequest は Spec() を差し替えるためのラッパー。
type specRequest struct {
	connect.AnyRequest
	spec connect.Spec
}

func (r *specRequest) Spec() connect.Spec { return r.spec }
