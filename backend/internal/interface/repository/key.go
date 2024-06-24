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
	keyFormatToken      = "porker2_token:%s"
	keyFormatUserIDName = "porker2_user_id_name:%s"
	keyFormatUserNameID = "porker2_user_name_id:%s"
)

func tokenKey(tk string) string {
	return fmt.Sprintf(keyFormatToken, tk)
}

func idNameKey(id user.ID) string {
	return fmt.Sprintf(keyFormatUserIDName, id)
}

func nameIDKey(name user.Name) string {
	return fmt.Sprintf(keyFormatUserNameID, name)
}

/*
	PokerRepository keys
*/

const (
	keyFormatUserJoinRoom  = "porker2_user_join:%s"
	keyFormatRoomCondition = "porker2_room_condition:%s"
	keyFormatRoomLock      = "porker2_room_Lock:%s"
)

func userJoinRoomKey(id user.ID) string {
	return fmt.Sprintf(keyFormatUserJoinRoom, id)
}

func roomConditionKey(id poker.RoomID) string {
	return fmt.Sprintf(keyFormatRoomCondition, id)
}

func roomLockKey(id poker.RoomID) string {
	return fmt.Sprintf(keyFormatRoomLock, id)
}
