//
//  Generated code. Do not modify.
//  source: porker/v2/service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('porker.v2.Porker2Service')
class Porker2ServiceClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/porker.v2.Porker2Service/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LoginResponse.fromBuffer(value));
  static final _$logout = $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
      '/porker.v2.Porker2Service/Logout',
      ($0.LogoutRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LogoutResponse.fromBuffer(value));
  static final _$kickUser = $grpc.ClientMethod<$0.KickUserRequest, $0.KickUserResponse>(
      '/porker.v2.Porker2Service/KickUser',
      ($0.KickUserRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.KickUserResponse.fromBuffer(value));
  static final _$createRoom = $grpc.ClientMethod<$0.CreateRoomRequest, $0.CreateRoomResponse>(
      '/porker.v2.Porker2Service/CreateRoom',
      ($0.CreateRoomRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CreateRoomResponse.fromBuffer(value));
  static final _$joinRoom = $grpc.ClientMethod<$0.JoinRoomRequest, $0.JoinRoomResponse>(
      '/porker.v2.Porker2Service/JoinRoom',
      ($0.JoinRoomRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.JoinRoomResponse.fromBuffer(value));
  static final _$leaveRoom = $grpc.ClientMethod<$0.LeaveRoomRequest, $0.LeaveRoomResponse>(
      '/porker.v2.Porker2Service/LeaveRoom',
      ($0.LeaveRoomRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LeaveRoomResponse.fromBuffer(value));
  static final _$castVote = $grpc.ClientMethod<$0.CastVoteRequest, $0.CastVoteResponse>(
      '/porker.v2.Porker2Service/CastVote',
      ($0.CastVoteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CastVoteResponse.fromBuffer(value));
  static final _$showVotes = $grpc.ClientMethod<$0.ShowVotesRequest, $0.ShowVotesResponse>(
      '/porker.v2.Porker2Service/ShowVotes',
      ($0.ShowVotesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ShowVotesResponse.fromBuffer(value));
  static final _$resetVotes = $grpc.ClientMethod<$0.ResetVotesRequest, $0.ResetVotesResponse>(
      '/porker.v2.Porker2Service/ResetVotes',
      ($0.ResetVotesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ResetVotesResponse.fromBuffer(value));

  Porker2ServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LoginResponse> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$0.LogoutResponse> logout($0.LogoutRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  $grpc.ResponseFuture<$0.KickUserResponse> kickUser($0.KickUserRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$kickUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateRoomResponse> createRoom($0.CreateRoomRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createRoom, request, options: options);
  }

  $grpc.ResponseStream<$0.JoinRoomResponse> joinRoom($0.JoinRoomRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$joinRoom, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.LeaveRoomResponse> leaveRoom($0.LeaveRoomRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$leaveRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.CastVoteResponse> castVote($0.CastVoteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$castVote, request, options: options);
  }

  $grpc.ResponseFuture<$0.ShowVotesResponse> showVotes($0.ShowVotesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$showVotes, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResetVotesResponse> resetVotes($0.ResetVotesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetVotes, request, options: options);
  }
}

@$pb.GrpcServiceName('porker.v2.Porker2Service')
abstract class Porker2ServiceBase extends $grpc.Service {
  $core.String get $name => 'porker.v2.Porker2Service';

  Porker2ServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KickUserRequest, $0.KickUserResponse>(
        'KickUser',
        kickUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KickUserRequest.fromBuffer(value),
        ($0.KickUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateRoomRequest, $0.CreateRoomResponse>(
        'CreateRoom',
        createRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateRoomRequest.fromBuffer(value),
        ($0.CreateRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinRoomRequest, $0.JoinRoomResponse>(
        'JoinRoom',
        joinRoom_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.JoinRoomRequest.fromBuffer(value),
        ($0.JoinRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaveRoomRequest, $0.LeaveRoomResponse>(
        'LeaveRoom',
        leaveRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LeaveRoomRequest.fromBuffer(value),
        ($0.LeaveRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CastVoteRequest, $0.CastVoteResponse>(
        'CastVote',
        castVote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CastVoteRequest.fromBuffer(value),
        ($0.CastVoteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ShowVotesRequest, $0.ShowVotesResponse>(
        'ShowVotes',
        showVotes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ShowVotesRequest.fromBuffer(value),
        ($0.ShowVotesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResetVotesRequest, $0.ResetVotesResponse>(
        'ResetVotes',
        resetVotes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ResetVotesRequest.fromBuffer(value),
        ($0.ResetVotesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> login_Pre($grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$0.LogoutResponse> logout_Pre($grpc.ServiceCall call, $async.Future<$0.LogoutRequest> request) async {
    return logout(call, await request);
  }

  $async.Future<$0.KickUserResponse> kickUser_Pre($grpc.ServiceCall call, $async.Future<$0.KickUserRequest> request) async {
    return kickUser(call, await request);
  }

  $async.Future<$0.CreateRoomResponse> createRoom_Pre($grpc.ServiceCall call, $async.Future<$0.CreateRoomRequest> request) async {
    return createRoom(call, await request);
  }

  $async.Stream<$0.JoinRoomResponse> joinRoom_Pre($grpc.ServiceCall call, $async.Future<$0.JoinRoomRequest> request) async* {
    yield* joinRoom(call, await request);
  }

  $async.Future<$0.LeaveRoomResponse> leaveRoom_Pre($grpc.ServiceCall call, $async.Future<$0.LeaveRoomRequest> request) async {
    return leaveRoom(call, await request);
  }

  $async.Future<$0.CastVoteResponse> castVote_Pre($grpc.ServiceCall call, $async.Future<$0.CastVoteRequest> request) async {
    return castVote(call, await request);
  }

  $async.Future<$0.ShowVotesResponse> showVotes_Pre($grpc.ServiceCall call, $async.Future<$0.ShowVotesRequest> request) async {
    return showVotes(call, await request);
  }

  $async.Future<$0.ResetVotesResponse> resetVotes_Pre($grpc.ServiceCall call, $async.Future<$0.ResetVotesRequest> request) async {
    return resetVotes(call, await request);
  }

  $async.Future<$0.LoginResponse> login($grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$0.LogoutResponse> logout($grpc.ServiceCall call, $0.LogoutRequest request);
  $async.Future<$0.KickUserResponse> kickUser($grpc.ServiceCall call, $0.KickUserRequest request);
  $async.Future<$0.CreateRoomResponse> createRoom($grpc.ServiceCall call, $0.CreateRoomRequest request);
  $async.Stream<$0.JoinRoomResponse> joinRoom($grpc.ServiceCall call, $0.JoinRoomRequest request);
  $async.Future<$0.LeaveRoomResponse> leaveRoom($grpc.ServiceCall call, $0.LeaveRoomRequest request);
  $async.Future<$0.CastVoteResponse> castVote($grpc.ServiceCall call, $0.CastVoteRequest request);
  $async.Future<$0.ShowVotesResponse> showVotes($grpc.ServiceCall call, $0.ShowVotesRequest request);
  $async.Future<$0.ResetVotesResponse> resetVotes($grpc.ServiceCall call, $0.ResetVotesRequest request);
}
