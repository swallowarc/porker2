package connect

type (
	Config struct {
		Host string `envconfig:"host"`
		Port int    `envconfig:"port" default:"8080"`

		ReadTimeoutSec  int `envconfig:"read_timeout_sec" default:"30"`
		WriteTimeoutSec int `envconfig:"write_timeout_sec" default:"600"`
		IdleTimeoutSec  int `envconfig:"idle_timeout_sec" default:"900"`

		CORSAllowOrigins []string `envconfig:"cors_allow_origins" required:"true"` // e.g. ["http://localhost:3000", "http://localhost:8080"]
	}
)
