package logger

import (
	"context"
	"log/slog"
	"os"

	"github.com/swallowarc/porker2/backend/internal/core/environment"
)

var (
	contextKey = struct{}{}
)

func NewLogger(e environment.Type) *slog.Logger {
	if e.IsLocal() {
		handler := slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
			AddSource: true,
			Level:     slog.LevelDebug,
		})
		return slog.New(handler)
	}

	handler := slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelInfo,
	})
	return slog.New(handler)
}

func SetLogger(ctx context.Context, l *slog.Logger) context.Context {
	return context.WithValue(ctx, contextKey, l)
}

func FromCtx(ctx context.Context) *slog.Logger {
	l, ok := ctx.Value(contextKey).(*slog.Logger)
	if !ok {
		return slog.Default()
	}

	return l
}
