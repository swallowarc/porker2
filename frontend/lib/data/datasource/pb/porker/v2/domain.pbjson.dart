//
//  Generated code. Do not modify.
//  source: porker/v2/domain.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use violationDescriptor instead')
const Violation$json = {
  '1': 'Violation',
  '2': [
    {'1': 'VIOLATION_UNSPECIFIED', '2': 0},
  ],
};

/// Descriptor for `Violation`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List violationDescriptor = $convert.base64Decode(
    'CglWaW9sYXRpb24SGQoVVklPTEFUSU9OX1VOU1BFQ0lGSUVEEAA=');

@$core.Deprecated('Use voteStateDescriptor instead')
const VoteState$json = {
  '1': 'VoteState',
  '2': [
    {'1': 'VOTE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'VOTE_STATE_HIDE', '2': 1},
    {'1': 'VOTE_STATE_OPEN', '2': 2},
  ],
};

/// Descriptor for `VoteState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List voteStateDescriptor = $convert.base64Decode(
    'CglWb3RlU3RhdGUSGgoWVk9URV9TVEFURV9VTlNQRUNJRklFRBAAEhMKD1ZPVEVfU1RBVEVfSE'
    'lERRABEhMKD1ZPVEVfU1RBVEVfT1BFThAC');

@$core.Deprecated('Use pointDescriptor instead')
const Point$json = {
  '1': 'Point',
  '2': [
    {'1': 'POINT_UNSPECIFIED', '2': 0},
    {'1': 'POINT_0', '2': 1},
    {'1': 'POINT_0_5', '2': 2},
    {'1': 'POINT_1', '2': 3},
    {'1': 'POINT_2', '2': 4},
    {'1': 'POINT_3', '2': 5},
    {'1': 'POINT_5', '2': 6},
    {'1': 'POINT_8', '2': 7},
    {'1': 'POINT_13', '2': 8},
    {'1': 'POINT_21', '2': 9},
    {'1': 'POINT_COFFEE', '2': 100},
    {'1': 'POINT_QUESTION', '2': 101},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pointDescriptor = $convert.base64Decode(
    'CgVQb2ludBIVChFQT0lOVF9VTlNQRUNJRklFRBAAEgsKB1BPSU5UXzAQARINCglQT0lOVF8wXz'
    'UQAhILCgdQT0lOVF8xEAMSCwoHUE9JTlRfMhAEEgsKB1BPSU5UXzMQBRILCgdQT0lOVF81EAYS'
    'CwoHUE9JTlRfOBAHEgwKCFBPSU5UXzEzEAgSDAoIUE9JTlRfMjEQCRIQCgxQT0lOVF9DT0ZGRU'
    'UQZBISCg5QT0lOVF9RVUVTVElPThBl');

@$core.Deprecated('Use ballotDescriptor instead')
const Ballot$json = {
  '1': 'Ballot',
  '2': [
    {'1': 'user_name', '3': 1, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'point', '3': 3, '4': 1, '5': 14, '6': '.porker.v2.Point', '10': 'point'},
  ],
};

/// Descriptor for `Ballot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ballotDescriptor = $convert.base64Decode(
    'CgZCYWxsb3QSGwoJdXNlcl9uYW1lGAEgASgJUgh1c2VyTmFtZRIXCgd1c2VyX2lkGAIgASgJUg'
    'Z1c2VySWQSJgoFcG9pbnQYAyABKA4yEC5wb3JrZXIudjIuUG9pbnRSBXBvaW50');

@$core.Deprecated('Use roomConditionDescriptor instead')
const RoomCondition$json = {
  '1': 'RoomCondition',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'admin_user_id', '3': 2, '4': 1, '5': 9, '10': 'adminUserId'},
    {'1': 'vote_state', '3': 3, '4': 1, '5': 14, '6': '.porker.v2.VoteState', '10': 'voteState'},
    {'1': 'ballots', '3': 4, '4': 3, '5': 11, '6': '.porker.v2.Ballot', '10': 'ballots'},
    {'1': 'auto_open', '3': 5, '4': 1, '5': 8, '10': 'autoOpen'},
  ],
};

/// Descriptor for `RoomCondition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomConditionDescriptor = $convert.base64Decode(
    'Cg1Sb29tQ29uZGl0aW9uEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIiCg1hZG1pbl91c2VyX2'
    'lkGAIgASgJUgthZG1pblVzZXJJZBIzCgp2b3RlX3N0YXRlGAMgASgOMhQucG9ya2VyLnYyLlZv'
    'dGVTdGF0ZVIJdm90ZVN0YXRlEisKB2JhbGxvdHMYBCADKAsyES5wb3JrZXIudjIuQmFsbG90Ug'
    'diYWxsb3RzEhsKCWF1dG9fb3BlbhgFIAEoCFIIYXV0b09wZW4=');

