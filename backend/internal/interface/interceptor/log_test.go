package interceptor

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"io"
	"log/slog"
	"strings"
	"sync"
	"testing"

	"connectrpc.com/connect/v2"
	"connectrpc.com/connect/v2/connectinprocess"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
)

// stubHandler は interceptor の挙動確認用。ハンドラ内で見えた ctx のロガーも記録する。
// 各 RPC は結果のレベル分けを検証するため、種別の異なるエラーを返す。
type stubHandler struct {
	pbconn.UnimplementedPorker2ServiceHandler
	mu            sync.Mutex
	handlerLogger *slog.Logger
}

func (h *stubHandler) capture(ctx context.Context) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.handlerLogger = logger.FromCtx(ctx)
}

func (h *stubHandler) Login(ctx context.Context, _ *pb.LoginRequest) (*pb.LoginResponse, error) {
	h.capture(ctx)
	return &pb.LoginResponse{}, nil
}

// Logout: ハンドラが直接返した connect.Error (サーバー側コード)
func (h *stubHandler) Logout(ctx context.Context, _ *pb.LogoutRequest) (*pb.LogoutResponse, error) {
	h.capture(ctx)
	return nil, connect.NewError(connect.CodeInternal, "boom")
}

// CastVote: クライアント起因の merror
func (h *stubHandler) CastVote(ctx context.Context, _ *pb.CastVoteRequest) (*pb.CastVoteResponse, error) {
	h.capture(ctx)
	return nil, merror.NewFailedPrecondition("not in room")
}

// ShowVotes: サーバー起因の merror
func (h *stubHandler) ShowVotes(ctx context.Context, _ *pb.ShowVotesRequest) (*pb.ShowVotesResponse, error) {
	h.capture(ctx)
	return nil, merror.WrapInternal(errors.New("redis down"), "failed")
}

func (h *stubHandler) JoinRoom(ctx context.Context, _ *pb.JoinRoomRequest, stream pbconn.Porker2ServiceJoinRoomServerStream) error {
	h.capture(ctx)
	return stream.Send(&pb.JoinRoomResponse{})
}

type syncBuffer struct {
	mu sync.Mutex
	b  bytes.Buffer
}

func (s *syncBuffer) Write(p []byte) (int, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.b.Write(p)
}

func (s *syncBuffer) records(t *testing.T) []map[string]any {
	t.Helper()
	s.mu.Lock()
	defer s.mu.Unlock()
	var out []map[string]any
	for _, line := range strings.Split(strings.TrimSpace(s.b.String()), "\n") {
		if line == "" {
			continue
		}
		var m map[string]any
		require.NoError(t, json.Unmarshal([]byte(line), &m))
		out = append(out, m)
	}
	return out
}

func setup(t *testing.T) (pbconn.Porker2ServiceClient, *stubHandler, *syncBuffer) {
	t.Helper()
	buf := &syncBuffer{}
	l := slog.New(slog.NewJSONHandler(buf, &slog.HandlerOptions{Level: slog.LevelDebug}))

	h := &stubHandler{}
	server := connect.NewServer(NewLogInterceptor(l))
	pbconn.RegisterPorker2ServiceHandler(server, h)
	client := pbconn.NewPorker2ServiceClient(connect.NewClient(connectinprocess.New(server)))
	return client, h, buf
}

func assertRPCFields(t *testing.T, rec map[string]any, rpcName string) {
	t.Helper()
	assert.Equal(t, rpcName, rec["rpc_name"])
	assert.NotEmpty(t, rec["request_id"], "request_id should be attached")
}

