package controller

import (
	"context"

	"connectrpc.com/connect"

	pb "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2"
	pbconn "github.com/swallowarc/porker2/backend/internal/interface/pb/porker/v2/porkerv2connect"
)

type (
	porker2 struct {
	}
)

func NewPorker2Controller() pbconn.Porker2ServiceHandler {
	return &porker2{}
}

func (p *porker2) Login(ctx context.Context, c *connect.Request[pb.LoginRequest]) (*connect.Response[pb.LoginResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) Logout(ctx context.Context, c *connect.Request[pb.LogoutRequest]) (*connect.Response[pb.LogoutResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) CreateRoom(ctx context.Context, c *connect.Request[pb.CreateRoomRequest]) (*connect.Response[pb.CreateRoomResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) JoinRoom(ctx context.Context, c *connect.Request[pb.JoinRoomRequest], c2 *connect.ServerStream[pb.JoinRoomResponse]) error {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) LeaveRoom(ctx context.Context, c *connect.Request[pb.LeaveRoomRequest]) (*connect.Response[pb.LeaveRoomResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) CastVote(ctx context.Context, c *connect.Request[pb.CastVoteRequest]) (*connect.Response[pb.CastVoteResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) ShowVotes(ctx context.Context, c *connect.Request[pb.ShowVotesRequest]) (*connect.Response[pb.ShowVotesResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) ResetVotes(ctx context.Context, c *connect.Request[pb.ResetVotesRequest]) (*connect.Response[pb.ResetVotesResponse], error) {
	//TODO implement me
	panic("implement me")
}

func (p *porker2) KickUser(ctx context.Context, c *connect.Request[pb.KickUserRequest]) (*connect.Response[pb.KickUserResponse], error) {
	//TODO implement me
	panic("implement me")
}
