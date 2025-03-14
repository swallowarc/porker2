package user

import (
	"time"

	"github.com/google/uuid"
)

const (
	SessionLifetime = 60 * time.Minute
)

type ID string

func NewID() ID {
	return ID(uuid.New().String())
}

func (s ID) String() string {
	return string(s)
}

func (s ID) Valid() bool {
	_, err := uuid.Parse(string(s))
	return err == nil
}
