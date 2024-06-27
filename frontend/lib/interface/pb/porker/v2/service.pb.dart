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

import 'package:protobuf/protobuf.dart' as $pb;

import 'resource.pb.dart' as $0;

///  Login ログイン
///  ログインが成功した場合、tokenを返す。
///
///  Errors:
///  - InvalidArgument:
///    - ログイン名が未指定、またはフォーマット不正
///  - AlreadyExists:
///    - 既に同じIDでログイン済み
class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? userName,
  }) {
    final $result = create();
    if (userName != null) {
      $result.userName = userName;
    }
    return $result;
  }
  LoginRequest._() : super();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => clearField(1);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? token,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  LoginResponse._() : super();
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() => $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
}

///  Logout ログアウト
///  ログアウトする。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => create();
  LogoutRequest._() : super();
  factory LogoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LogoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LogoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LogoutRequest clone() => LogoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) => super.copyWith((message) => updates(message as LogoutRequest)) as LogoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutRequest create() => LogoutRequest._();
  LogoutRequest createEmptyInstance() => create();
  static $pb.PbList<LogoutRequest> createRepeated() => $pb.PbList<LogoutRequest>();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(create);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse() => create();
  LogoutResponse._() : super();
  factory LogoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LogoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LogoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LogoutResponse clone() => LogoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) => super.copyWith((message) => updates(message as LogoutResponse)) as LogoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  LogoutResponse createEmptyInstance() => create();
  static $pb.PbList<LogoutResponse> createRepeated() => $pb.PbList<LogoutResponse>();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;
}

///  CreateRoom roomを作成する。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest() => create();
  CreateRoomRequest._() : super();
  factory CreateRoomRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRoomRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoomRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRoomRequest clone() => CreateRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRoomRequest copyWith(void Function(CreateRoomRequest) updates) => super.copyWith((message) => updates(message as CreateRoomRequest)) as CreateRoomRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest create() => CreateRoomRequest._();
  CreateRoomRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRoomRequest> createRepeated() => $pb.PbList<CreateRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(create);
  static CreateRoomRequest? _defaultInstance;
}

class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    $core.String? roomId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    return $result;
  }
  CreateRoomResponse._() : super();
  factory CreateRoomResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRoomResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoomResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRoomResponse clone() => CreateRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRoomResponse copyWith(void Function(CreateRoomResponse) updates) => super.copyWith((message) => updates(message as CreateRoomResponse)) as CreateRoomResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse create() => CreateRoomResponse._();
  CreateRoomResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRoomResponse> createRepeated() => $pb.PbList<CreateRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(create);
  static CreateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);
}

///  JoinRoom roomに参加する。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
///  - NotFound:
///    - roomが存在しない
///  - FailedPrecondition:
///    - roomが満員
class JoinRoomRequest extends $pb.GeneratedMessage {
  factory JoinRoomRequest({
    $core.String? roomId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    return $result;
  }
  JoinRoomRequest._() : super();
  factory JoinRoomRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRoomRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRoomRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRoomRequest clone() => JoinRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRoomRequest copyWith(void Function(JoinRoomRequest) updates) => super.copyWith((message) => updates(message as JoinRoomRequest)) as JoinRoomRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest create() => JoinRoomRequest._();
  JoinRoomRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRoomRequest> createRepeated() => $pb.PbList<JoinRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(create);
  static JoinRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);
}

