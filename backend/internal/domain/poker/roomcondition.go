package poker

import (
	"encoding/json"
	"time"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

const (
	MaxMember = 15
	// RoomLifetime 最後に部屋がアクセスされた時刻から部屋が削除されるまでの時間
	RoomLifetime = 60 * time.Minute
)

var (
	ErrNotAdmin = merror.NewPermissionDenied("user is not admin")
	ErrRoomFull = merror.NewFailedPrecondition("", "room is full")
)

type (
	RoomCondition struct {
		RoomID      RoomID    `json:"room_id"`
		AdminUserID user.ID   `json:"admin_user_id"`
		VoteState   VoteState `json:"vote_state"`
		Ballots     []*Ballot `json:"ballots"`
		AutoOpen    bool      `json:"auto_open"`
	}
)

func NewRoomCondition() *RoomCondition {
	return &RoomCondition{
		RoomID:      newRoomID(),
		AdminUserID: "",
		VoteState:   VoteStateHide,
		Ballots:     []*Ballot{},
		AutoOpen:    true,
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

func (c *RoomCondition) Kick(userID, targetID user.ID) error {
	if c.AdminUserID != userID {
		return ErrNotAdmin
	}

	for i, b := range c.Ballots {
		if b.UserID == targetID {
			c.Ballots = append(c.Ballots[:i], c.Ballots[i+1:]...)
			break
		}
	}

	c.tally()

	return nil
}

func (c *RoomCondition) UpdateSetting(autoOpen bool) {
	c.AutoOpen = autoOpen
	c.tally()
}

func (c *RoomCondition) tally() {
	if !c.AutoOpen {
		return
	}

	memberCount := len(c.Ballots)
	for _, b := range c.Ballots {
		if b.Point != PointUnspecified {
			memberCount--
		}
	}

	if memberCount == 0 {
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
