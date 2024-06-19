package random

import (
	"regexp"
	"testing"
)

func TestRandString6(t *testing.T) {
	actual := RandString6(6)
	if len(actual) != 6 {
		t.Errorf("expected %d, actual %d", 6, len(actual))
	}
	if !regexp.MustCompile(`^[a-zA-Z0-9]*$`).MatchString(actual) {
		t.Errorf("英数字以外の文字が混在")
	}
}