class JoinRoomResponse extends $pb.GeneratedMessage {
  factory JoinRoomResponse({
    $0.RoomCondition? condition,
  }) {
    final $result = create();
    if (condition != null) {
      $result.condition = condition;
    }
    return $result;
  }
  JoinRoomResponse._() : super();
  factory JoinRoomResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRoomResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRoomResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOM<$0.RoomCondition>(1, _omitFieldNames ? '' : 'condition', subBuilder: $0.RoomCondition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRoomResponse clone() => JoinRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRoomResponse copyWith(void Function(JoinRoomResponse) updates) => super.copyWith((message) => updates(message as JoinRoomResponse)) as JoinRoomResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse create() => JoinRoomResponse._();
  JoinRoomResponse createEmptyInstance() => create();
  static $pb.PbList<JoinRoomResponse> createRepeated() => $pb.PbList<JoinRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(create);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.RoomCondition get condition => $_getN(0);
  @$pb.TagNumber(1)
  set condition($0.RoomCondition v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCondition() => $_has(0);
  @$pb.TagNumber(1)
  void clearCondition() => clearField(1);
  @$pb.TagNumber(1)
  $0.RoomCondition ensureCondition() => $_ensure(0);
}

///  LeaveRoom roomから退出する。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
///  - FailedPrecondition:
///    - 指定されたroomに参加していない
class LeaveRoomRequest extends $pb.GeneratedMessage {
  factory LeaveRoomRequest({
    $core.String? roomId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    return $result;
  }
  LeaveRoomRequest._() : super();
  factory LeaveRoomRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveRoomRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LeaveRoomRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveRoomRequest clone() => LeaveRoomRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveRoomRequest copyWith(void Function(LeaveRoomRequest) updates) => super.copyWith((message) => updates(message as LeaveRoomRequest)) as LeaveRoomRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest create() => LeaveRoomRequest._();
  LeaveRoomRequest createEmptyInstance() => create();
  static $pb.PbList<LeaveRoomRequest> createRepeated() => $pb.PbList<LeaveRoomRequest>();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveRoomRequest>(create);
  static LeaveRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);
}

class LeaveRoomResponse extends $pb.GeneratedMessage {
  factory LeaveRoomResponse() => create();
  LeaveRoomResponse._() : super();
  factory LeaveRoomResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaveRoomResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LeaveRoomResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaveRoomResponse clone() => LeaveRoomResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaveRoomResponse copyWith(void Function(LeaveRoomResponse) updates) => super.copyWith((message) => updates(message as LeaveRoomResponse)) as LeaveRoomResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse create() => LeaveRoomResponse._();
  LeaveRoomResponse createEmptyInstance() => create();
  static $pb.PbList<LeaveRoomResponse> createRepeated() => $pb.PbList<LeaveRoomResponse>();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveRoomResponse>(create);
  static LeaveRoomResponse? _defaultInstance;
}

///  CastVote 投票する。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
///  - FailedPrecondition:
///    - 指定されたroomに参加していない
///    - roomが投票可能な状態でない
class CastVoteRequest extends $pb.GeneratedMessage {
  factory CastVoteRequest({
    $core.String? roomId,
    $0.Ballot? ballot,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    if (ballot != null) {
      $result.ballot = ballot;
    }
    return $result;
  }
  CastVoteRequest._() : super();
  factory CastVoteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastVoteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CastVoteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<$0.Ballot>(2, _omitFieldNames ? '' : 'ballot', subBuilder: $0.Ballot.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastVoteRequest clone() => CastVoteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastVoteRequest copyWith(void Function(CastVoteRequest) updates) => super.copyWith((message) => updates(message as CastVoteRequest)) as CastVoteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CastVoteRequest create() => CastVoteRequest._();
  CastVoteRequest createEmptyInstance() => create();
  static $pb.PbList<CastVoteRequest> createRepeated() => $pb.PbList<CastVoteRequest>();
  @$core.pragma('dart2js:noInline')
  static CastVoteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastVoteRequest>(create);
  static CastVoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);

  @$pb.TagNumber(2)
  $0.Ballot get ballot => $_getN(1);
  @$pb.TagNumber(2)
  set ballot($0.Ballot v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBallot() => $_has(1);
  @$pb.TagNumber(2)
  void clearBallot() => clearField(2);
  @$pb.TagNumber(2)
  $0.Ballot ensureBallot() => $_ensure(1);
}

class CastVoteResponse extends $pb.GeneratedMessage {
  factory CastVoteResponse() => create();
  CastVoteResponse._() : super();
  factory CastVoteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastVoteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CastVoteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastVoteResponse clone() => CastVoteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastVoteResponse copyWith(void Function(CastVoteResponse) updates) => super.copyWith((message) => updates(message as CastVoteResponse)) as CastVoteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CastVoteResponse create() => CastVoteResponse._();
  CastVoteResponse createEmptyInstance() => create();
  static $pb.PbList<CastVoteResponse> createRepeated() => $pb.PbList<CastVoteResponse>();
  @$core.pragma('dart2js:noInline')
  static CastVoteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastVoteResponse>(create);
  static CastVoteResponse? _defaultInstance;
}

///  ResetVotes 投票をリセットする。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
///  - NotFound:
///    - 指定されたroomに参加していない
class ResetVotesRequest extends $pb.GeneratedMessage {
  factory ResetVotesRequest({
    $core.String? roomId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    return $result;
  }
  ResetVotesRequest._() : super();
  factory ResetVotesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResetVotesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResetVotesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResetVotesRequest clone() => ResetVotesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResetVotesRequest copyWith(void Function(ResetVotesRequest) updates) => super.copyWith((message) => updates(message as ResetVotesRequest)) as ResetVotesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetVotesRequest create() => ResetVotesRequest._();
  ResetVotesRequest createEmptyInstance() => create();
  static $pb.PbList<ResetVotesRequest> createRepeated() => $pb.PbList<ResetVotesRequest>();
  @$core.pragma('dart2js:noInline')
  static ResetVotesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetVotesRequest>(create);
  static ResetVotesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);
}

class ResetVotesResponse extends $pb.GeneratedMessage {
  factory ResetVotesResponse() => create();
  ResetVotesResponse._() : super();
  factory ResetVotesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResetVotesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResetVotesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResetVotesResponse clone() => ResetVotesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResetVotesResponse copyWith(void Function(ResetVotesResponse) updates) => super.copyWith((message) => updates(message as ResetVotesResponse)) as ResetVotesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetVotesResponse create() => ResetVotesResponse._();
  ResetVotesResponse createEmptyInstance() => create();
  static $pb.PbList<ResetVotesResponse> createRepeated() => $pb.PbList<ResetVotesResponse>();
  @$core.pragma('dart2js:noInline')
  static ResetVotesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetVotesResponse>(create);
  static ResetVotesResponse? _defaultInstance;
}

///  ShowVotes 開票する。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
///  - NotFound:
///    - 指定されたroomに参加していない
///  - FailedPrecondition:
///    - roomが開票可能な状態でない
class ShowVotesRequest extends $pb.GeneratedMessage {
  factory ShowVotesRequest({
    $core.String? roomId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    return $result;
  }
  ShowVotesRequest._() : super();
  factory ShowVotesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShowVotesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ShowVotesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ShowVotesRequest clone() => ShowVotesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ShowVotesRequest copyWith(void Function(ShowVotesRequest) updates) => super.copyWith((message) => updates(message as ShowVotesRequest)) as ShowVotesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShowVotesRequest create() => ShowVotesRequest._();
  ShowVotesRequest createEmptyInstance() => create();
  static $pb.PbList<ShowVotesRequest> createRepeated() => $pb.PbList<ShowVotesRequest>();
  @$core.pragma('dart2js:noInline')
  static ShowVotesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShowVotesRequest>(create);
  static ShowVotesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);
}

class ShowVotesResponse extends $pb.GeneratedMessage {
  factory ShowVotesResponse() => create();
  ShowVotesResponse._() : super();
  factory ShowVotesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShowVotesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ShowVotesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ShowVotesResponse clone() => ShowVotesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ShowVotesResponse copyWith(void Function(ShowVotesResponse) updates) => super.copyWith((message) => updates(message as ShowVotesResponse)) as ShowVotesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShowVotesResponse create() => ShowVotesResponse._();
  ShowVotesResponse createEmptyInstance() => create();
  static $pb.PbList<ShowVotesResponse> createRepeated() => $pb.PbList<ShowVotesResponse>();
  @$core.pragma('dart2js:noInline')
  static ShowVotesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShowVotesResponse>(create);
  static ShowVotesResponse? _defaultInstance;
}

///  KickUser ユーザを強制退室させる。
///
///  Errors:
///  - Unauthenticated:
///    - cookieのtokenがない、または無効
///  - NotFound:
///    - 実行ユーザが指定されたroomに参加していない
///  - PermissionDenied:
///    - 実行ユーザがroomのオーナーではない
///  - FailedPrecondition:
///    - 実行ユーザ自身のIDが指定されている
///    - target_user_idが指定されたroomに参加していない
class KickUserRequest extends $pb.GeneratedMessage {
  factory KickUserRequest({
    $core.String? roomId,
    $core.String? targetUserId,
  }) {
    final $result = create();
    if (roomId != null) {
      $result.roomId = roomId;
    }
    if (targetUserId != null) {
      $result.targetUserId = targetUserId;
    }
    return $result;
  }
  KickUserRequest._() : super();
  factory KickUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KickUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KickUserRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'targetUserId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KickUserRequest clone() => KickUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KickUserRequest copyWith(void Function(KickUserRequest) updates) => super.copyWith((message) => updates(message as KickUserRequest)) as KickUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickUserRequest create() => KickUserRequest._();
  KickUserRequest createEmptyInstance() => create();
  static $pb.PbList<KickUserRequest> createRepeated() => $pb.PbList<KickUserRequest>();
  @$core.pragma('dart2js:noInline')
  static KickUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KickUserRequest>(create);
  static KickUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetUserId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetUserId() => clearField(2);
}

class KickUserResponse extends $pb.GeneratedMessage {
  factory KickUserResponse() => create();
  KickUserResponse._() : super();
  factory KickUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KickUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'KickUserResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KickUserResponse clone() => KickUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KickUserResponse copyWith(void Function(KickUserResponse) updates) => super.copyWith((message) => updates(message as KickUserResponse)) as KickUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickUserResponse create() => KickUserResponse._();
  KickUserResponse createEmptyInstance() => create();
  static $pb.PbList<KickUserResponse> createRepeated() => $pb.PbList<KickUserResponse>();
  @$core.pragma('dart2js:noInline')
  static KickUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KickUserResponse>(create);
  static KickUserResponse? _defaultInstance;
}

class Porker2ServiceApi {
  $pb.RpcClient _client;
  Porker2ServiceApi(this._client);

  $async.Future<LoginResponse> login($pb.ClientContext? ctx, LoginRequest request) =>
    _client.invoke<LoginResponse>(ctx, 'Porker2Service', 'Login', request, LoginResponse())
  ;
  $async.Future<LogoutResponse> logout($pb.ClientContext? ctx, LogoutRequest request) =>
    _client.invoke<LogoutResponse>(ctx, 'Porker2Service', 'Logout', request, LogoutResponse())
  ;
  $async.Future<KickUserResponse> kickUser($pb.ClientContext? ctx, KickUserRequest request) =>
    _client.invoke<KickUserResponse>(ctx, 'Porker2Service', 'KickUser', request, KickUserResponse())
  ;
  $async.Future<CreateRoomResponse> createRoom($pb.ClientContext? ctx, CreateRoomRequest request) =>
    _client.invoke<CreateRoomResponse>(ctx, 'Porker2Service', 'CreateRoom', request, CreateRoomResponse())
  ;
  $async.Future<JoinRoomResponse> joinRoom($pb.ClientContext? ctx, JoinRoomRequest request) =>
    _client.invoke<JoinRoomResponse>(ctx, 'Porker2Service', 'JoinRoom', request, JoinRoomResponse())
  ;
  $async.Future<LeaveRoomResponse> leaveRoom($pb.ClientContext? ctx, LeaveRoomRequest request) =>
    _client.invoke<LeaveRoomResponse>(ctx, 'Porker2Service', 'LeaveRoom', request, LeaveRoomResponse())
  ;
  $async.Future<CastVoteResponse> castVote($pb.ClientContext? ctx, CastVoteRequest request) =>
    _client.invoke<CastVoteResponse>(ctx, 'Porker2Service', 'CastVote', request, CastVoteResponse())
  ;
  $async.Future<ShowVotesResponse> showVotes($pb.ClientContext? ctx, ShowVotesRequest request) =>
    _client.invoke<ShowVotesResponse>(ctx, 'Porker2Service', 'ShowVotes', request, ShowVotesResponse())
  ;
  $async.Future<ResetVotesResponse> resetVotes($pb.ClientContext? ctx, ResetVotesRequest request) =>
    _client.invoke<ResetVotesResponse>(ctx, 'Porker2Service', 'ResetVotes', request, ResetVotesResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
