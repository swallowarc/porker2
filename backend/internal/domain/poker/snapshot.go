package poker

import (
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

// RoomSnapshot は Room をプリミティブ値に写した永続化用の表現。
// ストレージの形式 (JSON 等) は repository が決め、ドメインはこの構造体までしか知らない。
type RoomSnapshot struct {
	RoomID      string
	AdminUserID string // 部屋が空のときは ""
	VoteState   int32
	Ballots     []BallotSnapshot
	AutoOpen    bool
	DisplayMode int32
}

type BallotSnapshot struct {
	UserID   string
	UserName string
	Point    int32
	Role     int32
}

func (c *Room) Snapshot() RoomSnapshot {
	ballots := make([]BallotSnapshot, 0, len(c.ballots))
	for _, b := range c.ballots {
		ballots = append(ballots, BallotSnapshot{
			UserID:   b.userID.String(),
			UserName: b.userName.String(),
			Point:    b.point.Int32(),
			Role:     b.role.Int32(),
		})
	}

	return RoomSnapshot{
		RoomID:      c.roomID.String(),
		AdminUserID: c.adminUserID.String(),
		VoteState:   c.voteState.Int32(),
		Ballots:     ballots,
		AutoOpen:    c.autoOpen,
		DisplayMode: c.displayMode.Int32(),
	}
}

// RestoreRoom は Snapshot から Room を復元する。
// 各値は VO のコンストラクタを通るため、ストレージ上の壊れたデータはここで Internal として検出される。
func RestoreRoom(s RoomSnapshot) (*Room, error) {
	roomID, err := NewRoomID(s.RoomID)
	if err != nil {
		return nil, corrupted(err)
	}

	adminUserID := user.ID("")
	if s.AdminUserID != "" {
		if adminUserID, err = user.ParseID(s.AdminUserID); err != nil {
			return nil, corrupted(err)
		}
	}

	voteState, err := NewVoteState(s.VoteState)
	if err != nil {
		return nil, corrupted(err)
	}

	displayMode, err := NewDisplayMode(s.DisplayMode)
	if err != nil {
		return nil, corrupted(err)
	}

	ballots := make([]*Ballot, 0, len(s.Ballots))
	for _, bs := range s.Ballots {
		b, err := restoreBallot(bs)
		if err != nil {
			return nil, err
		}
		ballots = append(ballots, b)
	}

	return &Room{
		roomID:      roomID,
		adminUserID: adminUserID,
		voteState:   voteState,
		ballots:     ballots,
		autoOpen:    s.AutoOpen,
		displayMode: displayMode,
	}, nil
}

func restoreBallot(s BallotSnapshot) (*Ballot, error) {
	userID, err := user.ParseID(s.UserID)
	if err != nil {
		return nil, corrupted(err)
	}
	userName, err := user.NewName(s.UserName)
	if err != nil {
		return nil, corrupted(err)
	}
	point, err := NewPoint(s.Point)
	if err != nil {
		return nil, corrupted(err)
	}
	role, err := NewUserRole(s.Role)
	if err != nil {
		return nil, corrupted(err)
	}

	return &Ballot{
		userID:   userID,
		userName: userName,
		point:    point,
		role:     role,
	}, nil
}

func corrupted(err error) error {
	return merror.WrapInternal(err, "corrupted room condition")
}
