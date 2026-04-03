// This is a generated file - do not edit.
//
// Generated from porker/v2/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'domain.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Login ログイン
/// ログインが成功した場合、tokenを返す。
///
/// Errors:
/// - InvalidArgument:
///   - ログイン名が未指定、またはフォーマット不正
/// - AlreadyExists:
///   - 既に同じIDでログイン済み
class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? userName,
  }) {
    final result = create();
    if (userName != null) result.userName = userName;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => $_clearField(1);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

/// VerifyUser ユーザの存在確認
/// cookieの有効性を確認。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
class VerifyUserRequest extends $pb.GeneratedMessage {
  factory VerifyUserRequest() => create();

  VerifyUserRequest._();

  factory VerifyUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyUserRequest copyWith(void Function(VerifyUserRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyUserRequest))
          as VerifyUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyUserRequest create() => VerifyUserRequest._();
  @$core.override
  VerifyUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyUserRequest>(create);
  static VerifyUserRequest? _defaultInstance;
}

class VerifyUserResponse extends $pb.GeneratedMessage {
  factory VerifyUserResponse({
    $core.String? userId,
    $core.String? userName,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (userName != null) result.userName = userName;
    return result;
  }

  VerifyUserResponse._();

  factory VerifyUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'userName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyUserResponse copyWith(void Function(VerifyUserResponse) updates) =>
      super.copyWith((message) => updates(message as VerifyUserResponse))
          as VerifyUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyUserResponse create() => VerifyUserResponse._();
  @$core.override
  VerifyUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyUserResponse>(create);
  static VerifyUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userName => $_getSZ(1);
  @$pb.TagNumber(2)
  set userName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserName() => $_clearField(2);
}

/// Logout ログアウト
/// ログアウトする。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => create();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutRequest create() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(create);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse() => create();

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;
}

/// CreateRoom roomを作成する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest() => create();

  CreateRoomRequest._();

  factory CreateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest copyWith(void Function(CreateRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRoomRequest))
          as CreateRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest create() => CreateRoomRequest._();
  @$core.override
  CreateRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(create);
  static CreateRoomRequest? _defaultInstance;
}

class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CreateRoomResponse._();

  factory CreateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse copyWith(void Function(CreateRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CreateRoomResponse))
          as CreateRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse create() => CreateRoomResponse._();
  @$core.override
  CreateRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(create);
  static CreateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

/// CheckRoom roomが入室可能か確認する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - roomが存在しない
/// - FailedPrecondition:
///   - roomが満員
class CheckRoomRequest extends $pb.GeneratedMessage {
  factory CheckRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CheckRoomRequest._();

  factory CheckRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomRequest copyWith(void Function(CheckRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CheckRoomRequest))
          as CheckRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRoomRequest create() => CheckRoomRequest._();
  @$core.override
  CheckRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRoomRequest>(create);
  static CheckRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class CheckRoomResponse extends $pb.GeneratedMessage {
  factory CheckRoomResponse() => create();

  CheckRoomResponse._();

  factory CheckRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomResponse copyWith(void Function(CheckRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CheckRoomResponse))
          as CheckRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRoomResponse create() => CheckRoomResponse._();
  @$core.override
  CheckRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRoomResponse>(create);
  static CheckRoomResponse? _defaultInstance;
}

/// JoinRoom roomに参加する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - roomが存在しない
/// - FailedPrecondition:
///   - roomが満員
///   - 指定されたroomに参加していない
class JoinRoomRequest extends $pb.GeneratedMessage {
  factory JoinRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  JoinRoomRequest._();

