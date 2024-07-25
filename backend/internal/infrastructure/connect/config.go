package connect

type (
	Config struct {
		Host string `envconfig:"host"`
		Port int    `envconfig:"port" default:"8080"`

		ReadTimeoutSec  int `envconfig:"read_timeout_sec" default:"30"`
		WriteTimeoutSec int `envconfig:"write_timeout_sec" default:"30"`
		IdleTimeoutSec  int `envconfig:"idle_timeout_sec" default:"900"`

		CORSAllowAll bool `envconfig:"cors_allow_all" default:"true"`
	}
)
