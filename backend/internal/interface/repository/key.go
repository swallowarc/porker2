package repository

import (
	"fmt"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

const (
	keyFormatToken = "porker2_token:%s"
)

type (
	tokenKey string
)

func newTokenKey(token string) tokenKey {
	return tokenKey(token)
}

func (tk tokenKey) token() string {
	return fmt.Sprintf(keyFormatToken, tk)
}

const (
	keyFormatUserName = "porker2_user_name:%s"
)

type (
	userKey user.ID
)

func newUserKey(id user.ID) userKey {
	return userKey(id)
}

func (id userKey) name() string {
	return fmt.Sprintf(keyFormatUserName, id)
}

const (
	keyFormatRoomMembers   = "porker2_room_members:%s"
	keyFormatRoomCondition = "porker2_room_condition:%s"
	keyFormatRoomLock      = "porker2_room_Lock:%s"
)

type (
	roomKey poker.RoomID
)

func newRoomKey(id poker.RoomID) roomKey {
	return roomKey(id)
}

func (id roomKey) members() string {
	return fmt.Sprintf(keyFormatRoomMembers, id)
}

func (id roomKey) condition() string {
	return fmt.Sprintf(keyFormatRoomCondition, id)
}

func (id roomKey) lock() string {
	return fmt.Sprintf(keyFormatRoomLock, id)
}
