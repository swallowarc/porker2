package controller

import (
	"context"
	"log/slog"

	"github.com/swallowarc/porker2/backend/internal/core/logger"
	"github.com/swallowarc/porker2/backend/internal/domain/poker"
	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
	"github.com/swallowarc/porker2/backend/internal/interface/session"
	"github.com/swallowarc/porker2/backend/internal/usecase/interactor"
)

type (
	porker2 struct {
		session  session.Manager
		userItr  interactor.User
		pokerItr interactor.Poker
	}
)

func NewPorker2Controller(
	session session.Manager,
	userItr interactor.User,
	pokerItr interactor.Poker,
) pbconn.Porker2ServiceHandler {
	return &porker2{
		session:  session,
		userItr:  userItr,
		pokerItr: pokerItr,
	}
}

func (p *porker2) Login(ctx context.Context, r *pb.LoginRequest) (*pb.LoginResponse, error) {
	var f requestFields
	name := f.userName(r.UserName)
	if err := f.err(); err != nil {
		return nil, err
	}

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
	var f requestFields
	roomID := f.roomID(r.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.CheckRoom(ctx, p.session.UserIDFromCtx(ctx), roomID); err != nil {
		return nil, err
	}

	res := &pb.CheckRoomResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) JoinRoom(ctx context.Context, r *pb.JoinRoomRequest, stream pbconn.Porker2ServiceJoinRoomServerStream) error {
	var f requestFields
	roomID := f.roomID(r.RoomId)
	if err := f.err(); err != nil {
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

	// context.Canceled (WriteTimeout 超過等) は rpcerr が Canceled に変換する
	return p.pokerItr.JoinRoom(ctx, p.session.UserIDFromCtx(ctx), roomID, fn)
}

// LeaveRoom はユーザーが現在参加している部屋から退室する。
// 退室先はサーバー側のユーザー情報から決まるため、リクエストの room_id は参照しない
// (クライアントはストリーム切断後に room_id が空の状態で呼ぶことがある)。
func (p *porker2) LeaveRoom(ctx context.Context, _ *pb.LeaveRoomRequest) (*pb.LeaveRoomResponse, error) {
	if err := p.pokerItr.LeaveRoom(ctx, p.session.UserIDFromCtx(ctx)); err != nil {
		return nil, err
	}

	res := &pb.LeaveRoomResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) CastVote(ctx context.Context, r *pb.CastVoteRequest) (*pb.CastVoteResponse, error) {
	var f requestFields
	roomID := f.roomID(r.RoomId)
	point := f.point(r.Point)
	if err := f.err(); err != nil {
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
	var f requestFields
	roomID := f.roomID(r.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ShowVotes(ctx, p.session.UserIDFromCtx(ctx), roomID); err != nil {
		return nil, err
	}

	res := &pb.ShowVotesResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) ResetVotes(ctx context.Context, r *pb.ResetVotesRequest) (*pb.ResetVotesResponse, error) {
	var f requestFields
	roomID := f.roomID(r.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ResetVotes(ctx, p.session.UserIDFromCtx(ctx), roomID); err != nil {
		return nil, err
	}

	res := &pb.ResetVotesResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}

func (p *porker2) KickUser(ctx context.Context, r *pb.KickUserRequest) (*pb.KickUserResponse, error) {
	var f requestFields
	roomID := f.roomID(r.RoomId)
	targetUserID := f.userID("target_user_id", r.TargetUserId)
	if err := f.err(); err != nil {
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
	var f requestFields
	roomID := f.roomID(r.RoomId)
	displayMode := f.displayMode(r.DisplayMode)
	if err := f.err(); err != nil {
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
	var f requestFields
	roomID := f.roomID(r.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ToggleObserverMode(ctx, p.session.UserIDFromCtx(ctx), roomID, r.IsObserver); err != nil {
		return nil, err
	}

	res := &pb.ToggleObserverModeResponse{}
	p.session.RefreshCookie(ctx)

	return res, nil
}
