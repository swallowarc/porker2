//
//  Generated code. Do not modify.
//  source: porker/v2/service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'resource.pbjson.dart' as $0;

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'user_name', '3': 1, '4': 1, '5': 9, '10': 'userName'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGwoJdXNlcl9uYW1lGAEgASgJUgh1c2VyTmFtZQ==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIUCgV0b2tlbhgCIAEoCV'
    'IFdG9rZW4=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert.base64Decode(
    'Cg5Mb2dvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use createRoomRequestDescriptor instead')
const CreateRoomRequest$json = {
  '1': 'CreateRoomRequest',
};

/// Descriptor for `CreateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSb29tUmVxdWVzdA==');

@$core.Deprecated('Use createRoomResponseDescriptor instead')
const CreateRoomResponse$json = {
  '1': 'CreateRoomResponse',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `CreateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVSb29tUmVzcG9uc2USFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlk');

@$core.Deprecated('Use joinRoomRequestDescriptor instead')
const JoinRoomRequest$json = {
  '1': 'JoinRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `JoinRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomRequestDescriptor = $convert.base64Decode(
    'Cg9Kb2luUm9vbVJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlk');

@$core.Deprecated('Use joinRoomResponseDescriptor instead')
const JoinRoomResponse$json = {
  '1': 'JoinRoomResponse',
  '2': [
    {'1': 'condition', '3': 1, '4': 1, '5': 11, '6': '.porker.v2.RoomCondition', '10': 'condition'},
  ],
};

/// Descriptor for `JoinRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomResponseDescriptor = $convert.base64Decode(
    'ChBKb2luUm9vbVJlc3BvbnNlEjYKCWNvbmRpdGlvbhgBIAEoCzIYLnBvcmtlci52Mi5Sb29tQ2'
    '9uZGl0aW9uUgljb25kaXRpb24=');

@$core.Deprecated('Use leaveRoomRequestDescriptor instead')
const LeaveRoomRequest$json = {
  '1': 'LeaveRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `LeaveRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveRoomRequestDescriptor = $convert.base64Decode(
    'ChBMZWF2ZVJvb21SZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZA==');

@$core.Deprecated('Use leaveRoomResponseDescriptor instead')
const LeaveRoomResponse$json = {
  '1': 'LeaveRoomResponse',
};

/// Descriptor for `LeaveRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveRoomResponseDescriptor = $convert.base64Decode(
    'ChFMZWF2ZVJvb21SZXNwb25zZQ==');

@$core.Deprecated('Use castVoteRequestDescriptor instead')
const CastVoteRequest$json = {
  '1': 'CastVoteRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'ballot', '3': 2, '4': 1, '5': 11, '6': '.porker.v2.Ballot', '10': 'ballot'},
  ],
};

/// Descriptor for `CastVoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castVoteRequestDescriptor = $convert.base64Decode(
    'Cg9DYXN0Vm90ZVJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEikKBmJhbGxvdBgCIA'
    'EoCzIRLnBvcmtlci52Mi5CYWxsb3RSBmJhbGxvdA==');

@$core.Deprecated('Use castVoteResponseDescriptor instead')
const CastVoteResponse$json = {
  '1': 'CastVoteResponse',
};

/// Descriptor for `CastVoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castVoteResponseDescriptor = $convert.base64Decode(
    'ChBDYXN0Vm90ZVJlc3BvbnNl');

@$core.Deprecated('Use resetVotesRequestDescriptor instead')
const ResetVotesRequest$json = {
  '1': 'ResetVotesRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `ResetVotesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetVotesRequestDescriptor = $convert.base64Decode(
    'ChFSZXNldFZvdGVzUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQ=');

@$core.Deprecated('Use resetVotesResponseDescriptor instead')
const ResetVotesResponse$json = {
  '1': 'ResetVotesResponse',
};

/// Descriptor for `ResetVotesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetVotesResponseDescriptor = $convert.base64Decode(
    'ChJSZXNldFZvdGVzUmVzcG9uc2U=');

@$core.Deprecated('Use showVotesRequestDescriptor instead')
const ShowVotesRequest$json = {
  '1': 'ShowVotesRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `ShowVotesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List showVotesRequestDescriptor = $convert.base64Decode(
    'ChBTaG93Vm90ZXNSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZA==');

@$core.Deprecated('Use showVotesResponseDescriptor instead')
const ShowVotesResponse$json = {
  '1': 'ShowVotesResponse',
};

/// Descriptor for `ShowVotesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List showVotesResponseDescriptor = $convert.base64Decode(
    'ChFTaG93Vm90ZXNSZXNwb25zZQ==');

@$core.Deprecated('Use kickUserRequestDescriptor instead')
const KickUserRequest$json = {
  '1': 'KickUserRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'target_user_id', '3': 2, '4': 1, '5': 9, '10': 'targetUserId'},
  ],
};

/// Descriptor for `KickUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickUserRequestDescriptor = $convert.base64Decode(
    'Cg9LaWNrVXNlclJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEiQKDnRhcmdldF91c2'
    'VyX2lkGAIgASgJUgx0YXJnZXRVc2VySWQ=');

@$core.Deprecated('Use kickUserResponseDescriptor instead')
const KickUserResponse$json = {
  '1': 'KickUserResponse',
};

