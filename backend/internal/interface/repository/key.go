package repository

import (
	"fmt"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

/*
	UserRepository keys
*/

const (
	keyFormatUserToken = "porker2_token:%s"
	keyFormatUserID    = "porker2_user_id:%s"
	keyFormatUserName  = "porker2_user_name:%s"
)

func userTokenKey(tk string) string {
	return fmt.Sprintf(keyFormatUserToken, tk)
}

func userIDKey(id user.ID) string {
	return fmt.Sprintf(keyFormatUserID, id)
}

func userNameKey(name user.Name) string {
	return fmt.Sprintf(keyFormatUserName, name)
}

/*
	PokerRepository keys
*/

const (
	keyFormatRoomCondition = "porker2_room_condition:%s"
	keyFormatRoomLock      = "porker2_room_Lock:%s"
)

func roomConditionKey(id poker.RoomID) string {
	return fmt.Sprintf(keyFormatRoomCondition, id)
}

func roomLockKey(id poker.RoomID) string {
	return fmt.Sprintf(keyFormatRoomLock, id)
}
