package controller

import (
	"context"
	"errors"
	"log/slog"

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

func (p *porker2) Login(ctx context.Context, r *pb.LoginRequest) (*pb.LoginResponse, error) {
	if err := p.v.VarWithMessage(r.UserName, validator.TagUserName, "invalid argument"); err != nil {
		return nil, err
	}

	name := user.Name(r.UserName)
	id, token, err := p.userItr.Login(ctx, name)
	if err != nil {
		return nil, err
	}

	logger.FromCtx(ctx).Info("user login", slog.String("name", name.String()), slog.String("id", id.String()))

	res := &pb.LoginResponse{
		UserId: id.String(),
	}

	p.session.SetCookie(ctx, token)

	return res, nil
}

func (p *porker2) Logout(ctx context.Context, _ *pb.LogoutRequest) (*pb.LogoutResponse, error) {
	if err := p.userItr.Logout(ctx, p.session.UserIDFromCtx(ctx)); err != nil {
		return nil, err
	}

	return &pb.LogoutResponse{}, nil
}

func (p *porker2) VerifyUser(ctx context.Context, _ *pb.VerifyUserRequest) (*pb.VerifyUserResponse, error) {
	userID := p.session.UserIDFromCtx(ctx)

	name, err := p.userItr.GetUser(ctx, userID)
	if err != nil {
		return nil, err
	}

	res := &pb.VerifyUserResponse{
		UserId:   userID.String(),
		UserName: name.String(),
	}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) CreateRoom(ctx context.Context, _ *pb.CreateRoomRequest) (*pb.CreateRoomResponse, error) {
	roomID, err := p.pokerItr.CreateRoom(ctx)
	if err != nil {
		return nil, err
	}

	res := &pb.CreateRoomResponse{
		RoomId: roomID.String(),
	}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) CheckRoom(ctx context.Context, r *pb.CheckRoomRequest) (*pb.CheckRoomResponse, error) {
	if err := p.v.VarWithMessage(r.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.CheckRoom(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.RoomId)); err != nil {
		return nil, err
	}

	res := &pb.CheckRoomResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) JoinRoom(ctx context.Context, r *pb.JoinRoomRequest, stream pbconn.Porker2ServiceJoinRoomServerStream) error {
	if err := p.v.VarWithMessage(r.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
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

	if err := p.pokerItr.JoinRoom(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.RoomId), fn); err != nil {
		if errors.Is(err, context.Canceled) {
			// when httpserver.WriteTimeout is exceeded
			return merror.NewCanceled("connection closed(WriteTimeout)")
		}
		return err
	}

	return nil
}

func (p *porker2) LeaveRoom(ctx context.Context, r *pb.LeaveRoomRequest) (*pb.LeaveRoomResponse, error) {
	if err := p.v.VarWithMessage(r.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.LeaveRoom(ctx, p.session.UserIDFromCtx(ctx)); err != nil {
		return nil, err
	}

	res := &pb.LeaveRoomResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) CastVote(ctx context.Context, r *pb.CastVoteRequest) (*pb.CastVoteResponse, error) {
	roomID := roomIDFromProto(r.RoomId)
	point := pointFromProto(r.Point)

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

	res := &pb.CastVoteResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) ShowVotes(ctx context.Context, r *pb.ShowVotesRequest) (*pb.ShowVotesResponse, error) {
	if err := p.v.VarWithMessage(r.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ShowVotes(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.RoomId)); err != nil {
		return nil, err
	}

	res := &pb.ShowVotesResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) ResetVotes(ctx context.Context, r *pb.ResetVotesRequest) (*pb.ResetVotesResponse, error) {
	if err := p.v.VarWithMessage(r.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ResetVotes(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.RoomId)); err != nil {
		return nil, err
	}

	res := &pb.ResetVotesResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) KickUser(ctx context.Context, r *pb.KickUserRequest) (*pb.KickUserResponse, error) {
	roomID := roomIDFromProto(r.RoomId)
	targetUserID := userIDFromProto(r.TargetUserId)

	// NOTE: go-playground/validator は非公開フィールドを検証しないので、フィールドは必ず公開する。
	vs := struct {
		RoomID       poker.RoomID `validate:"room_id"`
		TargetUserID user.ID      `validate:"user_id"`
	}{
		RoomID:       roomID,
		TargetUserID: targetUserID,
	}
	if err := p.v.StructWithMessage(vs, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.Kick(ctx, p.session.UserIDFromCtx(ctx), targetUserID, roomID); err != nil {
		return nil, err
	}

	res := &pb.KickUserResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) UpdateRoom(ctx context.Context, r *pb.UpdateRoomRequest) (*pb.UpdateRoomResponse, error) {
	roomID := roomIDFromProto(r.RoomId)
	displayMode := poker.DisplayMode(r.DisplayMode)

	vs := struct {
		RoomID      poker.RoomID      `validate:"room_id"`
		DisplayMode poker.DisplayMode `validate:"display_mode"`
	}{
		RoomID:      roomID,
		DisplayMode: displayMode,
	}
	if err := p.v.StructWithMessage(vs, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.Update(ctx, p.session.UserIDFromCtx(ctx), roomID, r.AutoOpen, displayMode); err != nil {
		return nil, err
	}

	res := &pb.UpdateRoomResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) ToggleObserverMode(ctx context.Context, r *pb.ToggleObserverModeRequest) (*pb.ToggleObserverModeResponse, error) {
	if err := p.v.VarWithMessage(r.RoomId, validator.TagRoomID, "invalid argument"); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ToggleObserverMode(ctx, p.session.UserIDFromCtx(ctx), roomIDFromProto(r.RoomId), r.IsObserver); err != nil {
		return nil, err
	}

	res := &pb.ToggleObserverModeResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}
