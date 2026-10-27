package poker

type (
	DisplayMode int
)

const (
	DisplayModeUnspecified DisplayMode = 0
	DisplayModePoint       DisplayMode = 1
	DisplayModeTShirt      DisplayMode = 2
)

func (m DisplayMode) Valid() bool {
	return m == DisplayModePoint || m == DisplayModeTShirt
}
