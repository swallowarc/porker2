package poker

import (
	"encoding/json"
	"time"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

const (
	MaxMember = 15
	// RoomLifetimeDuration 最後に部屋がアクセスされた時刻から部屋が削除されるまでの時間
	RoomLifetimeDuration = 180 * time.Minute
)

var (
	ErrNotAdmin = merror.NewPermissionDenied("user is not admin")
	ErrRoomFull = merror.NewFailedPrecondition("room is full")
)

type (
	RoomCondition struct {
		RoomID      RoomID      `json:"room_id"`
		AdminUserID user.ID     `json:"admin_user_id"`
		VoteState   VoteState   `json:"vote_state"`
		Ballots     []*Ballot   `json:"ballots"`
		AutoOpen    bool        `json:"auto_open"`
		DisplayMode DisplayMode `json:"display_mode"`
	}
)

func NewRoomCondition() *RoomCondition {
	return &RoomCondition{
		RoomID:      newRoomID(),
		AdminUserID: "",
		VoteState:   VoteStateHide,
		Ballots:     []*Ballot{},
		AutoOpen:    true,
		DisplayMode: DisplayModePoint,
	}
}

func (c *RoomCondition) IsAdmin(userID user.ID) bool {
	return c.AdminUserID == userID
}

func (c *RoomCondition) CanVote() bool {
	return c.VoteState == VoteStateHide
}

func (c *RoomCondition) CanShow() bool {
	return c.VoteState == VoteStateHide
}

func (c *RoomCondition) CanJoin() bool {
	return len(c.Ballots) < MaxMember
}

func (c *RoomCondition) IsUserIn(userID user.ID) bool {
	for _, b := range c.Ballots {
		if b.UserID == userID {
			return true
		}
	}

	return false
}

// ObserverCount は観戦者数を Ballots から導出する。
// フィールドとして保持すると Leave / Kick 時の減算漏れで実態とずれるため、常に計算で求める。
func (c *RoomCondition) ObserverCount() int32 {
	var n int32
	for _, b := range c.Ballots {
		if b.IsObserver() {
			n++
		}
	}

	return n
}

func (c *RoomCondition) Join(userID user.ID, userName user.Name) error {
	if !c.CanJoin() {
		return ErrRoomFull
	}

	if c.IsUserIn(userID) {
		// if user is already in the room, do nothing
		return nil
	}

	c.Ballots = append(c.Ballots, newBallot(userID, userName))
	if c.AdminUserID == "" {
		c.AdminUserID = userID
	}

	return nil
}

func (c *RoomCondition) Vote(userID user.ID, point Point) {
	if !c.CanVote() {
		return
	}

	for _, b := range c.Ballots {
		if b.UserID == userID {
			if b.IsObserver() {
				return
			}
			b.Point = point
			break
		}
	}

	c.tally()
}

func (c *RoomCondition) Leave(userID user.ID) {
	for i, b := range c.Ballots {
		if b.UserID == userID {
			c.Ballots = append(c.Ballots[:i], c.Ballots[i+1:]...)
			break
		}
	}

	if c.AdminUserID == userID {
		c.AdminUserID = ""
		if len(c.Ballots) > 0 {
			c.AdminUserID = c.Ballots[0].UserID
		}
	}

	c.tally()
}

func (c *RoomCondition) Open() {
	if !c.CanShow() {
		return
	}

	c.VoteState = VoteStateOpen
}

func (c *RoomCondition) Reset() {
	c.VoteState = VoteStateHide
	for _, b := range c.Ballots {
		b.Reset()
	}
}

// Kick は管理者が対象ユーザーを退室させる。
// 退室処理(管理者の引き継ぎを含む)は Leave と同一でなければならないため Leave に委譲する。
func (c *RoomCondition) Kick(userID, targetID user.ID) error {
	if !c.IsAdmin(userID) {
		return ErrNotAdmin
	}

	c.Leave(targetID)

	return nil
}

func (c *RoomCondition) UpdateSetting(autoOpen bool, displayMode DisplayMode) {
	c.AutoOpen = autoOpen
	c.DisplayMode = displayMode
	c.tally()
}

func (c *RoomCondition) ToggleObserverMode(userID user.ID, isObserver bool) {
	for _, b := range c.Ballots {
		if b.UserID == userID {
			b.SetObserverMode(isObserver)
			c.tally()
			break
		}
	}
}

func (c *RoomCondition) tally() {
	if !c.AutoOpen || c.VoteState == VoteStateOpen {
		return
	}

	voterCount := 0
	unvotedCount := 0
	for _, b := range c.Ballots {
		if !b.IsObserver() {
			voterCount++
			if b.Point == PointUnspecified {
				unvotedCount++
			}
		}
	}

	if voterCount > 0 && unvotedCount == 0 {
		c.VoteState = VoteStateOpen
	}
}

func (c *RoomCondition) ToJson() ([]byte, error) {
	j, err := json.Marshal(c)
	if err != nil {
		return nil, merror.WrapInternal(err, "failed to marshal room condition")
	}

	return j, nil
}

func FromJson(j string) (*RoomCondition, error) {
	var c RoomCondition
	if err := json.Unmarshal([]byte(j), &c); err != nil {
		return nil, merror.WrapInternal(err, "failed to unmarshal room condition")
	}

	return &c, nil
}