  factory JoinRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest copyWith(void Function(JoinRoomRequest) updates) =>
      super.copyWith((message) => updates(message as JoinRoomRequest))
          as JoinRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest create() => JoinRoomRequest._();
  @$core.override
  JoinRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(create);
  static JoinRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class JoinRoomResponse extends $pb.GeneratedMessage {
  factory JoinRoomResponse({
    $1.RoomCondition? condition,
  }) {
    final result = create();
    if (condition != null) result.condition = condition;
    return result;
  }

  JoinRoomResponse._();

  factory JoinRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOM<$1.RoomCondition>(1, _omitFieldNames ? '' : 'condition',
        subBuilder: $1.RoomCondition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse copyWith(void Function(JoinRoomResponse) updates) =>
      super.copyWith((message) => updates(message as JoinRoomResponse))
          as JoinRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse create() => JoinRoomResponse._();
  @$core.override
  JoinRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(create);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.RoomCondition get condition => $_getN(0);
  @$pb.TagNumber(1)
  set condition($1.RoomCondition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCondition() => $_has(0);
  @$pb.TagNumber(1)
  void clearCondition() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.RoomCondition ensureCondition() => $_ensure(0);
}

/// LeaveRoom roomから退出する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - FailedPrecondition:
///   - 指定されたroomに参加していない
class LeaveRoomRequest extends $pb.GeneratedMessage {
  factory LeaveRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  LeaveRoomRequest._();

  factory LeaveRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomRequest copyWith(void Function(LeaveRoomRequest) updates) =>
      super.copyWith((message) => updates(message as LeaveRoomRequest))
          as LeaveRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest create() => LeaveRoomRequest._();
  @$core.override
  LeaveRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveRoomRequest>(create);
  static LeaveRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class LeaveRoomResponse extends $pb.GeneratedMessage {
  factory LeaveRoomResponse() => create();

  LeaveRoomResponse._();

  factory LeaveRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomResponse copyWith(void Function(LeaveRoomResponse) updates) =>
      super.copyWith((message) => updates(message as LeaveRoomResponse))
          as LeaveRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse create() => LeaveRoomResponse._();
  @$core.override
  LeaveRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveRoomResponse>(create);
  static LeaveRoomResponse? _defaultInstance;
}

/// CastVote 投票する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - FailedPrecondition:
///   - 指定されたroomに参加していない
///   - roomが投票可能な状態でない
class CastVoteRequest extends $pb.GeneratedMessage {
  factory CastVoteRequest({
    $core.String? roomId,
    $1.Point? point,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (point != null) result.point = point;
    return result;
  }

  CastVoteRequest._();

  factory CastVoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CastVoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CastVoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aE<$1.Point>(2, _omitFieldNames ? '' : 'point',
        enumValues: $1.Point.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CastVoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CastVoteRequest copyWith(void Function(CastVoteRequest) updates) =>
      super.copyWith((message) => updates(message as CastVoteRequest))
          as CastVoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CastVoteRequest create() => CastVoteRequest._();
  @$core.override
  CastVoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CastVoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CastVoteRequest>(create);
  static CastVoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point($1.Point value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoint() => $_clearField(2);
}

class CastVoteResponse extends $pb.GeneratedMessage {
  factory CastVoteResponse() => create();

  CastVoteResponse._();

  factory CastVoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CastVoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CastVoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CastVoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CastVoteResponse copyWith(void Function(CastVoteResponse) updates) =>
      super.copyWith((message) => updates(message as CastVoteResponse))
          as CastVoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CastVoteResponse create() => CastVoteResponse._();
  @$core.override
  CastVoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CastVoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CastVoteResponse>(create);
  static CastVoteResponse? _defaultInstance;
}

/// ResetVotes 投票をリセットする。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - 指定されたroomに参加していない
class ResetVotesRequest extends $pb.GeneratedMessage {
  factory ResetVotesRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  ResetVotesRequest._();

  factory ResetVotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetVotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetVotesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetVotesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetVotesRequest copyWith(void Function(ResetVotesRequest) updates) =>
      super.copyWith((message) => updates(message as ResetVotesRequest))
          as ResetVotesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetVotesRequest create() => ResetVotesRequest._();
  @$core.override
  ResetVotesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResetVotesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetVotesRequest>(create);
  static ResetVotesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class ResetVotesResponse extends $pb.GeneratedMessage {
  factory ResetVotesResponse() => create();

  ResetVotesResponse._();

  factory ResetVotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetVotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetVotesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetVotesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetVotesResponse copyWith(void Function(ResetVotesResponse) updates) =>
      super.copyWith((message) => updates(message as ResetVotesResponse))
          as ResetVotesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetVotesResponse create() => ResetVotesResponse._();
  @$core.override
  ResetVotesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResetVotesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetVotesResponse>(create);
  static ResetVotesResponse? _defaultInstance;
}

/// ShowVotes 開票する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - 指定されたroomに参加していない
/// - FailedPrecondition:
///   - roomが開票可能な状態でない
class ShowVotesRequest extends $pb.GeneratedMessage {
  factory ShowVotesRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  ShowVotesRequest._();

  factory ShowVotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShowVotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShowVotesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowVotesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowVotesRequest copyWith(void Function(ShowVotesRequest) updates) =>
      super.copyWith((message) => updates(message as ShowVotesRequest))
          as ShowVotesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShowVotesRequest create() => ShowVotesRequest._();
  @$core.override
  ShowVotesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShowVotesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShowVotesRequest>(create);
  static ShowVotesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class ShowVotesResponse extends $pb.GeneratedMessage {
  factory ShowVotesResponse() => create();

  ShowVotesResponse._();

  factory ShowVotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShowVotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShowVotesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowVotesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowVotesResponse copyWith(void Function(ShowVotesResponse) updates) =>
      super.copyWith((message) => updates(message as ShowVotesResponse))
          as ShowVotesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShowVotesResponse create() => ShowVotesResponse._();
  @$core.override
  ShowVotesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShowVotesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShowVotesResponse>(create);
  static ShowVotesResponse? _defaultInstance;
}

/// KickUser ユーザを強制退室させる。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - 実行ユーザが指定されたroomに参加していない
/// - PermissionDenied:
///   - 実行ユーザがroomのオーナーではない
/// - FailedPrecondition:
///   - 実行ユーザ自身のIDが指定されている
///   - target_user_idが指定されたroomに参加していない
class KickUserRequest extends $pb.GeneratedMessage {
  factory KickUserRequest({
    $core.String? roomId,
    $core.String? targetUserId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (targetUserId != null) result.targetUserId = targetUserId;
    return result;
  }

  KickUserRequest._();

  factory KickUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'targetUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickUserRequest copyWith(void Function(KickUserRequest) updates) =>
      super.copyWith((message) => updates(message as KickUserRequest))
          as KickUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickUserRequest create() => KickUserRequest._();
  @$core.override
  KickUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickUserRequest>(create);
  static KickUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetUserId() => $_clearField(2);
}

class KickUserResponse extends $pb.GeneratedMessage {
  factory KickUserResponse() => create();

  KickUserResponse._();

  factory KickUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickUserResponse copyWith(void Function(KickUserResponse) updates) =>
      super.copyWith((message) => updates(message as KickUserResponse))
          as KickUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickUserResponse create() => KickUserResponse._();
  @$core.override
  KickUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickUserResponse>(create);
  static KickUserResponse? _defaultInstance;
}

/// UpdateRoom roomの設定を変更する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - 指定されたroomに参加していない
class UpdateRoomRequest extends $pb.GeneratedMessage {
  factory UpdateRoomRequest({
    $core.String? roomId,
    $core.bool? autoOpen,
    $1.DisplayMode? displayMode,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (autoOpen != null) result.autoOpen = autoOpen;
    if (displayMode != null) result.displayMode = displayMode;
    return result;
  }

  UpdateRoomRequest._();

  factory UpdateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOB(2, _omitFieldNames ? '' : 'autoOpen')
    ..aE<$1.DisplayMode>(3, _omitFieldNames ? '' : 'displayMode',
        enumValues: $1.DisplayMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomRequest copyWith(void Function(UpdateRoomRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomRequest))
          as UpdateRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomRequest create() => UpdateRoomRequest._();
  @$core.override
  UpdateRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomRequest>(create);
  static UpdateRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get autoOpen => $_getBF(1);
  @$pb.TagNumber(2)
  set autoOpen($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoOpen() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoOpen() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.DisplayMode get displayMode => $_getN(2);
  @$pb.TagNumber(3)
  set displayMode($1.DisplayMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayMode() => $_clearField(3);
}

class UpdateRoomResponse extends $pb.GeneratedMessage {
  factory UpdateRoomResponse() => create();

  UpdateRoomResponse._();

  factory UpdateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomResponse copyWith(void Function(UpdateRoomResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomResponse))
          as UpdateRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomResponse create() => UpdateRoomResponse._();
  @$core.override
  UpdateRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomResponse>(create);
  static UpdateRoomResponse? _defaultInstance;
}

/// ToggleObserverMode 観察者モードの切り替え
/// ユーザーの役割を投票者と観察者の間で切り替える。
/// 観察者は投票せずに部屋の状況を閲覧のみ可能。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
/// - NotFound:
///   - 指定されたroomに参加していない
class ToggleObserverModeRequest extends $pb.GeneratedMessage {
  factory ToggleObserverModeRequest({
    $core.String? roomId,
    $core.bool? isObserver,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (isObserver != null) result.isObserver = isObserver;
    return result;
  }

  ToggleObserverModeRequest._();

  factory ToggleObserverModeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToggleObserverModeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleObserverModeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOB(2, _omitFieldNames ? '' : 'isObserver')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleObserverModeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleObserverModeRequest copyWith(
          void Function(ToggleObserverModeRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleObserverModeRequest))
          as ToggleObserverModeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToggleObserverModeRequest create() => ToggleObserverModeRequest._();
  @$core.override
  ToggleObserverModeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToggleObserverModeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleObserverModeRequest>(create);
  static ToggleObserverModeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isObserver => $_getBF(1);
  @$pb.TagNumber(2)
  set isObserver($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsObserver() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsObserver() => $_clearField(2);
}

class ToggleObserverModeResponse extends $pb.GeneratedMessage {
  factory ToggleObserverModeResponse() => create();

  ToggleObserverModeResponse._();

  factory ToggleObserverModeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToggleObserverModeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleObserverModeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleObserverModeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleObserverModeResponse copyWith(
          void Function(ToggleObserverModeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ToggleObserverModeResponse))
          as ToggleObserverModeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToggleObserverModeResponse create() => ToggleObserverModeResponse._();
  @$core.override
  ToggleObserverModeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToggleObserverModeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleObserverModeResponse>(create);
  static ToggleObserverModeResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
