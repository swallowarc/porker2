//
//  Generated code. Do not modify.
//  source: porker/v2/service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "service.pb.dart" as porkerv2service;

abstract final class Porker2Service {
  /// Fully-qualified name of the Porker2Service service.
  static const name = 'porker.v2.Porker2Service';

  static const login = connect.Spec(
    '/$name/Login',
    connect.StreamType.unary,
    porkerv2service.LoginRequest.new,
    porkerv2service.LoginResponse.new,
  );

  static const logout = connect.Spec(
    '/$name/Logout',
    connect.StreamType.unary,
    porkerv2service.LogoutRequest.new,
    porkerv2service.LogoutResponse.new,
  );

  static const verifyUser = connect.Spec(
    '/$name/VerifyUser',
    connect.StreamType.unary,
    porkerv2service.VerifyUserRequest.new,
    porkerv2service.VerifyUserResponse.new,
  );

  static const createRoom = connect.Spec(
    '/$name/CreateRoom',
    connect.StreamType.unary,
    porkerv2service.CreateRoomRequest.new,
    porkerv2service.CreateRoomResponse.new,
  );

  static const checkRoom = connect.Spec(
    '/$name/CheckRoom',
    connect.StreamType.unary,
    porkerv2service.CheckRoomRequest.new,
    porkerv2service.CheckRoomResponse.new,
  );

  static const joinRoom = connect.Spec(
    '/$name/JoinRoom',
    connect.StreamType.server,
    porkerv2service.JoinRoomRequest.new,
    porkerv2service.JoinRoomResponse.new,
  );

  static const leaveRoom = connect.Spec(
    '/$name/LeaveRoom',
    connect.StreamType.unary,
    porkerv2service.LeaveRoomRequest.new,
    porkerv2service.LeaveRoomResponse.new,
  );

  static const castVote = connect.Spec(
    '/$name/CastVote',
    connect.StreamType.unary,
    porkerv2service.CastVoteRequest.new,
    porkerv2service.CastVoteResponse.new,
  );

  static const showVotes = connect.Spec(
    '/$name/ShowVotes',
    connect.StreamType.unary,
    porkerv2service.ShowVotesRequest.new,
    porkerv2service.ShowVotesResponse.new,
  );

  static const resetVotes = connect.Spec(
    '/$name/ResetVotes',
    connect.StreamType.unary,
    porkerv2service.ResetVotesRequest.new,
    porkerv2service.ResetVotesResponse.new,
  );

  static const kickUser = connect.Spec(
    '/$name/KickUser',
    connect.StreamType.unary,
    porkerv2service.KickUserRequest.new,
    porkerv2service.KickUserResponse.new,
  );

  static const updateRoom = connect.Spec(
    '/$name/UpdateRoom',
    connect.StreamType.unary,
    porkerv2service.UpdateRoomRequest.new,
    porkerv2service.UpdateRoomResponse.new,
  );

  static const toggleObserverMode = connect.Spec(
    '/$name/ToggleObserverMode',
    connect.StreamType.unary,
    porkerv2service.ToggleObserverModeRequest.new,
    porkerv2service.ToggleObserverModeResponse.new,
  );
}
