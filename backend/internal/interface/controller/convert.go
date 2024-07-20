package controller

import (
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
)

func userIDFromProto(p string) user.ID {
	// It is assumed that it has been validated.
	return user.ID(p)
}

func pointFromProto(p pb.Point) poker.Point {
	// No branching by switch-case because of validation after conversion.
	return poker.Point(p)
}

func pointToProto(p poker.Point) pb.Point {
	switch p {
	case poker.Point0:
		return pb.Point_POINT_0
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

func ballotToProto(b *poker.Ballot) *pb.Ballot {
	return &pb.Ballot{
		UserId: b.UserID.String(),
		Point:  pointToProto(b.Point),
	}
}

func ballotsToProto(b []*poker.Ballot) []*pb.Ballot {
	ballots := make([]*pb.Ballot, 0, len(b))
	for _, ballot := range b {
		ballots = append(ballots, ballotToProto(ballot))
	}
	return ballots
}

func roomIDFromProto(p string) poker.RoomID {
	return poker.RoomID(p)
}

func roomConditionToProto(rc *poker.RoomCondition) *pb.RoomCondition {
	return &pb.RoomCondition{
		RoomId:      rc.RoomID.String(),
		AdminUserId: rc.AdminUserID.String(),
		VoteState:   pb.VoteState(rc.VoteState),
		Ballots:     ballotsToProto(rc.Ballots),
	}
}
