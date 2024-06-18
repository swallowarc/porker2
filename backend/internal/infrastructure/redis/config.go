package redis

// Config is
// Redis settings.
type Config struct {
	HostPort string `envconfig:"host_port" default:"localhost:6379"`
	Password string `envconfig:"password" default:"password"`
	DB       int    `envconfig:"db" default:"0"`
}
