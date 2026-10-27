package session

import (
	"context"
	"net/http"
	"testing"

	"connectrpc.com/authn"
	"connectrpc.com/connect/v2"
	"connectrpc.com/connect/v2/connectinprocess"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
)

var testUserID = user.MustParseID("0f2d6c9e-4b1a-4c3d-9e8f-123456789abc")

// stubHandler は Manager を通して Cookie を操作するだけの最小ハンドラ。
type stubHandler struct {
	pbconn.UnimplementedPorker2ServiceHandler
	mgr      Manager
	authInfo any // non-nil のとき、RefreshCookie 前に authn.SetInfo で ctx に載せる
}

func (h *stubHandler) Login(ctx context.Context, _ *pb.LoginRequest) (*pb.LoginResponse, error) {
	h.mgr.SetCookie(ctx, "token-from-login")
	return &pb.LoginResponse{UserId: "u1"}, nil
}

func (h *stubHandler) VerifyUser(ctx context.Context, _ *pb.VerifyUserRequest) (*pb.VerifyUserResponse, error) {
	if h.authInfo != nil {
		ctx = authn.SetInfo(ctx, h.authInfo)
	}
	h.mgr.RefreshCookie(ctx)
	return &pb.VerifyUserResponse{}, nil
}

func newInProcessClient(t *testing.T, h pbconn.Porker2ServiceHandler) pbconn.Porker2ServiceClient {
	t.Helper()
	server := connect.NewServer()
	pbconn.RegisterPorker2ServiceHandler(server, h)
	return pbconn.NewPorker2ServiceClient(connect.NewClient(connectinprocess.New(server)))
}

func expectedCookie(conf Config, token string) string {
	return (&http.Cookie{
		Name:     CookieKey,
		Value:    token,
		Path:     "/",
		Domain:   conf.CookieDomain,
		MaxAge:   user.SessionLifetimeMinutes * 60,
		Secure:   conf.CookieSecure,
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
	}).String()
}

func TestManager_SetCookie_ViaRPC(t *testing.T) {
	t.Parallel()

	for _, tc := range []struct {
		name string
		conf Config
	}{
		{name: "insecure/localhost", conf: Config{CookieDomain: "localhost", CookieSecure: false}},
		{name: "secure/custom domain", conf: Config{CookieDomain: "example.com", CookieSecure: true}},
	} {
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()
			mgr := NewManager(tc.conf, nil)
			client := newInProcessClient(t, &stubHandler{mgr: mgr})

			ctx, info := connect.NewClientContext(context.Background())
			_, err := client.Login(ctx, &pb.LoginRequest{UserName: "alice"})
			require.NoError(t, err)

			assert.Equal(t, expectedCookie(tc.conf, "token-from-login"), info.ResponseHeader().Get("Set-Cookie"))
		})
	}
}

func TestManager_RefreshCookie_ViaRPC(t *testing.T) {
	t.Parallel()
	conf := Config{CookieDomain: "localhost"}

	t.Run("authenticated: cookie is re-issued with the session token", func(t *testing.T) {
		t.Parallel()
		mgr := NewManager(conf, nil)
		client := newInProcessClient(t, &stubHandler{
			mgr:      mgr,
			authInfo: session{UserID: testUserID, Token: "token-from-session"},
		})

		ctx, info := connect.NewClientContext(context.Background())
		_, err := client.VerifyUser(ctx, &pb.VerifyUserRequest{})
		require.NoError(t, err)

		assert.Equal(t, expectedCookie(conf, "token-from-session"), info.ResponseHeader().Get("Set-Cookie"))
	})

	t.Run("unauthenticated: no cookie is issued", func(t *testing.T) {
		t.Parallel()
		mgr := NewManager(conf, nil)
		client := newInProcessClient(t, &stubHandler{mgr: mgr})

		ctx, info := connect.NewClientContext(context.Background())
		_, err := client.VerifyUser(ctx, &pb.VerifyUserRequest{})
		require.NoError(t, err)

		assert.Empty(t, info.ResponseHeader().Get("Set-Cookie"))
	})
}

func TestManager_SetCookie_WithoutCallInfo(t *testing.T) {
	t.Parallel()
	mgr := NewManager(Config{}, nil)

	// RPC 経路外 (call info なし) では何もせず、panic しない。
	assert.NotPanics(t, func() {
		mgr.SetCookie(context.Background(), "token")
		mgr.RefreshCookie(context.Background())
	})
}

func TestManager_UserIDFromCtx(t *testing.T) {
	t.Parallel()
	mgr := NewManager(Config{}, nil)

	assert.Equal(t, user.ID{}, mgr.UserIDFromCtx(context.Background()))
	assert.Equal(t, user.ID{}, mgr.UserIDFromCtx(authn.SetInfo(context.Background(), "not a session")))
	assert.Equal(t, testUserID, mgr.UserIDFromCtx(authn.SetInfo(context.Background(), session{UserID: testUserID})))
}
