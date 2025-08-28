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

import 'domain.pbenum.dart';

export 'domain.pbenum.dart';

class Ballot extends $pb.GeneratedMessage {
  factory Ballot({
    $core.String? userName,
    $core.String? userId,
    Point? point,
  }) {
    final $result = create();
    if (userName != null) {
      $result.userName = userName;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    if (point != null) {
      $result.point = point;
    }
    return $result;
  }
  Ballot._() : super();
  factory Ballot.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Ballot.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Ballot', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..e<Point>(3, _omitFieldNames ? '' : 'point', $pb.PbFieldType.OE, defaultOrMaker: Point.POINT_UNSPECIFIED, valueOf: Point.valueOf, enumValues: Point.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Ballot clone() => Ballot()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Ballot copyWith(void Function(Ballot) updates) => super.copyWith((message) => updates(message as Ballot)) as Ballot;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ballot create() => Ballot._();
  Ballot createEmptyInstance() => create();
  static $pb.PbList<Ballot> createRepeated() => $pb.PbList<Ballot>();
  @$core.pragma('dart2js:noInline')
  static Ballot getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ballot>(create);
  static Ballot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  Point get point => $_getN(2);
  @$pb.TagNumber(3)
  set point(Point v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoint() => clearField(3);
}

class RoomCondition extends $pb.GeneratedMessage {
  factory RoomCondition({
    $core.String? roomId,
    $core.String? adminUserId,
    VoteState? voteState,
    $core.Iterable<Ballot>? ballots,
    $core.bool? autoOpen,
    DisplayMode? displayMode,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    if (adminUserId != null) {
      $result.adminUserId = adminUserId;
    }
    if (voteState != null) {
      $result.voteState = voteState;
    }
    if (ballots != null) {
      $result.ballots.addAll(ballots);
    }
    if (autoOpen != null) {
      $result.autoOpen = autoOpen;
    }
    if (displayMode != null) {
      $result.displayMode = displayMode;
    }
    return $result;
  }
  RoomCondition._() : super();
  factory RoomCondition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomCondition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomCondition', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'adminUserId')
    ..e<VoteState>(3, _omitFieldNames ? '' : 'voteState', $pb.PbFieldType.OE, defaultOrMaker: VoteState.VOTE_STATE_UNSPECIFIED, valueOf: VoteState.valueOf, enumValues: VoteState.values)
    ..pc<Ballot>(4, _omitFieldNames ? '' : 'ballots', $pb.PbFieldType.PM, subBuilder: Ballot.create)
    ..aOB(5, _omitFieldNames ? '' : 'autoOpen')
    ..e<DisplayMode>(6, _omitFieldNames ? '' : 'displayMode', $pb.PbFieldType.OE, defaultOrMaker: DisplayMode.DISPLAY_MODE_UNSPECIFIED, valueOf: DisplayMode.valueOf, enumValues: DisplayMode.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomCondition clone() => RoomCondition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomCondition copyWith(void Function(RoomCondition) updates) => super.copyWith((message) => updates(message as RoomCondition)) as RoomCondition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomCondition create() => RoomCondition._();
  RoomCondition createEmptyInstance() => create();
  static $pb.PbList<RoomCondition> createRepeated() => $pb.PbList<RoomCondition>();
  @$core.pragma('dart2js:noInline')
  static RoomCondition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomCondition>(create);
  static RoomCondition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get adminUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set adminUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAdminUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminUserId() => clearField(2);

  @$pb.TagNumber(3)
  VoteState get voteState => $_getN(2);
  @$pb.TagNumber(3)
  set voteState(VoteState v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVoteState() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoteState() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<Ballot> get ballots => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get autoOpen => $_getBF(4);
  @$pb.TagNumber(5)
  set autoOpen($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAutoOpen() => $_has(4);
  @$pb.TagNumber(5)
  void clearAutoOpen() => clearField(5);

  @$pb.TagNumber(6)
  DisplayMode get displayMode => $_getN(5);
  @$pb.TagNumber(6)
  set displayMode(DisplayMode v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasDisplayMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayMode() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
