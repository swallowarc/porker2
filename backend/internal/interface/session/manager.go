package session

import (
	"context"
	"net/http"

	"connectrpc.com/authn"

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
		CreateCookieString(token string) string
	}

	manager struct {
		conf Config
		repo port.UserRepository
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

	userID, err := m.repo.GetIDByAccessToken(ctx, cookie.Value)
	if err != nil {
		return nil, authn.Errorf("unable to authenticate")
	}

	if err := m.repo.ResetLifetime(ctx, userID); err != nil {
		return nil, merror.WrapInternal(err, "error: failed to reset lifetime")
	}

	return userID, nil
}

func (m *manager) UserIDFromCtx(ctx context.Context) user.ID {
	id := authn.GetInfo(ctx)
	userID, ok := id.(user.ID)
	if !ok {
		return ""
	}

	return userID
}

func (m *manager) CreateCookieString(token string) string {
	cookie := &http.Cookie{
		Name:     CookieKey,
		Value:    token,
		Path:     "/",
		Domain:   m.conf.CookieDomain,
		MaxAge:   60 * 60, // 1 hour
		Secure:   m.conf.CookieSecure,
		HttpOnly: false,
		SameSite: http.SameSiteLaxMode,
	}
	return cookie.String()
}
