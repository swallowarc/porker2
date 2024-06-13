//
//  Generated code. Do not modify.
//  source: porker/v2/service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $1;
import 'service.pbjson.dart';

export 'service.pb.dart';

abstract class Porker2ServiceBase extends $pb.GeneratedService {
  $async.Future<$1.LoginResponse> login($pb.ServerContext ctx, $1.LoginRequest request);
  $async.Future<$1.LogoutResponse> logout($pb.ServerContext ctx, $1.LogoutRequest request);
  $async.Future<$1.CreateRoomResponse> createRoom($pb.ServerContext ctx, $1.CreateRoomRequest request);
  $async.Future<$1.JoinRoomResponse> joinRoom($pb.ServerContext ctx, $1.JoinRoomRequest request);
  $async.Future<$1.LeaveRoomResponse> leaveRoom($pb.ServerContext ctx, $1.LeaveRoomRequest request);
  $async.Future<$1.CastVoteResponse> castVote($pb.ServerContext ctx, $1.CastVoteRequest request);
  $async.Future<$1.ShowVotesResponse> showVotes($pb.ServerContext ctx, $1.ShowVotesRequest request);
  $async.Future<$1.ResetVotesResponse> resetVotes($pb.ServerContext ctx, $1.ResetVotesRequest request);
  $async.Future<$1.KickUserResponse> kickUser($pb.ServerContext ctx, $1.KickUserRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login': return $1.LoginRequest();
      case 'Logout': return $1.LogoutRequest();
      case 'CreateRoom': return $1.CreateRoomRequest();
      case 'JoinRoom': return $1.JoinRoomRequest();
      case 'LeaveRoom': return $1.LeaveRoomRequest();
      case 'CastVote': return $1.CastVoteRequest();
      case 'ShowVotes': return $1.ShowVotesRequest();
      case 'ResetVotes': return $1.ResetVotesRequest();
      case 'KickUser': return $1.KickUserRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login': return this.login(ctx, request as $1.LoginRequest);
      case 'Logout': return this.logout(ctx, request as $1.LogoutRequest);
      case 'CreateRoom': return this.createRoom(ctx, request as $1.CreateRoomRequest);
      case 'JoinRoom': return this.joinRoom(ctx, request as $1.JoinRoomRequest);
      case 'LeaveRoom': return this.leaveRoom(ctx, request as $1.LeaveRoomRequest);
      case 'CastVote': return this.castVote(ctx, request as $1.CastVoteRequest);
      case 'ShowVotes': return this.showVotes(ctx, request as $1.ShowVotesRequest);
      case 'ResetVotes': return this.resetVotes(ctx, request as $1.ResetVotesRequest);
      case 'KickUser': return this.kickUser(ctx, request as $1.KickUserRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => Porker2ServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => Porker2ServiceBase$messageJson;
}

