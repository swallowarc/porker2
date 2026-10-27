package controller

import (
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
)

// requestFields はリクエストの各フィールドをドメイン型へ変換し、違反をまとめて保持する。
// 事前条件の検証はドメインのコンストラクタが担い、ここでは proto のフィールド名を付けて束ねるだけ。
//
//	var f requestFields
//	roomID := f.roomID(r.Msg.RoomId)
//	point := f.point(r.Msg.Point)
//	if err := f.err(); err != nil { return nil, err }
type requestFields struct {
	violations merror.FieldViolations
}

func (f *requestFields) add(field string, err error) {
	if err == nil {
		return
	}
	f.violations = append(f.violations, merror.FieldViolation{Field: field, Description: err.Error()})
}

// err は 1 つ以上の違反があれば InvalidArgument を返す。
func (f *requestFields) err() error {
	if len(f.violations) == 0 {
		return nil
	}
	return merror.NewInvalidArgument(f.violations, "invalid argument")
}

func (f *requestFields) roomID(raw string) poker.RoomID {
	v, err := poker.NewRoomID(raw)
	f.add("room_id", err)
	return v
}

func (f *requestFields) userName(raw string) user.Name {
	v, err := user.NewName(raw)
	f.add("user_name", err)
	return v
}

func (f *requestFields) userID(field, raw string) user.ID {
	v, err := user.ParseID(raw)
	f.add(field, err)
	return v
}

func (f *requestFields) point(p pb.Point) poker.Point {
	v, err := poker.NewPoint(int32(p))
	f.add("point", err)
	return v
}

func (f *requestFields) displayMode(m pb.DisplayMode) poker.DisplayMode {
	v, err := poker.NewDisplayMode(int32(m))
	f.add("display_mode", err)
	return v
}

func pointToProto(p poker.Point) pb.Point {
	switch p {
	case poker.Point0:
		return pb.Point_POINT_0
	case poker.Point05:
		return pb.Point_POINT_0_5
	case poker.Point1:
		return pb.Point_POINT_1
	case poker.Point2:
		return pb.Point_POINT_2
	case poker.Point3:
		return pb.Point_POINT_3
	case poker.Point5:
		return pb.Point_POINT_5
	case poker.Point8:
		return pb.Point_POINT_8
	case poker.Point13:
		return pb.Point_POINT_13
	case poker.Point21:
		return pb.Point_POINT_21
	case poker.PointCoffee:
		return pb.Point_POINT_COFFEE
	case poker.PointQuestion:
		return pb.Point_POINT_QUESTION
	default:
		return pb.Point_POINT_UNSPECIFIED
	}
}

func userRoleToProto(r poker.UserRole) pb.UserRole {
	switch r {
	case poker.UserRoleVoter:
		return pb.UserRole_USER_ROLE_VOTER
	case poker.UserRoleObserver:
		return pb.UserRole_USER_ROLE_OBSERVER
	default:
		return pb.UserRole_USER_ROLE_UNSPECIFIED
	}
}

func ballotToProto(b *poker.Ballot) *pb.Ballot {
	return &pb.Ballot{
		UserId:   b.UserID.String(),
		UserName: b.UserName.String(),
		Point:    pointToProto(b.Point),
		Role:     userRoleToProto(b.Role),
	}
}

func ballotsToProto(b []*poker.Ballot) []*pb.Ballot {
	ballots := make([]*pb.Ballot, 0, len(b))
	for _, ballot := range b {
		ballots = append(ballots, ballotToProto(ballot))
	}
	return ballots
}

func roomToProto(rc *poker.Room) *pb.RoomCondition {
	return &pb.RoomCondition{
		RoomId:        rc.RoomID.String(),
		AdminUserId:   rc.AdminUserID.String(),
		VoteState:     pb.VoteState(rc.VoteState),
		Ballots:       ballotsToProto(rc.Ballots),
		AutoOpen:      rc.AutoOpen,
		DisplayMode:   pb.DisplayMode(rc.DisplayMode),
		ObserverCount: rc.ObserverCount(),
	}
}
