package session

type (
	Config struct {
		CookieDomain string `envconfig:"cookie_domain" default:"localhost"`
		CookieSecure bool   `envconfig:"cookie_secure" default:"false"`
	}
)