/// Descriptor for `KickUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickUserResponseDescriptor = $convert.base64Decode(
    'ChBLaWNrVXNlclJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> Porker2ServiceBase$json = {
  '1': 'Porker2Service',
  '2': [
    {'1': 'Login', '2': '.porker.v2.LoginRequest', '3': '.porker.v2.LoginResponse'},
    {'1': 'Logout', '2': '.porker.v2.LogoutRequest', '3': '.porker.v2.LogoutResponse'},
    {'1': 'KickUser', '2': '.porker.v2.KickUserRequest', '3': '.porker.v2.KickUserResponse'},
    {'1': 'CreateRoom', '2': '.porker.v2.CreateRoomRequest', '3': '.porker.v2.CreateRoomResponse'},
    {'1': 'JoinRoom', '2': '.porker.v2.JoinRoomRequest', '3': '.porker.v2.JoinRoomResponse', '6': true},
    {'1': 'LeaveRoom', '2': '.porker.v2.LeaveRoomRequest', '3': '.porker.v2.LeaveRoomResponse'},
    {'1': 'CastVote', '2': '.porker.v2.CastVoteRequest', '3': '.porker.v2.CastVoteResponse'},
    {'1': 'ShowVotes', '2': '.porker.v2.ShowVotesRequest', '3': '.porker.v2.ShowVotesResponse'},
    {'1': 'ResetVotes', '2': '.porker.v2.ResetVotesRequest', '3': '.porker.v2.ResetVotesResponse'},
  ],
};

@$core.Deprecated('Use porker2ServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> Porker2ServiceBase$messageJson = {
  '.porker.v2.LoginRequest': LoginRequest$json,
  '.porker.v2.LoginResponse': LoginResponse$json,
  '.porker.v2.LogoutRequest': LogoutRequest$json,
  '.porker.v2.LogoutResponse': LogoutResponse$json,
  '.porker.v2.KickUserRequest': KickUserRequest$json,
  '.porker.v2.KickUserResponse': KickUserResponse$json,
  '.porker.v2.CreateRoomRequest': CreateRoomRequest$json,
  '.porker.v2.CreateRoomResponse': CreateRoomResponse$json,
  '.porker.v2.JoinRoomRequest': JoinRoomRequest$json,
  '.porker.v2.JoinRoomResponse': JoinRoomResponse$json,
  '.porker.v2.RoomCondition': $0.RoomCondition$json,
  '.porker.v2.Ballot': $0.Ballot$json,
  '.porker.v2.LeaveRoomRequest': LeaveRoomRequest$json,
  '.porker.v2.LeaveRoomResponse': LeaveRoomResponse$json,
  '.porker.v2.CastVoteRequest': CastVoteRequest$json,
  '.porker.v2.CastVoteResponse': CastVoteResponse$json,
  '.porker.v2.ShowVotesRequest': ShowVotesRequest$json,
  '.porker.v2.ShowVotesResponse': ShowVotesResponse$json,
  '.porker.v2.ResetVotesRequest': ResetVotesRequest$json,
  '.porker.v2.ResetVotesResponse': ResetVotesResponse$json,
};

/// Descriptor for `Porker2Service`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List porker2ServiceDescriptor = $convert.base64Decode(
    'Cg5Qb3JrZXIyU2VydmljZRI6CgVMb2dpbhIXLnBvcmtlci52Mi5Mb2dpblJlcXVlc3QaGC5wb3'
    'JrZXIudjIuTG9naW5SZXNwb25zZRI9CgZMb2dvdXQSGC5wb3JrZXIudjIuTG9nb3V0UmVxdWVz'
    'dBoZLnBvcmtlci52Mi5Mb2dvdXRSZXNwb25zZRJDCghLaWNrVXNlchIaLnBvcmtlci52Mi5LaW'
    'NrVXNlclJlcXVlc3QaGy5wb3JrZXIudjIuS2lja1VzZXJSZXNwb25zZRJJCgpDcmVhdGVSb29t'
    'EhwucG9ya2VyLnYyLkNyZWF0ZVJvb21SZXF1ZXN0Gh0ucG9ya2VyLnYyLkNyZWF0ZVJvb21SZX'
    'Nwb25zZRJFCghKb2luUm9vbRIaLnBvcmtlci52Mi5Kb2luUm9vbVJlcXVlc3QaGy5wb3JrZXIu'
    'djIuSm9pblJvb21SZXNwb25zZTABEkYKCUxlYXZlUm9vbRIbLnBvcmtlci52Mi5MZWF2ZVJvb2'
    '1SZXF1ZXN0GhwucG9ya2VyLnYyLkxlYXZlUm9vbVJlc3BvbnNlEkMKCENhc3RWb3RlEhoucG9y'
    'a2VyLnYyLkNhc3RWb3RlUmVxdWVzdBobLnBvcmtlci52Mi5DYXN0Vm90ZVJlc3BvbnNlEkYKCV'
    'Nob3dWb3RlcxIbLnBvcmtlci52Mi5TaG93Vm90ZXNSZXF1ZXN0GhwucG9ya2VyLnYyLlNob3dW'
    'b3Rlc1Jlc3BvbnNlEkkKClJlc2V0Vm90ZXMSHC5wb3JrZXIudjIuUmVzZXRWb3Rlc1JlcXVlc3'
    'QaHS5wb3JrZXIudjIuUmVzZXRWb3Rlc1Jlc3BvbnNl');

