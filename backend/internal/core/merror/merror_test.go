package merror

import (
	"testing"

	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
)

func Test_CodeFromError(t *testing.T) {
	err := NewNotFound("test")
	if !IsNotFound(err) {
		t.Errorf("want CodeNotFound, got %v", CodeFromError(err))
	}
}

func Test_NewFailedPrecondition(t *testing.T) {
	err := NewFailedPrecondition("test", pb.Violation_VIOLATION_UNSPECIFIED.String())

	if !IsFailedPrecondition(err) {
		t.Errorf("want CodeFailedPrecondition, got %v", CodeFromError(err))
	}

	vt := ViolationTypeFromError(err)
	if vt != "VIOLATION_UNSPECIFIED" {
		t.Errorf("want testViolationType, got %v", vt)
	}
}

func Test_NewInvalidArgument(t *testing.T) {
	err := NewInvalidArgument("test", []FieldViolation{{"f1", "d1"}, {"f2", "d2"}}...)
	if !IsInvalidArgument(err) {
		t.Errorf("want CodeInvalidArgument, got %v", CodeFromError(err))
	}
}
