package session

import (
	"context"
	"net/http"

	"connectrpc.com/authn"
	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/usecase/port"
)

const CookieKey = "psc"

var (
	noAuthProcedures = map[string]bool{
		"/porker.v2.Porker2Service/Login": true,
	}
)

type (
	Manager interface {
		VerifyToken(ctx context.Context, req *http.Request) (any, error)
		UserIDFromCtx(ctx context.Context) user.ID
		SetCookie(res connect.AnyResponse, token string)
		RefreshCookie(ctx context.Context, res connect.AnyResponse)
	}

	manager struct {
		conf Config
		repo port.UserRepository
	}

	session struct {
		UserID user.ID
		Token  string
	}
)

func NewManager(conf Config, repo port.UserRepository) Manager {
	return &manager{
		conf: conf,
		repo: repo,
	}
}

func (m *manager) VerifyToken(ctx context.Context, req *http.Request) (any, error) {
	if noAuthProcedures[req.URL.Path] {
		return nil, nil
	}

	cookie, err := req.Cookie(CookieKey)
	if err != nil {
		return nil, authn.Errorf("unable to authenticate")
	}

	token := cookie.Value
	userID, err := m.repo.GetIDByAccessToken(ctx, token)
	if err != nil {
		return nil, authn.Errorf("unable to authenticate")
	}

	if err := m.repo.ResetLifetime(ctx, userID); err != nil {
		return nil, merror.WrapInternal(err, "error: failed to reset lifetime")
	}

	return session{
		UserID: userID,
		Token:  token,
	}, nil
}

func (m *manager) UserIDFromCtx(ctx context.Context) user.ID {
	info := authn.GetInfo(ctx)
	ssn, ok := info.(session)
	if !ok {
		return ""
	}

	return ssn.UserID
}

func (m *manager) SetCookie(res connect.AnyResponse, token string) {
	cookie := &http.Cookie{
		Name:     CookieKey,
		Value:    token,
		Path:     "/",
		Domain:   m.conf.CookieDomain,
		MaxAge:   user.SessionLifetimeMinutes * 60, // 1 hour
		Secure:   m.conf.CookieSecure,
		HttpOnly: false,
		SameSite: http.SameSiteLaxMode,
	}
	res.Header().Set("Set-Cookie", cookie.String())
}

func (m *manager) RefreshCookie(ctx context.Context, res connect.AnyResponse) {
	info := authn.GetInfo(ctx)
	ssn, ok := info.(session)
	if !ok {
		return
	}

	m.SetCookie(res, ssn.Token)
}
