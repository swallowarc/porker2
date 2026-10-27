package repository

import (
	"encoding/json"

	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
)

// このファイルの型は Redis に保存する JSON の形を定義する永続化モデル。
// ドメイン型とは Snapshot / コンストラクタを介して相互変換し、ドメインは JSON を知らない。

type (
	userModel struct {
		ID     string `json:"id"`
		Name   string `json:"name"`
		Token  string `json:"token"`
		RoomID string `json:"room_id,omitempty"` // 未参加なら ""
	}

	roomModel struct {
		RoomID      string        `json:"room_id"`
		AdminUserID string        `json:"admin_user_id"`
		VoteState   int32         `json:"vote_state"`
		Ballots     []ballotModel `json:"ballots"`
		AutoOpen    bool          `json:"auto_open"`
		DisplayMode int32         `json:"display_mode"`
	}

	ballotModel struct {
		UserID   string `json:"user_id"`
		UserName string `json:"user_name"`
		Point    int32  `json:"point"`
		Role     int32  `json:"role"`
	}
)

func encodeUser(m *userModel) (string, error) {
	j, err := json.Marshal(m)
	if err != nil {
		return "", merror.WrapInternal(err, "failed to marshal user")
	}
	return string(j), nil
}

func decodeUser(j string) (*userModel, error) {
	var m userModel
	if err := json.Unmarshal([]byte(j), &m); err != nil {
		return nil, merror.WrapInternal(err, "failed to unmarshal user")
	}
	return &m, nil
}

// toDomain は永続化モデルをドメイン型に復元する。壊れたデータは Internal。
func (m *userModel) toDomain() (user.Name, poker.RoomID, error) {
	name, err := user.NewName(m.Name)
	if err != nil {
		return user.Name{}, poker.RoomID{}, merror.WrapInternal(err, "corrupted user")
	}

	roomID := poker.RoomID{}
	if m.RoomID != "" {
		if roomID, err = poker.NewRoomID(m.RoomID); err != nil {
			return user.Name{}, poker.RoomID{}, merror.WrapInternal(err, "corrupted user")
		}
	}

	return name, roomID, nil
}

func encodeRoom(room *poker.Room) (string, error) {
	s := room.Snapshot()
	ballots := make([]ballotModel, 0, len(s.Ballots))
	for _, b := range s.Ballots {
		ballots = append(ballots, ballotModel{
			UserID:   b.UserID,
			UserName: b.UserName,
			Point:    b.Point,
			Role:     b.Role,
		})
	}

	j, err := json.Marshal(roomModel{
		RoomID:      s.RoomID,
		AdminUserID: s.AdminUserID,
		VoteState:   s.VoteState,
		Ballots:     ballots,
		AutoOpen:    s.AutoOpen,
		DisplayMode: s.DisplayMode,
	})
	if err != nil {
		return "", merror.WrapInternal(err, "failed to marshal room")
	}

	return string(j), nil
}

func decodeRoom(j string) (*poker.Room, error) {
	var m roomModel
	if err := json.Unmarshal([]byte(j), &m); err != nil {
		return nil, merror.WrapInternal(err, "failed to unmarshal room")
	}

	ballots := make([]poker.BallotSnapshot, 0, len(m.Ballots))
	for _, b := range m.Ballots {
		ballots = append(ballots, poker.BallotSnapshot{
			UserID:   b.UserID,
			UserName: b.UserName,
			Point:    b.Point,
			Role:     b.Role,
		})
	}

	return poker.RestoreRoom(poker.RoomSnapshot{
		RoomID:      m.RoomID,
		AdminUserID: m.AdminUserID,
		VoteState:   m.VoteState,
		Ballots:     ballots,
		AutoOpen:    m.AutoOpen,
		DisplayMode: m.DisplayMode,
	})
}
