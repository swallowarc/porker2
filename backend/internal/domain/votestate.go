package domain

type (
	VoteState int
)

const (
	VoteStateUnspecified VoteState = 0
	VoteStateHide        VoteState = 1
	VoteStateOpen        VoteState = 2
)

func (s VoteState) Votable() bool {
	return s == VoteStateHide
}
