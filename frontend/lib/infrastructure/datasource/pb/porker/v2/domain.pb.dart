// This is a generated file - do not edit.
//
// Generated from porker/v2/domain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'domain.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'domain.pbenum.dart';

class Ballot extends $pb.GeneratedMessage {
  factory Ballot({
    $core.String? userName,
    $core.String? userId,
    Point? point,
    UserRole? role,
  }) {
    final result = create();
    if (userName != null) result.userName = userName;
    if (userId != null) result.userId = userId;
    if (point != null) result.point = point;
    if (role != null) result.role = role;
    return result;
  }

  Ballot._();

  factory Ballot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ballot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ballot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aE<Point>(3, _omitFieldNames ? '' : 'point', enumValues: Point.values)
    ..aE<UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: UserRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ballot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ballot copyWith(void Function(Ballot) updates) =>
      super.copyWith((message) => updates(message as Ballot)) as Ballot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ballot create() => Ballot._();
  @$core.override
  Ballot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ballot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ballot>(create);
  static Ballot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  Point get point => $_getN(2);
  @$pb.TagNumber(3)
  set point(Point value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoint() => $_clearField(3);

  @$pb.TagNumber(4)
  UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role(UserRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);
}

class RoomCondition extends $pb.GeneratedMessage {
  factory RoomCondition({
    $core.String? roomId,
    $core.String? adminUserId,
    VoteState? voteState,
    $core.Iterable<Ballot>? ballots,
    $core.bool? autoOpen,
    DisplayMode? displayMode,
    $core.int? observerCount,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (adminUserId != null) result.adminUserId = adminUserId;
    if (voteState != null) result.voteState = voteState;
    if (ballots != null) result.ballots.addAll(ballots);
    if (autoOpen != null) result.autoOpen = autoOpen;
    if (displayMode != null) result.displayMode = displayMode;
    if (observerCount != null) result.observerCount = observerCount;
    return result;
  }

  RoomCondition._();

  factory RoomCondition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomCondition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomCondition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'adminUserId')
    ..aE<VoteState>(3, _omitFieldNames ? '' : 'voteState',
        enumValues: VoteState.values)
    ..pPM<Ballot>(4, _omitFieldNames ? '' : 'ballots',
        subBuilder: Ballot.create)
    ..aOB(5, _omitFieldNames ? '' : 'autoOpen')
    ..aE<DisplayMode>(6, _omitFieldNames ? '' : 'displayMode',
        enumValues: DisplayMode.values)
    ..aI(7, _omitFieldNames ? '' : 'observerCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCondition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCondition copyWith(void Function(RoomCondition) updates) =>
      super.copyWith((message) => updates(message as RoomCondition))
          as RoomCondition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomCondition create() => RoomCondition._();
  @$core.override
  RoomCondition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomCondition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomCondition>(create);
  static RoomCondition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get adminUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set adminUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdminUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  VoteState get voteState => $_getN(2);
  @$pb.TagNumber(3)
  set voteState(VoteState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVoteState() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoteState() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<Ballot> get ballots => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get autoOpen => $_getBF(4);
  @$pb.TagNumber(5)
  set autoOpen($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAutoOpen() => $_has(4);
  @$pb.TagNumber(5)
  void clearAutoOpen() => $_clearField(5);

  @$pb.TagNumber(6)
  DisplayMode get displayMode => $_getN(5);
  @$pb.TagNumber(6)
  set displayMode(DisplayMode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayMode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get observerCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set observerCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasObserverCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearObserverCount() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
