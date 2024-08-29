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
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use verifyUserRequestDescriptor instead')
const VerifyUserRequest$json = {
  '1': 'VerifyUserRequest',
};

/// Descriptor for `VerifyUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyUserRequestDescriptor = $convert.base64Decode(
    'ChFWZXJpZnlVc2VyUmVxdWVzdA==');

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
final $typed_data.Uint8List checkRoomResponseDescriptor = $convert.base64Decode(
    'ChFDaGVja1Jvb21SZXNwb25zZQ==');

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
    {'1': 'point', '3': 2, '4': 1, '5': 14, '6': '.porker.v2.Point', '10': 'point'},
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

@$core.Deprecated('Use updateRoomRequestDescriptor instead')
const UpdateRoomRequest$json = {
  '1': 'UpdateRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'auto_open', '3': 2, '4': 1, '5': 8, '10': 'autoOpen'},
  ],
};

/// Descriptor for `UpdateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSb29tUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSGwoJYXV0b19vcG'
    'VuGAIgASgIUghhdXRvT3Blbg==');

@$core.Deprecated('Use updateRoomResponseDescriptor instead')
const UpdateRoomResponse$json = {
  '1': 'UpdateRoomResponse',
};

/// Descriptor for `UpdateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVSb29tUmVzcG9uc2U=');

