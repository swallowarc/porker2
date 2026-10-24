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
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
)

// stubHandler は interceptor の挙動確認用。ハンドラ内で見えた ctx のロガーも記録する。
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

func (h *stubHandler) Logout(ctx context.Context, _ *pb.LogoutRequest) (*pb.LogoutResponse, error) {
	h.capture(ctx)
	return nil, connect.NewError(connect.CodeInternal, "boom")
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

	t.Run("error", func(t *testing.T) {
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
