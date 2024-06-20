package environment

type (
	Type string
)

const (
	Local Type = "local"
	Dev   Type = "dev"
	Prod  Type = "prod"
)

func (t Type) IsLocal() bool {
	return t == Local
}
