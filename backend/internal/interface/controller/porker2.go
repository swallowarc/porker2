package controller

import (
	"context"
	"errors"
	"log/slog"

	"connectrpc.com/connect"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/core/merror"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	"github.com/swallowarc/porker2/backend/internal/domain/user"
	"github.com/swallowarc/porker2/backend/internal/domain/validator"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
	"github.com/swallowarc/porker2/backend/internal/usecase/interactor"
)

type (
	porker2 struct {
		session  session.Manager
		v        validator.Validator
		userItr  interactor.User
		pokerItr interactor.Poker
	}
)

func NewPorker2Controller(
	session session.Manager,
	v validator.Validator,
	userItr interactor.User,
	pokerItr interactor.Poker,
) pbconn.Porker2ServiceHandler {
	return &porker2{
		session:  session,
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

	logger.FromCtx(ctx).Info("user login", slog.String("name", name.String()), slog.String("id", id.String()))

	res := &connect.Response[pb.LoginResponse]{
		Msg: &pb.LoginResponse{
			UserId: id.String(),
		},
	}

	res.Header().Add("Set-Cookie", p.session.CreateCookieString(token))

	return res, nil
}

func (p *porker2) Logout(ctx context.Context, _ *connect.Request[pb.LogoutRequest]) (*connect.Response[pb.LogoutResponse], error) {
	if err := p.userItr.Logout(ctx, p.session.UserIDFromCtx(ctx)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.LogoutResponse]{
		Msg: &pb.LogoutResponse{},
	}, nil
}

func (p *porker2) VerifyUser(ctx context.Context, _ *connect.Request[pb.VerifyUserRequest]) (*connect.Response[pb.VerifyUserResponse], error) {
	userID := p.session.UserIDFromCtx(ctx)

	name, err := p.userItr.GetUser(ctx, userID)
	if err != nil {
		return nil, err
	}

	return &connect.Response[pb.VerifyUserResponse]{
		Msg: &pb.VerifyUserResponse{
			UserId:   userID.String(),
			UserName: name.String(),
		},
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

func (p *porker2) CheckRoom(ctx context.Context, r *connect.Request[pb.CheckRoomRequest]) (*connect.Response[pb.CheckRoomResponse], error) {
	if err := p.pokerItr.CheckRoom(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.CheckRoomResponse]{
		Msg: &pb.CheckRoomResponse{},
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
		logger.FromCtx(ctx).Debug("room condition sent", slog.String("room_id", rc.RoomID.String()))
		return true, nil
	}

	if err := p.pokerItr.JoinRoom(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.Msg.RoomId), fn); err != nil {
		if errors.Is(err, context.Canceled) {
			// when httpserver.WriteTimeout is exceeded
			return merror.NewCanceled("connection closed(WriteTimeout)")
		}
		return err
	}

	return nil
}

func (p *porker2) LeaveRoom(ctx context.Context, r *connect.Request[pb.LeaveRoomRequest]) (*connect.Response[pb.LeaveRoomResponse], error) {
	if err := p.v.VarWithMessage(r.Msg.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.LeaveRoom(ctx, p.session.UserIDFromCtx(ctx)); err != nil {
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

	if err := p.pokerItr.CastVote(ctx, p.session.UserIDFromCtx(ctx), roomID, point); err != nil {
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

	if err := p.pokerItr.ShowVotes(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
		return nil, err
	}

	return &connect.Response[pb.ShowVotesResponse]{}, nil
}

func (p *porker2) ResetVotes(ctx context.Context, r *connect.Request[pb.ResetVotesRequest]) (*connect.Response[pb.ResetVotesResponse], error) {
	if err := p.v.VarWithMessage(r.Msg.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ResetVotes(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.Msg.RoomId)); err != nil {
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

	if err := p.pokerItr.Kick(ctx, p.session.UserIDFromCtx(ctx), targetUserID, roomID); err != nil {
		return nil, err
	}

	return &connect.Response[pb.KickUserResponse]{
		Msg: &pb.KickUserResponse{},
	}, nil
}
