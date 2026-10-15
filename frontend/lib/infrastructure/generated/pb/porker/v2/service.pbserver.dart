// This is a generated file - do not edit.
//
// Generated from porker/v2/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $1;
import 'service.pbjson.dart';

export 'service.pb.dart';

abstract class Porker2ServiceBase extends $pb.GeneratedService {
  $async.Future<$1.LoginResponse> login(
      $pb.ServerContext ctx, $1.LoginRequest request);
  $async.Future<$1.LogoutResponse> logout(
      $pb.ServerContext ctx, $1.LogoutRequest request);
  $async.Future<$1.VerifyUserResponse> verifyUser(
      $pb.ServerContext ctx, $1.VerifyUserRequest request);
  $async.Future<$1.CreateRoomResponse> createRoom(
      $pb.ServerContext ctx, $1.CreateRoomRequest request);
  $async.Future<$1.CheckRoomResponse> checkRoom(
      $pb.ServerContext ctx, $1.CheckRoomRequest request);
  $async.Future<$1.JoinRoomResponse> joinRoom(
      $pb.ServerContext ctx, $1.JoinRoomRequest request);
  $async.Future<$1.LeaveRoomResponse> leaveRoom(
      $pb.ServerContext ctx, $1.LeaveRoomRequest request);
  $async.Future<$1.CastVoteResponse> castVote(
      $pb.ServerContext ctx, $1.CastVoteRequest request);
  $async.Future<$1.ShowVotesResponse> showVotes(
      $pb.ServerContext ctx, $1.ShowVotesRequest request);
  $async.Future<$1.ResetVotesResponse> resetVotes(
      $pb.ServerContext ctx, $1.ResetVotesRequest request);
  $async.Future<$1.KickUserResponse> kickUser(
      $pb.ServerContext ctx, $1.KickUserRequest request);
  $async.Future<$1.UpdateRoomResponse> updateRoom(
      $pb.ServerContext ctx, $1.UpdateRoomRequest request);
  $async.Future<$1.ToggleObserverModeResponse> toggleObserverMode(
      $pb.ServerContext ctx, $1.ToggleObserverModeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login':
        return $1.LoginRequest();
      case 'Logout':
        return $1.LogoutRequest();
      case 'VerifyUser':
        return $1.VerifyUserRequest();
      case 'CreateRoom':
        return $1.CreateRoomRequest();
      case 'CheckRoom':
        return $1.CheckRoomRequest();
      case 'JoinRoom':
        return $1.JoinRoomRequest();
      case 'LeaveRoom':
        return $1.LeaveRoomRequest();
      case 'CastVote':
        return $1.CastVoteRequest();
      case 'ShowVotes':
        return $1.ShowVotesRequest();
      case 'ResetVotes':
        return $1.ResetVotesRequest();
      case 'KickUser':
        return $1.KickUserRequest();
      case 'UpdateRoom':
        return $1.UpdateRoomRequest();
      case 'ToggleObserverMode':
        return $1.ToggleObserverModeRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login':
        return login(ctx, request as $1.LoginRequest);
      case 'Logout':
        return logout(ctx, request as $1.LogoutRequest);
      case 'VerifyUser':
        return verifyUser(ctx, request as $1.VerifyUserRequest);
      case 'CreateRoom':
        return createRoom(ctx, request as $1.CreateRoomRequest);
      case 'CheckRoom':
        return checkRoom(ctx, request as $1.CheckRoomRequest);
      case 'JoinRoom':
        return joinRoom(ctx, request as $1.JoinRoomRequest);
      case 'LeaveRoom':
        return leaveRoom(ctx, request as $1.LeaveRoomRequest);
      case 'CastVote':
        return castVote(ctx, request as $1.CastVoteRequest);
      case 'ShowVotes':
        return showVotes(ctx, request as $1.ShowVotesRequest);
      case 'ResetVotes':
        return resetVotes(ctx, request as $1.ResetVotesRequest);
      case 'KickUser':
        return kickUser(ctx, request as $1.KickUserRequest);
      case 'UpdateRoom':
        return updateRoom(ctx, request as $1.UpdateRoomRequest);
      case 'ToggleObserverMode':
        return toggleObserverMode(ctx, request as $1.ToggleObserverModeRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => Porker2ServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => Porker2ServiceBase$messageJson;
}
