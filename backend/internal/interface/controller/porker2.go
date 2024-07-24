package controller

import (
	"context"
	"log/slog"

	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/domain/validator"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
	"github.com/swallowarc/porker2/backend/internal/usecase/interactor"
)

type (
	porker2 struct {
		v        validator.Validator
		userItr  interactor.User
		pokerItr interactor.Poker
	}
)

func NewPorker2Controller(
	v validator.Validator,
	userItr interactor.User,
	pokerItr interactor.Poker,
) pbconn.Porker2ServiceHandler {
	return &porker2{
		v:        v,
		userItr:  userItr,
		pokerItr: pokerItr,
	}
}

func (p *porker2) Login(ctx context.Context, r *connect.Request[pb.LoginRequest]) (*connect.Response[pb.LoginResponse], error) {
	if err := p.v.VarWithMessage(r.Msg.UserName, validator.TagUserName, "invalid argument"); err != nil {
		return nil, err
	}

	name := user.Name(r.Msg.UserName)
	id, token, err := p.userItr.Login(ctx, name)
	if err != nil {
		return nil, err
	}

	logger.FromCtx(ctx).Info("user login", slog.String(id.String(), name.String()))

	return &connect.Response[pb.LoginResponse]{
		Msg: &pb.LoginResponse{
			Token:  token, // TODO: cookieで返すようにしたい
			UserId: id.String(),
		},
	}, nil
}

func (p *porker2) Logout(ctx context.Context, _ *connect.Request[pb.LogoutRequest]) (*connect.Response[pb.LogoutResponse], error) {
	if err := p.userItr.Logout(ctx, user.FromContextID(ctx)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.LogoutResponse]{
		Msg: &pb.LogoutResponse{},
	}, nil
}

func (p *porker2) CreateRoom(ctx context.Context, _ *connect.Request[pb.CreateRoomRequest]) (*connect.Response[pb.CreateRoomResponse], error) {
	roomID, err := p.pokerItr.CreateRoom(ctx)
	if err != nil {
		return nil, err
	}

	return &connect.Response[pb.CreateRoomResponse]{
		Msg: &pb.CreateRoomResponse{
			RoomId: roomID.String(),
		},
	}, nil
}

func (p *porker2) JoinRoom(ctx context.Context, r *connect.Request[pb.JoinRoomRequest], stream *connect.ServerStream[pb.JoinRoomResponse]) error {
	if err := p.v.VarWithMessage(r.Msg.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return err
	}

	fn := func(ctx context.Context, rc *poker.RoomCondition) (bool, error) {
		if err := stream.Send(&pb.JoinRoomResponse{
			Condition: roomConditionToProto(rc),
		}); err != nil {
			return false, err
		}
		return true, nil
	}

	if err := p.pokerItr.JoinRoom(ctx, user.FromContextID(ctx), roomIDFromProto(r.Msg.RoomId), fn); err != nil {
		return err
	}

	return nil
}

func (p *porker2) LeaveRoom(ctx context.Context, r *connect.Request[pb.LeaveRoomRequest]) (*connect.Response[pb.LeaveRoomResponse], error) {
	if err := p.v.VarWithMessage(r.Msg.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.LeaveRoom(ctx, user.FromContextID(ctx)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.LeaveRoomResponse]{
		Msg: &pb.LeaveRoomResponse{},
	}, nil
}

func (p *porker2) CastVote(ctx context.Context, r *connect.Request[pb.CastVoteRequest]) (*connect.Response[pb.CastVoteResponse], error) {
	roomID := roomIDFromProto(r.Msg.RoomId)
	point := pointFromProto(r.Msg.Point)

	vs := struct {
		RoomID poker.RoomID `validate:"room_id"`
		Point  poker.Point  `validate:"point"`
	}{
		RoomID: roomID,
		Point:  point,
	}
	if err := p.v.StructWithMessage(vs, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.CastVote(ctx, user.FromContextID(ctx), roomID, point); err != nil {
		return nil, err
	}

	return &connect.Response[pb.CastVoteResponse]{
		Msg: &pb.CastVoteResponse{},
	}, nil
}

func (p *porker2) ShowVotes(ctx context.Context, r *connect.Request[pb.ShowVotesRequest]) (*connect.Response[pb.ShowVotesResponse], error) {
	if err := p.v.VarWithMessage(r.Msg.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ShowVotes(ctx, user.FromContextID(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.ShowVotesResponse]{}, nil
}

func (p *porker2) ResetVotes(ctx context.Context, r *connect.Request[pb.ResetVotesRequest]) (*connect.Response[pb.ResetVotesResponse], error) {
	if err := p.v.VarWithMessage(r.Msg.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ResetVotes(ctx, user.FromContextID(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.ResetVotesResponse]{}, nil
}

func (p *porker2) KickUser(ctx context.Context, r *connect.Request[pb.KickUserRequest]) (*connect.Response[pb.KickUserResponse], error) {
	roomID := roomIDFromProto(r.Msg.RoomId)
	targetUserID := userIDFromProto(r.Msg.TargetUserId)

	vs := struct {
		roomID       poker.RoomID `validate:"room_id"`
		targetUserID user.ID      `validate:"user_id"`
	}{
		roomID:       roomID,
		targetUserID: targetUserID,
	}
	if err := p.v.StructWithMessage(vs, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.Kick(ctx, user.FromContextID(ctx), targetUserID, roomID); err != nil {
		return nil, err
	}

	return &connect.Response[pb.KickUserResponse]{
		Msg: &pb.KickUserResponse{},
	}, nil
}
