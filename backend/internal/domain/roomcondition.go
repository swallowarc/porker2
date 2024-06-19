package domain

import "time"

const (
	// RoomLifetime 最後に部屋がアクセスされた時刻から部屋が削除されるまでの時間
	RoomLifetime = 15 * time.Minute
)

type (
	RoomCondition struct {
		RoomID      RoomID
		AdminUserID string
		VoteState   VoteState
		Ballots     []*Ballot
	}
)
