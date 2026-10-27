package connect

import (
	"context"
	"log/slog"
	"net"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/interface/interceptor"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
)

type stubSession struct{}

func (stubSession) VerifyToken(context.Context, *http.Request) (any, error) { return nil, nil }
func (stubSession) UserIDFromCtx(context.Context) user.ID                   { return user.ID{} }
func (stubSession) SetCookie(context.Context, string)                       {}
func (stubSession) RefreshCookie(context.Context)                           {}

func newTestServer(t *testing.T, port int) *Server {
	t.Helper()
	conf := Config{Host: "127.0.0.1", Port: port, CORSAllowOrigins: []string{"http://localhost"}}
	return NewServer(slog.Default(), conf, pbconn.UnimplementedPorker2ServiceHandler{}, stubSession{}, interceptor.NewFactory(slog.Default()))
}

func TestServer_Start_ReturnsErrorWhenPortInUse(t *testing.T) {
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	require.NoError(t, err)
	defer ln.Close()
	port := ln.Addr().(*net.TCPAddr).Port

	err = newTestServer(t, port).Start(context.Background())
	require.Error(t, err, "使用中のポートは起動エラーとして同期的に報告される")
	assert.Contains(t, err.Error(), "failed to listen")
}

func TestServer_Start_Shutdown(t *testing.T) {
	srv := newTestServer(t, 0) // 空きポート
	require.NoError(t, srv.Start(context.Background()))
	assert.NoError(t, srv.Shutdown(context.Background()))
}
