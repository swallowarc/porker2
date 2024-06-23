package poker

import (
	"time"

	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

const (
	MaxMember = 15
	// RoomLifetime 最後に部屋がアクセスされた時刻から部屋が削除されるまでの時間
	RoomLifetime = 15 * time.Minute
)

type (
	RoomCondition struct {
		RoomID      RoomID
		AdminUserID user.ID
		VoteState   VoteState
		Ballots     []*Ballot
	}
)

func (rc *RoomCondition) IsAdmin(userID user.ID) bool {
	return rc.AdminUserID == userID
}

func (rc *RoomCondition) CanVote() bool {
	return rc.VoteState == VoteStateHide
}

func (rc *RoomCondition) CanShow() bool {
	return rc.VoteState == VoteStateHide
}

func (rc *RoomCondition) CanJoin() bool {
	return len(rc.Ballots) < MaxMember
}
