package repository

import (
	"fmt"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

/*
	User keys
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
	return fmt.Sprintf(keyFormatUserID, id.String())
}

func userNameKey(name user.Name) string {
	return userNameKeyRaw(name.String())
}

// userNameKeyRaw は永続化モデル上の生の名前からキーを作る (削除・延命時はドメイン型への復元を要しない)。
func userNameKeyRaw(name string) string {
	return fmt.Sprintf(keyFormatUserName, name)
}

/*
	Poker keys
*/

const (
	keyFormatRoomCondition  = "porker2_room_condition:%s"
	keyRoomConditionMessage = "porker2_room_condition_message"
	keyFormatRoomLock       = "porker2_room_Lock:%s"
)

func roomKey(id poker.RoomID) string {
	return fmt.Sprintf(keyFormatRoomCondition, id.String())
}

func roomLockKey(id poker.RoomID) string {
	return fmt.Sprintf(keyFormatRoomLock, id.String())
}
