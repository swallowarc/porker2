package controller

import (
	"context"

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
	if err := p.v.VarWithMessage(validator.TagUserName, r.Msg.UserName, "invalid argument"); err != nil {
		return nil, err
	}

	name := user.Name(r.Msg.UserName)
	userID, err := p.userItr.Login(ctx, name)
	if err != nil {
		return nil, err
	}

	return &connect.Response[pb.LoginResponse]{
		Msg: &pb.LoginResponse{
			UserId: userID.String(),
		},
	}, nil
}

func (p *porker2) Logout(ctx context.Context, _ *connect.Request[pb.LogoutRequest]) (*connect.Response[pb.LogoutResponse], error) {
	if err := p.userItr.Logout(ctx, user.FromContext(ctx)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.LogoutResponse]{
		Msg: &pb.LogoutResponse{},
	}, nil
}

func (p *porker2) CreateRoom(ctx context.Context, _ *connect.Request[pb.CreateRoomRequest]) (*connect.Response[pb.CreateRoomResponse], error) {
	roomID, err := p.pokerItr.CreateRoom(ctx, user.FromContext(ctx))
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
	if err := p.validateRoomID(r.Msg.RoomId); err != nil {
		return err
	}

	ch := make(chan *poker.RoomCondition)
	defer close(ch)

	if err := p.pokerItr.JoinRoom(ctx, user.FromContext(ctx), roomIDFromProto(r.Msg.RoomId), ch); err != nil {
		return err
	}

	for {
		select {
		case <-ctx.Done():
			logger.FromCtx(ctx).Info("context done: %v", ctx.Err())
			return nil
		case rc := <-ch:
			if err := stream.Send(&pb.JoinRoomResponse{
				Condition: roomConditionToProto(rc),
			}); err != nil {
				return err
			}
		}
	}
}

func (p *porker2) LeaveRoom(ctx context.Context, r *connect.Request[pb.LeaveRoomRequest]) (*connect.Response[pb.LeaveRoomResponse], error) {
	if err := p.validateRoomID(r.Msg.RoomId); err != nil {
		return nil, err
	}

	if err := p.pokerItr.LeaveRoom(ctx, user.FromContext(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.LeaveRoomResponse]{
		Msg: &pb.LeaveRoomResponse{},
	}, nil
}

func (p *porker2) CastVote(ctx context.Context, r *connect.Request[pb.CastVoteRequest]) (*connect.Response[pb.CastVoteResponse], error) {
	roomID := roomIDFromProto(r.Msg.RoomId)
	ballot := ballotFromProto(r.Msg.Ballot)

	vs := struct {
		roomID poker.RoomID `validate:"room_id"`
		ballot *poker.Ballot
	}{
		roomID: roomID,
		ballot: ballot,
	}
	if err := p.v.StructWithMessage(vs, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.CastVote(ctx, user.FromContext(ctx), roomID, ballot.Point); err != nil {
		return nil, err
	}

	return &connect.Response[pb.CastVoteResponse]{
		Msg: &pb.CastVoteResponse{},
	}, nil
}

func (p *porker2) ShowVotes(ctx context.Context, r *connect.Request[pb.ShowVotesRequest]) (*connect.Response[pb.ShowVotesResponse], error) {
	if err := p.validateRoomID(r.Msg.RoomId); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ShowVotes(ctx, user.FromContext(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.ShowVotesResponse]{}, nil
}

func (p *porker2) ResetVotes(ctx context.Context, r *connect.Request[pb.ResetVotesRequest]) (*connect.Response[pb.ResetVotesResponse], error) {
	if err := p.validateRoomID(r.Msg.RoomId); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ResetVotes(ctx, user.FromContext(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
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

	if err := p.pokerItr.Kick(ctx, user.FromContext(ctx), targetUserID, roomID); err != nil {
		return nil, err
	}

	return &connect.Response[pb.KickUserResponse]{
		Msg: &pb.KickUserResponse{},
	}, nil
}

func (p *porker2) validateRoomID(roomID string) error {
	return p.v.VarWithMessage(validator.TagRoomID, roomID, "invalid argument")
}
