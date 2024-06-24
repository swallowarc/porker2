package user

import (
	"context"
	"time"

	"github.com/google/uuid"
)

const (
	SessionLifetime = 60 * time.Minute
)

type ID string

var contextKey struct{}

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

func SetContext(ctx context.Context, id ID) context.Context {
	return context.WithValue(ctx, contextKey, id)
}

func FromContext(ctx context.Context) ID {
	// Since the value is guaranteed to be set in the context by the interceptor, the check is unnecessary.
	id, _ := ctx.Value(contextKey).(ID)
	return id
}
