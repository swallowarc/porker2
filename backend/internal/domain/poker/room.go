package poker

import (
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

// Room は部屋の状態を表す集約。
// 状態の変更はメソッド経由に限定され、不変条件 (開票後は投票不可、満員時は参加不可、
// 管理者は参加者の中から選ばれる、等) はこの型の中で守られる。
type Room struct {
	roomID      RoomID
	adminUserID user.ID
	voteState   VoteState
	ballots     []*Ballot
	autoOpen    bool
	displayMode DisplayMode
}

func NewRoom() *Room {
	return &Room{
		roomID:      newRoomID(),
		adminUserID: "",
		voteState:   VoteStateHide,
		ballots:     []*Ballot{},
		autoOpen:    true,
		displayMode: DisplayModePoint,
	}
}

func (c *Room) RoomID() RoomID           { return c.roomID }
func (c *Room) AdminUserID() user.ID     { return c.adminUserID }
func (c *Room) VoteState() VoteState     { return c.voteState }
func (c *Room) AutoOpen() bool           { return c.autoOpen }
func (c *Room) DisplayMode() DisplayMode { return c.displayMode }

// Ballots は投票の一覧をコピーで返す。返り値を変更しても部屋の状態には影響しない。
func (c *Room) Ballots() []Ballot {
	ballots := make([]Ballot, 0, len(c.ballots))
	for _, b := range c.ballots {
		ballots = append(ballots, *b)
	}
	return ballots
}

func (c *Room) IsAdmin(userID user.ID) bool {
	return c.adminUserID == userID
}

func (c *Room) CanVote() bool {
	return c.voteState == VoteStateHide
}

func (c *Room) CanShow() bool {
	return c.voteState == VoteStateHide
}

func (c *Room) CanJoin() bool {
	return len(c.ballots) < MaxMember
}

func (c *Room) IsUserIn(userID user.ID) bool {
	return c.find(userID) != nil
}

// ObserverCount は観戦者数を ballots から導出する。
// フィールドとして保持すると Leave / Kick 時の減算漏れで実態とずれるため、常に計算で求める。
func (c *Room) ObserverCount() int32 {
	var n int32
	for _, b := range c.ballots {
		if b.IsObserver() {
			n++
		}
	}
	return n
}

func (c *Room) Join(userID user.ID, userName user.Name) error {
	if !c.CanJoin() {
		return ErrRoomFull
	}

	if c.IsUserIn(userID) {
		// if user is already in the room, do nothing
		return nil
	}

	c.ballots = append(c.ballots, newBallot(userID, userName))
	if c.adminUserID.IsZero() {
		c.adminUserID = userID
	}

	return nil
}

func (c *Room) Vote(userID user.ID, point Point) {
	if !c.CanVote() {
		return
	}

	if b := c.find(userID); b != nil && !b.IsObserver() {
		b.point = point
	}

	c.tally()
}

func (c *Room) Leave(userID user.ID) {
	for i, b := range c.ballots {
		if b.userID == userID {
			c.ballots = append(c.ballots[:i], c.ballots[i+1:]...)
			break
		}
	}

	if c.adminUserID == userID {
		c.adminUserID = ""
		if len(c.ballots) > 0 {
			c.adminUserID = c.ballots[0].userID
		}
	}

	c.tally()
}

func (c *Room) Open() {
	if !c.CanShow() {
		return
	}

	c.voteState = VoteStateOpen
}

func (c *Room) Reset() {
	c.voteState = VoteStateHide
	for _, b := range c.ballots {
		b.reset()
	}
}

// Kick は管理者が対象ユーザーを退室させる。
// 退室処理(管理者の引き継ぎを含む)は Leave と同一でなければならないため Leave に委譲する。
func (c *Room) Kick(userID, targetID user.ID) error {
	if !c.IsAdmin(userID) {
		return ErrNotAdmin
	}

	c.Leave(targetID)

	return nil
}

func (c *Room) UpdateSetting(autoOpen bool, displayMode DisplayMode) {
	c.autoOpen = autoOpen
	c.displayMode = displayMode
	c.tally()
}

func (c *Room) ToggleObserverMode(userID user.ID, isObserver bool) {
	if b := c.find(userID); b != nil {
		b.setObserverMode(isObserver)
		c.tally()
	}
}

func (c *Room) find(userID user.ID) *Ballot {
	for _, b := range c.ballots {
		if b.userID == userID {
			return b
		}
	}
	return nil
}

func (c *Room) tally() {
	if !c.autoOpen || c.voteState == VoteStateOpen {
		return
	}

	voterCount := 0
	unvotedCount := 0
	for _, b := range c.ballots {
		if !b.IsObserver() {
			voterCount++
			if b.point.IsUnspecified() {
				unvotedCount++
			}
		}
	}

	if voterCount > 0 && unvotedCount == 0 {
		c.voteState = VoteStateOpen
	}
}
