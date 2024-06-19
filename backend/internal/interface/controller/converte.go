package controller

import (
	"github.com/swallowarc/porker2/backend/internal/domain"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
)

func pointFromProto(p pb.Point) domain.Point {
	// No branching by switch-case because of validation after conversion.
	return domain.Point(p)
}

func pointToProto(p domain.Point) pb.Point {
	switch p {
	case domain.Point_POINT_0:
		return pb.Point_POINT_0
	case domain.Point_POINT_0_5:
		return pb.Point_POINT_0_5
	case domain.Point_POINT_1:
		return pb.Point_POINT_1
	case domain.Point_POINT_2:
		return pb.Point_POINT_2
	case domain.Point_POINT_3:
		return pb.Point_POINT_3
	case domain.Point_POINT_5:
		return pb.Point_POINT_5
	case domain.Point_POINT_8:
		return pb.Point_POINT_8
	case domain.Point_POINT_13:
		return pb.Point_POINT_13
	case domain.Point_POINT_21:
		return pb.Point_POINT_21
	case domain.Point_POINT_COFFEE:
		return pb.Point_POINT_COFFEE
	case domain.Point_POINT_QUESTION:
		return pb.Point_POINT_QUESTION
	default:
		return pb.Point_POINT_UNSPECIFIED
	}
}

func ballotFromProto(p *pb.Ballot) *domain.Ballot {
	return &domain.Ballot{
		UserID: p.UserId,
		Point:  pointFromProto(p.Point),
	}
}

func ballotToProto(b *domain.Ballot) *pb.Ballot {
	return &pb.Ballot{
		UserId: b.UserID,
		Point:  pointToProto(b.Point),
	}
}

func ballotsToProto(b []*domain.Ballot) []*pb.Ballot {
	ballots := make([]*pb.Ballot, 0, len(b))
	for _, ballot := range b {
		ballots = append(ballots, ballotToProto(ballot))
	}
	return ballots
}

func roomIDFromProto(p string) domain.RoomID {
	return domain.RoomID(p)
}

func roomConditionToProto(rc *domain.RoomCondition) *pb.RoomCondition {
	return &pb.RoomCondition{
		RoomId:      rc.RoomID.String(),
		AdminUserId: rc.AdminUserID,
		VoteState:   pb.VoteState(rc.VoteState),
		Ballots:     ballotsToProto(rc.Ballots),
	}
}
