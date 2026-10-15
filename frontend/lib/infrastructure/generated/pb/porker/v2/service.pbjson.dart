// This is a generated file - do not edit.
//
// Generated from porker/v2/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'domain.pbjson.dart' as $0;

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
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert
    .base64Decode('Cg1Mb2dpblJlc3BvbnNlEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use verifyUserRequestDescriptor instead')
const VerifyUserRequest$json = {
  '1': 'VerifyUserRequest',
};

/// Descriptor for `VerifyUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyUserRequestDescriptor =
    $convert.base64Decode('ChFWZXJpZnlVc2VyUmVxdWVzdA==');

@$core.Deprecated('Use verifyUserResponseDescriptor instead')
const VerifyUserResponse$json = {
  '1': 'VerifyUserResponse',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 2, '4': 1, '5': 9, '10': 'userName'},
  ],
};

/// Descriptor for `VerifyUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyUserResponseDescriptor = $convert.base64Decode(
    'ChJWZXJpZnlVc2VyUmVzcG9uc2USFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhsKCXVzZXJfbm'
    'FtZRgCIAEoCVIIdXNlck5hbWU=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor =
    $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor =
    $convert.base64Decode('Cg5Mb2dvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use createRoomRequestDescriptor instead')
const CreateRoomRequest$json = {
  '1': 'CreateRoomRequest',
};

/// Descriptor for `CreateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomRequestDescriptor =
    $convert.base64Decode('ChFDcmVhdGVSb29tUmVxdWVzdA==');

@$core.Deprecated('Use createRoomResponseDescriptor instead')
const CreateRoomResponse$json = {
  '1': 'CreateRoomResponse',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `CreateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomResponseDescriptor =
    $convert.base64Decode(
        'ChJDcmVhdGVSb29tUmVzcG9uc2USFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlk');

@$core.Deprecated('Use checkRoomRequestDescriptor instead')
const CheckRoomRequest$json = {
  '1': 'CheckRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `CheckRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRoomRequestDescriptor = $convert.base64Decode(
    'ChBDaGVja1Jvb21SZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZA==');

@$core.Deprecated('Use checkRoomResponseDescriptor instead')
const CheckRoomResponse$json = {
  '1': 'CheckRoomResponse',
};

/// Descriptor for `CheckRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRoomResponseDescriptor =
    $convert.base64Decode('ChFDaGVja1Jvb21SZXNwb25zZQ==');

@$core.Deprecated('Use joinRoomRequestDescriptor instead')
const JoinRoomRequest$json = {
  '1': 'JoinRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `JoinRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomRequestDescriptor = $convert
    .base64Decode('Cg9Kb2luUm9vbVJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlk');

@$core.Deprecated('Use joinRoomResponseDescriptor instead')
const JoinRoomResponse$json = {
  '1': 'JoinRoomResponse',
  '2': [
    {
      '1': 'condition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.porker.v2.RoomCondition',
      '10': 'condition'
    },
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
final $typed_data.Uint8List leaveRoomResponseDescriptor =
    $convert.base64Decode('ChFMZWF2ZVJvb21SZXNwb25zZQ==');

@$core.Deprecated('Use castVoteRequestDescriptor instead')
const CastVoteRequest$json = {
  '1': 'CastVoteRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'point',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.porker.v2.Point',
      '10': 'point'
    },
  ],
};

/// Descriptor for `CastVoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castVoteRequestDescriptor = $convert.base64Decode(
    'Cg9DYXN0Vm90ZVJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEiYKBXBvaW50GAIgAS'
    'gOMhAucG9ya2VyLnYyLlBvaW50UgVwb2ludA==');

@$core.Deprecated('Use castVoteResponseDescriptor instead')
const CastVoteResponse$json = {
  '1': 'CastVoteResponse',
};

/// Descriptor for `CastVoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castVoteResponseDescriptor =
    $convert.base64Decode('ChBDYXN0Vm90ZVJlc3BvbnNl');

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
final $typed_data.Uint8List resetVotesResponseDescriptor =
    $convert.base64Decode('ChJSZXNldFZvdGVzUmVzcG9uc2U=');

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
final $typed_data.Uint8List showVotesResponseDescriptor =
    $convert.base64Decode('ChFTaG93Vm90ZXNSZXNwb25zZQ==');

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
final $typed_data.Uint8List kickUserResponseDescriptor =
    $convert.base64Decode('ChBLaWNrVXNlclJlc3BvbnNl');

@$core.Deprecated('Use updateRoomRequestDescriptor instead')
const UpdateRoomRequest$json = {
  '1': 'UpdateRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'auto_open', '3': 2, '4': 1, '5': 8, '10': 'autoOpen'},
    {
      '1': 'display_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.porker.v2.DisplayMode',
      '10': 'displayMode'
    },
  ],
};

