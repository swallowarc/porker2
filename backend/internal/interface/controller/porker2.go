package controller

import (
	"context"
	"log/slog"

	"connectrpc.com/connect"

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

func (p *porker2) Login(ctx context.Context, r *connect.Request[pb.LoginRequest]) (*connect.Response[pb.LoginResponse], error) {
	var f requestFields
	name := f.userName(r.Msg.UserName)
	if err := f.err(); err != nil {
		return nil, err
	}

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

	p.session.SetCookie(res, token)

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

	res := &connect.Response[pb.VerifyUserResponse]{
		Msg: &pb.VerifyUserResponse{
			UserId:   userID.String(),
			UserName: name.String(),
		},
	}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) CreateRoom(ctx context.Context, _ *connect.Request[pb.CreateRoomRequest]) (*connect.Response[pb.CreateRoomResponse], error) {
	roomID, err := p.pokerItr.CreateRoom(ctx)
	if err != nil {
		return nil, err
	}

	res := &connect.Response[pb.CreateRoomResponse]{
		Msg: &pb.CreateRoomResponse{
			RoomId: roomID.String(),
		},
	}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) CheckRoom(ctx context.Context, r *connect.Request[pb.CheckRoomRequest]) (*connect.Response[pb.CheckRoomResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.CheckRoom(ctx, p.session.UserIDFromCtx(ctx), roomID); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.CheckRoomResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) JoinRoom(ctx context.Context, r *connect.Request[pb.JoinRoomRequest], stream *connect.ServerStream[pb.JoinRoomResponse]) error {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
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
func (p *porker2) LeaveRoom(ctx context.Context, _ *connect.Request[pb.LeaveRoomRequest]) (*connect.Response[pb.LeaveRoomResponse], error) {
	if err := p.pokerItr.LeaveRoom(ctx, p.session.UserIDFromCtx(ctx)); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.LeaveRoomResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) CastVote(ctx context.Context, r *connect.Request[pb.CastVoteRequest]) (*connect.Response[pb.CastVoteResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	point := f.point(r.Msg.Point)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.CastVote(ctx, p.session.UserIDFromCtx(ctx), roomID, point); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.CastVoteResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) ShowVotes(ctx context.Context, r *connect.Request[pb.ShowVotesRequest]) (*connect.Response[pb.ShowVotesResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ShowVotes(ctx, p.session.UserIDFromCtx(ctx), roomID); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.ShowVotesResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) ResetVotes(ctx context.Context, r *connect.Request[pb.ResetVotesRequest]) (*connect.Response[pb.ResetVotesResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ResetVotes(ctx, p.session.UserIDFromCtx(ctx), roomID); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.ResetVotesResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) KickUser(ctx context.Context, r *connect.Request[pb.KickUserRequest]) (*connect.Response[pb.KickUserResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	targetUserID := f.userID("target_user_id", r.Msg.TargetUserId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.Kick(ctx, p.session.UserIDFromCtx(ctx), targetUserID, roomID); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.KickUserResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) UpdateRoom(ctx context.Context, r *connect.Request[pb.UpdateRoomRequest]) (*connect.Response[pb.UpdateRoomResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	displayMode := f.displayMode(r.Msg.DisplayMode)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.Update(ctx, p.session.UserIDFromCtx(ctx), roomID, r.Msg.AutoOpen, displayMode); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.UpdateRoomResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}

func (p *porker2) ToggleObserverMode(ctx context.Context, r *connect.Request[pb.ToggleObserverModeRequest]) (*connect.Response[pb.ToggleObserverModeResponse], error) {
	var f requestFields
	roomID := f.roomID(r.Msg.RoomId)
	if err := f.err(); err != nil {
		return nil, err
	}

	if err := p.pokerItr.ToggleObserverMode(ctx, p.session.UserIDFromCtx(ctx), roomID, r.Msg.IsObserver); err != nil {
		return nil, err
	}

	res := &connect.Response[pb.ToggleObserverModeResponse]{}
	p.session.RefreshCookie(ctx, res)

	return res, nil
}
