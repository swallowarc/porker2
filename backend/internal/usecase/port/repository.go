//go:generate mockgen -source=$GOFILE -destination=../../test/mock/$GOPACKAGE/mock_$GOFILE -package=mock_$GOPACKAGE
package port

type (
	UserRepository interface {
	}

	PokerRepository interface {
	}
)