/// Descriptor for `UpdateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSb29tUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSGwoJYXV0b19vcG'
    'VuGAIgASgIUghhdXRvT3BlbhI5CgxkaXNwbGF5X21vZGUYAyABKA4yFi5wb3JrZXIudjIuRGlz'
    'cGxheU1vZGVSC2Rpc3BsYXlNb2Rl');

@$core.Deprecated('Use updateRoomResponseDescriptor instead')
const UpdateRoomResponse$json = {
  '1': 'UpdateRoomResponse',
};

/// Descriptor for `UpdateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomResponseDescriptor =
    $convert.base64Decode('ChJVcGRhdGVSb29tUmVzcG9uc2U=');

@$core.Deprecated('Use toggleObserverModeRequestDescriptor instead')
const ToggleObserverModeRequest$json = {
  '1': 'ToggleObserverModeRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'is_observer', '3': 2, '4': 1, '5': 8, '10': 'isObserver'},
  ],
};

/// Descriptor for `ToggleObserverModeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleObserverModeRequestDescriptor =
    $convert.base64Decode(
        'ChlUb2dnbGVPYnNlcnZlck1vZGVSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIfCg'
        'tpc19vYnNlcnZlchgCIAEoCFIKaXNPYnNlcnZlcg==');

@$core.Deprecated('Use toggleObserverModeResponseDescriptor instead')
const ToggleObserverModeResponse$json = {
  '1': 'ToggleObserverModeResponse',
};

/// Descriptor for `ToggleObserverModeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleObserverModeResponseDescriptor =
    $convert.base64Decode('ChpUb2dnbGVPYnNlcnZlck1vZGVSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> Porker2ServiceBase$json = {
  '1': 'Porker2Service',
  '2': [
    {
      '1': 'Login',
      '2': '.porker.v2.LoginRequest',
      '3': '.porker.v2.LoginResponse'
    },
    {
      '1': 'Logout',
      '2': '.porker.v2.LogoutRequest',
      '3': '.porker.v2.LogoutResponse'
    },
    {
      '1': 'VerifyUser',
      '2': '.porker.v2.VerifyUserRequest',
      '3': '.porker.v2.VerifyUserResponse'
    },
    {
      '1': 'CreateRoom',
      '2': '.porker.v2.CreateRoomRequest',
      '3': '.porker.v2.CreateRoomResponse'
    },
    {
      '1': 'CheckRoom',
      '2': '.porker.v2.CheckRoomRequest',
      '3': '.porker.v2.CheckRoomResponse'
    },
    {
      '1': 'JoinRoom',
      '2': '.porker.v2.JoinRoomRequest',
      '3': '.porker.v2.JoinRoomResponse',
      '6': true
    },
    {
      '1': 'LeaveRoom',
      '2': '.porker.v2.LeaveRoomRequest',
      '3': '.porker.v2.LeaveRoomResponse'
    },
    {
      '1': 'CastVote',
      '2': '.porker.v2.CastVoteRequest',
      '3': '.porker.v2.CastVoteResponse'
    },
    {
      '1': 'ShowVotes',
      '2': '.porker.v2.ShowVotesRequest',
      '3': '.porker.v2.ShowVotesResponse'
    },
    {
      '1': 'ResetVotes',
      '2': '.porker.v2.ResetVotesRequest',
      '3': '.porker.v2.ResetVotesResponse'
    },
    {
      '1': 'KickUser',
      '2': '.porker.v2.KickUserRequest',
      '3': '.porker.v2.KickUserResponse'
    },
    {
      '1': 'UpdateRoom',
      '2': '.porker.v2.UpdateRoomRequest',
      '3': '.porker.v2.UpdateRoomResponse'
    },
    {
      '1': 'ToggleObserverMode',
      '2': '.porker.v2.ToggleObserverModeRequest',
      '3': '.porker.v2.ToggleObserverModeResponse'
    },
  ],
};