func TestLogInterceptor_Unary(t *testing.T) {
	t.Parallel()

	t.Run("success", func(t *testing.T) {
		t.Parallel()
		client, h, buf := setup(t)

		_, err := client.Login(context.Background(), &pb.LoginRequest{})
		require.NoError(t, err)

		recs := buf.records(t)
		require.Len(t, recs, 1)
		assert.Equal(t, "INFO", recs[0]["level"])
		assert.Equal(t, "success to call unary", recs[0]["msg"])
		assertRPCFields(t, recs[0], "Login")

		// ハンドラ内の ctx からも rpc_name 付きロガーが取れる
		h.mu.Lock()
		hl := h.handlerLogger
		h.mu.Unlock()
		require.NotNil(t, hl)
		hl.Info("from handler")
		recs = buf.records(t)
		require.Len(t, recs, 2)
		assertRPCFields(t, recs[1], "Login")
	})

	t.Run("connect.Error (server code) is ERROR", func(t *testing.T) {
		t.Parallel()
		client, _, buf := setup(t)

		_, err := client.Logout(context.Background(), &pb.LogoutRequest{})
		var cerr *connect.Error
		require.True(t, errors.As(err, &cerr))
		assert.Equal(t, connect.CodeInternal, cerr.Code())

		recs := buf.records(t)
		require.Len(t, recs, 1)
		assert.Equal(t, "ERROR", recs[0]["level"])
		assert.Equal(t, "failed to call unary", recs[0]["msg"])
		assert.Contains(t, recs[0]["error"], "boom")
		assertRPCFields(t, recs[0], "Logout")
	})

	t.Run("client-caused merror is WARN with kind", func(t *testing.T) {
		t.Parallel()
		client, _, buf := setup(t)

		_, err := client.CastVote(context.Background(), &pb.CastVoteRequest{})
		require.Error(t, err)

		recs := buf.records(t)
		require.Len(t, recs, 1)
		assert.Equal(t, "WARN", recs[0]["level"])
		assert.Equal(t, "failed_precondition", recs[0]["kind"])
		assert.Contains(t, recs[0]["error"], "not in room")
		assertRPCFields(t, recs[0], "CastVote")
	})

	t.Run("server-caused merror is ERROR with kind", func(t *testing.T) {
		t.Parallel()
		client, _, buf := setup(t)

		_, err := client.ShowVotes(context.Background(), &pb.ShowVotesRequest{})
		require.Error(t, err)

		recs := buf.records(t)
		require.Len(t, recs, 1)
		assert.Equal(t, "ERROR", recs[0]["level"])
		assert.Equal(t, "internal", recs[0]["kind"])
		assertRPCFields(t, recs[0], "ShowVotes")
	})
}

func TestLogInterceptor_ServerStream(t *testing.T) {
	t.Parallel()
	client, _, buf := setup(t)

	stream, err := client.JoinRoom(context.Background(), &pb.JoinRoomRequest{})
	require.NoError(t, err)
	_, err = stream.Receive()
	require.NoError(t, err)
	_, err = stream.Receive()
	require.ErrorIs(t, err, io.EOF)
	require.NoError(t, stream.Close())

	recs := buf.records(t)
	require.Len(t, recs, 2)
	assert.Equal(t, "success to connect streaming", recs[0]["msg"])
	assert.Equal(t, "success to disconnect streaming", recs[1]["msg"])
	for _, r := range recs {
		assert.Equal(t, "INFO", r["level"])
		assertRPCFields(t, r, "JoinRoom")
	}
	// 同一 RPC 内では request_id が共有される
	assert.Equal(t, recs[0]["request_id"], recs[1]["request_id"])
}

func TestGetRPCNameFromSpec(t *testing.T) {
	t.Parallel()
	assert.Equal(t, "Login", getRPCNameFromSpec(connect.Spec{Procedure: "/porker.v2.Porker2Service/Login"}))
	assert.Equal(t, "", getRPCNameFromSpec(connect.Spec{Procedure: ""}))
}

func Test_levelOf(t *testing.T) {
	t.Parallel()
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
		{"context.DeadlineExceeded は WARN", context.DeadlineExceeded, slog.LevelWarn},
		{"ラップされた context.DeadlineExceeded", merror.WrapInternal(context.DeadlineExceeded, "redis"), slog.LevelWarn},
		{"connect.Error (deadline exceeded)", connect.NewError(connect.CodeDeadlineExceeded, "x"), slog.LevelWarn},
		{"未分類の error は ERROR", errors.New("plain"), slog.LevelError},
		{"Kind 不明の merror は ERROR", merror.New(merror.KindUnknown, "x"), slog.LevelError},
		{"connect.Error (client code)", connect.NewError(connect.CodeInvalidArgument, "x"), slog.LevelWarn},
		{"connect.Error (server code)", connect.NewError(connect.CodeInternal, "x"), slog.LevelError},
		{"connect.Error (canceled)", connect.NewError(connect.CodeCanceled, "x"), slog.LevelInfo},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			assert.Equal(t, c.want, levelOf(c.err), "err=%v", c.err)
		})
	}
}
