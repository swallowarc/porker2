//
//  Generated code. Do not modify.
//  source: porker/v2/domain.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Violation extends $pb.ProtobufEnum {
  static const Violation VIOLATION_UNSPECIFIED = Violation._(0, _omitEnumNames ? '' : 'VIOLATION_UNSPECIFIED');

  static const $core.List<Violation> values = <Violation> [
    VIOLATION_UNSPECIFIED,
  ];

  static final $core.Map<$core.int, Violation> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Violation? valueOf($core.int value) => _byValue[value];

  const Violation._($core.int v, $core.String n) : super(v, n);
}

class UserRole extends $pb.ProtobufEnum {
  static const UserRole USER_ROLE_UNSPECIFIED = UserRole._(0, _omitEnumNames ? '' : 'USER_ROLE_UNSPECIFIED');
  static const UserRole USER_ROLE_VOTER = UserRole._(1, _omitEnumNames ? '' : 'USER_ROLE_VOTER');
  static const UserRole USER_ROLE_OBSERVER = UserRole._(2, _omitEnumNames ? '' : 'USER_ROLE_OBSERVER');

  static const $core.List<UserRole> values = <UserRole> [
    USER_ROLE_UNSPECIFIED,
    USER_ROLE_VOTER,
    USER_ROLE_OBSERVER,
  ];

  static final $core.Map<$core.int, UserRole> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserRole? valueOf($core.int value) => _byValue[value];

  const UserRole._($core.int v, $core.String n) : super(v, n);
}

class VoteState extends $pb.ProtobufEnum {
  static const VoteState VOTE_STATE_UNSPECIFIED = VoteState._(0, _omitEnumNames ? '' : 'VOTE_STATE_UNSPECIFIED');
  static const VoteState VOTE_STATE_HIDE = VoteState._(1, _omitEnumNames ? '' : 'VOTE_STATE_HIDE');
  static const VoteState VOTE_STATE_OPEN = VoteState._(2, _omitEnumNames ? '' : 'VOTE_STATE_OPEN');

  static const $core.List<VoteState> values = <VoteState> [
    VOTE_STATE_UNSPECIFIED,
    VOTE_STATE_HIDE,
    VOTE_STATE_OPEN,
  ];

  static final $core.Map<$core.int, VoteState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VoteState? valueOf($core.int value) => _byValue[value];

  const VoteState._($core.int v, $core.String n) : super(v, n);
}

class DisplayMode extends $pb.ProtobufEnum {
  static const DisplayMode DISPLAY_MODE_UNSPECIFIED = DisplayMode._(0, _omitEnumNames ? '' : 'DISPLAY_MODE_UNSPECIFIED');
  static const DisplayMode DISPLAY_MODE_POINT = DisplayMode._(1, _omitEnumNames ? '' : 'DISPLAY_MODE_POINT');
  static const DisplayMode DISPLAY_MODE_TSHIRT = DisplayMode._(2, _omitEnumNames ? '' : 'DISPLAY_MODE_TSHIRT');

  static const $core.List<DisplayMode> values = <DisplayMode> [
    DISPLAY_MODE_UNSPECIFIED,
    DISPLAY_MODE_POINT,
    DISPLAY_MODE_TSHIRT,
  ];

  static final $core.Map<$core.int, DisplayMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DisplayMode? valueOf($core.int value) => _byValue[value];

  const DisplayMode._($core.int v, $core.String n) : super(v, n);
}

class Point extends $pb.ProtobufEnum {
  static const Point POINT_UNSPECIFIED = Point._(0, _omitEnumNames ? '' : 'POINT_UNSPECIFIED');
  static const Point POINT_0 = Point._(1, _omitEnumNames ? '' : 'POINT_0');
  static const Point POINT_0_5 = Point._(2, _omitEnumNames ? '' : 'POINT_0_5');
  static const Point POINT_1 = Point._(3, _omitEnumNames ? '' : 'POINT_1');
  static const Point POINT_2 = Point._(4, _omitEnumNames ? '' : 'POINT_2');
  static const Point POINT_3 = Point._(5, _omitEnumNames ? '' : 'POINT_3');
  static const Point POINT_5 = Point._(6, _omitEnumNames ? '' : 'POINT_5');
  static const Point POINT_8 = Point._(7, _omitEnumNames ? '' : 'POINT_8');
  static const Point POINT_13 = Point._(8, _omitEnumNames ? '' : 'POINT_13');
  static const Point POINT_21 = Point._(9, _omitEnumNames ? '' : 'POINT_21');
  static const Point POINT_COFFEE = Point._(100, _omitEnumNames ? '' : 'POINT_COFFEE');
  static const Point POINT_QUESTION = Point._(101, _omitEnumNames ? '' : 'POINT_QUESTION');

  static const $core.List<Point> values = <Point> [
    POINT_UNSPECIFIED,
    POINT_0,
    POINT_0_5,
    POINT_1,
    POINT_2,
    POINT_3,
    POINT_5,
    POINT_8,
    POINT_13,
    POINT_21,
    POINT_COFFEE,
    POINT_QUESTION,
  ];

  static final $core.Map<$core.int, Point> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Point? valueOf($core.int value) => _byValue[value];

  const Point._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
