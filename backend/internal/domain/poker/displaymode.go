package poker

import "github.com/swallowarc/porker2/backend/internal/core/merror"

// DisplayMode はポイントの表示方式。
type DisplayMode int32

const (
	DisplayModeUnspecified DisplayMode = 0
	DisplayModePoint       DisplayMode = 1
	DisplayModeTShirt      DisplayMode = 2
)

// NewDisplayMode は外部入力から DisplayMode を生成する。Unspecified は許容しない。
func NewDisplayMode(raw int32) (DisplayMode, error) {
	m := DisplayMode(raw)
	if m != DisplayModePoint && m != DisplayModeTShirt {
		return DisplayModeUnspecified, merror.NewInvalidArgument(nil, "display mode must be point(%d) or tshirt(%d): %d", DisplayModePoint, DisplayModeTShirt, raw)
	}
	return m, nil
}

func (m DisplayMode) Int32() int32 { return int32(m) }