@$core.Deprecated('Use porker2ServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    Porker2ServiceBase$messageJson = {
  '.porker.v2.LoginRequest': LoginRequest$json,
  '.porker.v2.LoginResponse': LoginResponse$json,
  '.porker.v2.LogoutRequest': LogoutRequest$json,
  '.porker.v2.LogoutResponse': LogoutResponse$json,
  '.porker.v2.VerifyUserRequest': VerifyUserRequest$json,
  '.porker.v2.VerifyUserResponse': VerifyUserResponse$json,
  '.porker.v2.CreateRoomRequest': CreateRoomRequest$json,
  '.porker.v2.CreateRoomResponse': CreateRoomResponse$json,
  '.porker.v2.CheckRoomRequest': CheckRoomRequest$json,
  '.porker.v2.CheckRoomResponse': CheckRoomResponse$json,
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
  '.porker.v2.KickUserRequest': KickUserRequest$json,
  '.porker.v2.KickUserResponse': KickUserResponse$json,
  '.porker.v2.UpdateRoomRequest': UpdateRoomRequest$json,
  '.porker.v2.UpdateRoomResponse': UpdateRoomResponse$json,
  '.porker.v2.ToggleObserverModeRequest': ToggleObserverModeRequest$json,
  '.porker.v2.ToggleObserverModeResponse': ToggleObserverModeResponse$json,
};

/// Descriptor for `Porker2Service`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List porker2ServiceDescriptor = $convert.base64Decode(
    'Cg5Qb3JrZXIyU2VydmljZRI6CgVMb2dpbhIXLnBvcmtlci52Mi5Mb2dpblJlcXVlc3QaGC5wb3'
    'JrZXIudjIuTG9naW5SZXNwb25zZRI9CgZMb2dvdXQSGC5wb3JrZXIudjIuTG9nb3V0UmVxdWVz'
    'dBoZLnBvcmtlci52Mi5Mb2dvdXRSZXNwb25zZRJJCgpWZXJpZnlVc2VyEhwucG9ya2VyLnYyLl'
    'ZlcmlmeVVzZXJSZXF1ZXN0Gh0ucG9ya2VyLnYyLlZlcmlmeVVzZXJSZXNwb25zZRJJCgpDcmVh'
    'dGVSb29tEhwucG9ya2VyLnYyLkNyZWF0ZVJvb21SZXF1ZXN0Gh0ucG9ya2VyLnYyLkNyZWF0ZV'
    'Jvb21SZXNwb25zZRJGCglDaGVja1Jvb20SGy5wb3JrZXIudjIuQ2hlY2tSb29tUmVxdWVzdBoc'
    'LnBvcmtlci52Mi5DaGVja1Jvb21SZXNwb25zZRJFCghKb2luUm9vbRIaLnBvcmtlci52Mi5Kb2'
    'luUm9vbVJlcXVlc3QaGy5wb3JrZXIudjIuSm9pblJvb21SZXNwb25zZTABEkYKCUxlYXZlUm9v'
    'bRIbLnBvcmtlci52Mi5MZWF2ZVJvb21SZXF1ZXN0GhwucG9ya2VyLnYyLkxlYXZlUm9vbVJlc3'
    'BvbnNlEkMKCENhc3RWb3RlEhoucG9ya2VyLnYyLkNhc3RWb3RlUmVxdWVzdBobLnBvcmtlci52'
    'Mi5DYXN0Vm90ZVJlc3BvbnNlEkYKCVNob3dWb3RlcxIbLnBvcmtlci52Mi5TaG93Vm90ZXNSZX'
    'F1ZXN0GhwucG9ya2VyLnYyLlNob3dWb3Rlc1Jlc3BvbnNlEkkKClJlc2V0Vm90ZXMSHC5wb3Jr'
    'ZXIudjIuUmVzZXRWb3Rlc1JlcXVlc3QaHS5wb3JrZXIudjIuUmVzZXRWb3Rlc1Jlc3BvbnNlEk'
    'MKCEtpY2tVc2VyEhoucG9ya2VyLnYyLktpY2tVc2VyUmVxdWVzdBobLnBvcmtlci52Mi5LaWNr'
    'VXNlclJlc3BvbnNlEkkKClVwZGF0ZVJvb20SHC5wb3JrZXIudjIuVXBkYXRlUm9vbVJlcXVlc3'
    'QaHS5wb3JrZXIudjIuVXBkYXRlUm9vbVJlc3BvbnNlEmEKElRvZ2dsZU9ic2VydmVyTW9kZRIk'
    'LnBvcmtlci52Mi5Ub2dnbGVPYnNlcnZlck1vZGVSZXF1ZXN0GiUucG9ya2VyLnYyLlRvZ2dsZU'
    '9ic2VydmVyTW9kZVJlc3BvbnNl');
