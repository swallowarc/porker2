package poker

import "github.com/swallowarc/porker2/backend/internal/core/merror"

// VoteState は部屋の開票状態。
type VoteState int32

const (
	VoteStateUnspecified VoteState = 0
	VoteStateHide        VoteState = 1
	VoteStateOpen        VoteState = 2
)

// NewVoteState は永続化された値などから VoteState を復元する。Unspecified は許容しない。
func NewVoteState(raw int32) (VoteState, error) {
	s := VoteState(raw)
	if s != VoteStateHide && s != VoteStateOpen {
		return VoteStateUnspecified, merror.NewInvalidArgument(nil, "vote state must be hide(%d) or open(%d): %d", VoteStateHide, VoteStateOpen, raw)
	}
	return s, nil
}

func (s VoteState) Int32() int32 { return int32(s) }
