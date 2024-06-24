package repository

import (
	"encoding/json"

	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

type (
	userModel struct {
		ID     user.ID      `json:"id"`
		Name   user.Name    `json:"name"`
		Token  string       `json:"token"`
		RoomID poker.RoomID `json:"room_id,omitempty"`
	}
)

func newUser(name user.Name) *userModel {
	return &userModel{
		ID:    user.NewID(),
		Name:  name,
		Token: user.NewToken(),
	}
}

func (m *userModel) jsonMarshalUserInfo() (string, error) {
	j, err := json.Marshal(m)
	return string(j), err
}
