package session

import (
	"context"
	"net/http"

	"connectrpc.com/authn"
	"connectrpc.com/connect/v2"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/interface/rpcerr"
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
		SetCookie(ctx context.Context, token string)
		RefreshCookie(ctx context.Context)
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
		if merror.IsNotFound(err) {
			// token は残っているが user データが消えている (TTL のずれ等)。認証失敗として扱う。
			return nil, authn.Errorf("unable to authenticate")
		}
		// authn ミドルウェアは interceptor の外側なので、ここで明示的に connect エラーへ変換する
		return nil, rpcerr.ToConnect(merror.WrapInternal(err, "failed to reset lifetime"))
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

func (m *manager) SetCookie(ctx context.Context, token string) {
	info, ok := connect.CallInfoForServerContext(ctx)
	if !ok {
		// 本番経路では必ず call info が載る。載っていない場合は Cookie を発行できないので痕跡を残す。
		logger.FromCtx(ctx).Warn("call info not found in context; skip setting session cookie")
		return
	}

	cookie := &http.Cookie{
		Name:     CookieKey,
		Value:    token,
		Path:     "/",
		Domain:   m.conf.CookieDomain,
		MaxAge:   user.SessionLifetimeMinutes * 60,
		Secure:   m.conf.CookieSecure,
		HttpOnly: true, // フロントエンドは cookie を直接読まない (ブラウザが自動送信する) ので JS から隔離する
		SameSite: http.SameSiteLaxMode,
	}
	info.ResponseHeader().Set("Set-Cookie", cookie.String())
}

func (m *manager) RefreshCookie(ctx context.Context) {
	info := authn.GetInfo(ctx)
	ssn, ok := info.(session)
	if !ok {
		return
	}

	m.SetCookie(ctx, ssn.Token)
}
