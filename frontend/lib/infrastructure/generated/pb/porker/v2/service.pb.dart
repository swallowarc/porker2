// This is a generated file - do not edit.
//
// Generated from porker/v2/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'domain.pb.dart' as $0;

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
    final result = LoginRequest._();
    if (userName != null) result.userName = userName;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginRequest()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: LoginRequest.$_createMessage)
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
  @$core.Deprecated('Use LoginRequest() / LoginRequest.new instead')
  static LoginRequest create() => LoginRequest._();
  static $pb.GeneratedMessage $_createMessage() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => LoginRequest._();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(
          LoginRequest.$_createMessage);
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
    final result = LoginResponse._();
    if (userId != null) result.userId = userId;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginResponse()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: LoginResponse.$_createMessage)
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
  @$core.Deprecated('Use LoginResponse() / LoginResponse.new instead')
  static LoginResponse create() => LoginResponse._();
  static $pb.GeneratedMessage $_createMessage() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => LoginResponse._();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(
          LoginResponse.$_createMessage);
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
  factory VerifyUserRequest() => VerifyUserRequest._();

  VerifyUserRequest._();

  factory VerifyUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyUserRequest()..mergeFromBuffer(data, registry);
  factory VerifyUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyUserRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: VerifyUserRequest.$_createMessage)
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
  @$core.Deprecated('Use VerifyUserRequest() / VerifyUserRequest.new instead')
  static VerifyUserRequest create() => VerifyUserRequest._();
  static $pb.GeneratedMessage $_createMessage() => VerifyUserRequest._();
  @$core.override
  VerifyUserRequest createEmptyInstance() => VerifyUserRequest._();
  @$core.pragma('dart2js:noInline')
  static VerifyUserRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerifyUserRequest>(
          VerifyUserRequest.$_createMessage);
  static VerifyUserRequest? _defaultInstance;
}

class VerifyUserResponse extends $pb.GeneratedMessage {
  factory VerifyUserResponse({
    $core.String? userId,
    $core.String? userName,
  }) {
    final result = VerifyUserResponse._();
    if (userId != null) result.userId = userId;
    if (userName != null) result.userName = userName;
    return result;
  }

  VerifyUserResponse._();

  factory VerifyUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyUserResponse()..mergeFromBuffer(data, registry);
  factory VerifyUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyUserResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: VerifyUserResponse.$_createMessage)
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
  @$core.Deprecated('Use VerifyUserResponse() / VerifyUserResponse.new instead')
  static VerifyUserResponse create() => VerifyUserResponse._();
  static $pb.GeneratedMessage $_createMessage() => VerifyUserResponse._();
  @$core.override
  VerifyUserResponse createEmptyInstance() => VerifyUserResponse._();
  @$core.pragma('dart2js:noInline')
  static VerifyUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyUserResponse>(
          VerifyUserResponse.$_createMessage);
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
  factory LogoutRequest() => LogoutRequest._();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: LogoutRequest.$_createMessage)
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
  @$core.Deprecated('Use LogoutRequest() / LogoutRequest.new instead')
  static LogoutRequest create() => LogoutRequest._();
  static $pb.GeneratedMessage $_createMessage() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => LogoutRequest._();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(
          LogoutRequest.$_createMessage);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse() => LogoutResponse._();

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: LogoutResponse.$_createMessage)
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
  @$core.Deprecated('Use LogoutResponse() / LogoutResponse.new instead')
  static LogoutResponse create() => LogoutResponse._();
  static $pb.GeneratedMessage $_createMessage() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => LogoutResponse._();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(
          LogoutResponse.$_createMessage);
  static LogoutResponse? _defaultInstance;
}

/// CreateRoom roomを作成する。
///
/// Errors:
/// - Unauthenticated:
///   - cookieのtokenがない、または無効
class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest() => CreateRoomRequest._();

  CreateRoomRequest._();

  factory CreateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRoomRequest()..mergeFromBuffer(data, registry);
  factory CreateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: CreateRoomRequest.$_createMessage)
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
  @$core.Deprecated('Use CreateRoomRequest() / CreateRoomRequest.new instead')
  static CreateRoomRequest create() => CreateRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateRoomRequest._();
  @$core.override
  CreateRoomRequest createEmptyInstance() => CreateRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(
          CreateRoomRequest.$_createMessage);
  static CreateRoomRequest? _defaultInstance;
}

class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    $core.String? roomId,
  }) {
    final result = CreateRoomResponse._();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CreateRoomResponse._();

  factory CreateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRoomResponse()..mergeFromBuffer(data, registry);
  factory CreateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: CreateRoomResponse.$_createMessage)
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
  @$core.Deprecated('Use CreateRoomResponse() / CreateRoomResponse.new instead')
  static CreateRoomResponse create() => CreateRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateRoomResponse._();
  @$core.override
  CreateRoomResponse createEmptyInstance() => CreateRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(
          CreateRoomResponse.$_createMessage);
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
    final result = CheckRoomRequest._();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CheckRoomRequest._();

  factory CheckRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckRoomRequest()..mergeFromBuffer(data, registry);
  factory CheckRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: CheckRoomRequest.$_createMessage)
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
  @$core.Deprecated('Use CheckRoomRequest() / CheckRoomRequest.new instead')
  static CheckRoomRequest create() => CheckRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => CheckRoomRequest._();
  @$core.override
  CheckRoomRequest createEmptyInstance() => CheckRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static CheckRoomRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckRoomRequest>(
          CheckRoomRequest.$_createMessage);
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
  factory CheckRoomResponse() => CheckRoomResponse._();

  CheckRoomResponse._();

  factory CheckRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckRoomResponse()..mergeFromBuffer(data, registry);
  factory CheckRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: CheckRoomResponse.$_createMessage)
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
  @$core.Deprecated('Use CheckRoomResponse() / CheckRoomResponse.new instead')
  static CheckRoomResponse create() => CheckRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => CheckRoomResponse._();
  @$core.override
  CheckRoomResponse createEmptyInstance() => CheckRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static CheckRoomResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckRoomResponse>(
          CheckRoomResponse.$_createMessage);
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
    final result = JoinRoomRequest._();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  JoinRoomRequest._();

  factory JoinRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinRoomRequest()..mergeFromBuffer(data, registry);
  factory JoinRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: JoinRoomRequest.$_createMessage)
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
  @$core.Deprecated('Use JoinRoomRequest() / JoinRoomRequest.new instead')
  static JoinRoomRequest create() => JoinRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => JoinRoomRequest._();
  @$core.override
  JoinRoomRequest createEmptyInstance() => JoinRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(
          JoinRoomRequest.$_createMessage);
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
    $0.RoomCondition? condition,
  }) {
    final result = JoinRoomResponse._();
    if (condition != null) result.condition = condition;
    return result;
  }

  JoinRoomResponse._();

  factory JoinRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinRoomResponse()..mergeFromBuffer(data, registry);
  factory JoinRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: JoinRoomResponse.$_createMessage)
    ..aOM<$0.RoomCondition>(1, _omitFieldNames ? '' : 'condition',
        subBuilder: $0.RoomCondition.$_createMessage)
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
  @$core.Deprecated('Use JoinRoomResponse() / JoinRoomResponse.new instead')
  static JoinRoomResponse create() => JoinRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => JoinRoomResponse._();
  @$core.override
  JoinRoomResponse createEmptyInstance() => JoinRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(
          JoinRoomResponse.$_createMessage);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.RoomCondition get condition => $_getN(0);
  @$pb.TagNumber(1)
  set condition($0.RoomCondition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCondition() => $_has(0);
  @$pb.TagNumber(1)
  void clearCondition() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.RoomCondition ensureCondition() => $_ensure(0);
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
    final result = LeaveRoomRequest._();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  LeaveRoomRequest._();

  factory LeaveRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveRoomRequest()..mergeFromBuffer(data, registry);
  factory LeaveRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: LeaveRoomRequest.$_createMessage)
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
  @$core.Deprecated('Use LeaveRoomRequest() / LeaveRoomRequest.new instead')
  static LeaveRoomRequest create() => LeaveRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => LeaveRoomRequest._();
  @$core.override
  LeaveRoomRequest createEmptyInstance() => LeaveRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveRoomRequest>(
          LeaveRoomRequest.$_createMessage);
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
  factory LeaveRoomResponse() => LeaveRoomResponse._();

  LeaveRoomResponse._();

  factory LeaveRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveRoomResponse()..mergeFromBuffer(data, registry);
  factory LeaveRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: LeaveRoomResponse.$_createMessage)
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
  @$core.Deprecated('Use LeaveRoomResponse() / LeaveRoomResponse.new instead')
  static LeaveRoomResponse create() => LeaveRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => LeaveRoomResponse._();
  @$core.override
  LeaveRoomResponse createEmptyInstance() => LeaveRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaveRoomResponse>(
          LeaveRoomResponse.$_createMessage);
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
    $0.Point? point,
  }) {
    final result = CastVoteRequest._();
    if (roomId != null) result.roomId = roomId;
    if (point != null) result.point = point;
    return result;
  }

  CastVoteRequest._();

  factory CastVoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CastVoteRequest()..mergeFromBuffer(data, registry);
  factory CastVoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CastVoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CastVoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: CastVoteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aE<$0.Point>(2, _omitFieldNames ? '' : 'point',
        enumValues: $0.Point.values)
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
  @$core.Deprecated('Use CastVoteRequest() / CastVoteRequest.new instead')
  static CastVoteRequest create() => CastVoteRequest._();
  static $pb.GeneratedMessage $_createMessage() => CastVoteRequest._();
  @$core.override
  CastVoteRequest createEmptyInstance() => CastVoteRequest._();
  @$core.pragma('dart2js:noInline')
  static CastVoteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastVoteRequest>(
          CastVoteRequest.$_createMessage);
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
  $0.Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point($0.Point value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoint() => $_clearField(2);
}

class CastVoteResponse extends $pb.GeneratedMessage {
  factory CastVoteResponse() => CastVoteResponse._();

  CastVoteResponse._();

  factory CastVoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CastVoteResponse()..mergeFromBuffer(data, registry);
  factory CastVoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CastVoteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CastVoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: CastVoteResponse.$_createMessage)
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
  @$core.Deprecated('Use CastVoteResponse() / CastVoteResponse.new instead')
  static CastVoteResponse create() => CastVoteResponse._();
  static $pb.GeneratedMessage $_createMessage() => CastVoteResponse._();
  @$core.override
  CastVoteResponse createEmptyInstance() => CastVoteResponse._();
  @$core.pragma('dart2js:noInline')
  static CastVoteResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastVoteResponse>(
          CastVoteResponse.$_createMessage);
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
    final result = ResetVotesRequest._();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  ResetVotesRequest._();

  factory ResetVotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetVotesRequest()..mergeFromBuffer(data, registry);
  factory ResetVotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetVotesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetVotesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: ResetVotesRequest.$_createMessage)
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
  @$core.Deprecated('Use ResetVotesRequest() / ResetVotesRequest.new instead')
  static ResetVotesRequest create() => ResetVotesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResetVotesRequest._();
  @$core.override
  ResetVotesRequest createEmptyInstance() => ResetVotesRequest._();
  @$core.pragma('dart2js:noInline')
  static ResetVotesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetVotesRequest>(
          ResetVotesRequest.$_createMessage);
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
  factory ResetVotesResponse() => ResetVotesResponse._();

  ResetVotesResponse._();

  factory ResetVotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetVotesResponse()..mergeFromBuffer(data, registry);
  factory ResetVotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResetVotesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetVotesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: ResetVotesResponse.$_createMessage)
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
  @$core.Deprecated('Use ResetVotesResponse() / ResetVotesResponse.new instead')
  static ResetVotesResponse create() => ResetVotesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ResetVotesResponse._();
  @$core.override
  ResetVotesResponse createEmptyInstance() => ResetVotesResponse._();
  @$core.pragma('dart2js:noInline')
  static ResetVotesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetVotesResponse>(
          ResetVotesResponse.$_createMessage);
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
    final result = ShowVotesRequest._();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  ShowVotesRequest._();

  factory ShowVotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShowVotesRequest()..mergeFromBuffer(data, registry);
  factory ShowVotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShowVotesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShowVotesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: ShowVotesRequest.$_createMessage)
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
  @$core.Deprecated('Use ShowVotesRequest() / ShowVotesRequest.new instead')
  static ShowVotesRequest create() => ShowVotesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ShowVotesRequest._();
  @$core.override
  ShowVotesRequest createEmptyInstance() => ShowVotesRequest._();
  @$core.pragma('dart2js:noInline')
  static ShowVotesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShowVotesRequest>(
          ShowVotesRequest.$_createMessage);
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
  factory ShowVotesResponse() => ShowVotesResponse._();

  ShowVotesResponse._();

  factory ShowVotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShowVotesResponse()..mergeFromBuffer(data, registry);
  factory ShowVotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShowVotesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShowVotesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: ShowVotesResponse.$_createMessage)
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
  @$core.Deprecated('Use ShowVotesResponse() / ShowVotesResponse.new instead')
  static ShowVotesResponse create() => ShowVotesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ShowVotesResponse._();
  @$core.override
  ShowVotesResponse createEmptyInstance() => ShowVotesResponse._();
  @$core.pragma('dart2js:noInline')
  static ShowVotesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShowVotesResponse>(
          ShowVotesResponse.$_createMessage);
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
    final result = KickUserRequest._();
    if (roomId != null) result.roomId = roomId;
    if (targetUserId != null) result.targetUserId = targetUserId;
    return result;
  }

  KickUserRequest._();

  factory KickUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KickUserRequest()..mergeFromBuffer(data, registry);
  factory KickUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KickUserRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: KickUserRequest.$_createMessage)
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
  @$core.Deprecated('Use KickUserRequest() / KickUserRequest.new instead')
  static KickUserRequest create() => KickUserRequest._();
  static $pb.GeneratedMessage $_createMessage() => KickUserRequest._();
  @$core.override
  KickUserRequest createEmptyInstance() => KickUserRequest._();
  @$core.pragma('dart2js:noInline')
  static KickUserRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KickUserRequest>(
          KickUserRequest.$_createMessage);
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
  factory KickUserResponse() => KickUserResponse._();

  KickUserResponse._();

  factory KickUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KickUserResponse()..mergeFromBuffer(data, registry);
  factory KickUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KickUserResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: KickUserResponse.$_createMessage)
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
  @$core.Deprecated('Use KickUserResponse() / KickUserResponse.new instead')
  static KickUserResponse create() => KickUserResponse._();
  static $pb.GeneratedMessage $_createMessage() => KickUserResponse._();
  @$core.override
  KickUserResponse createEmptyInstance() => KickUserResponse._();
  @$core.pragma('dart2js:noInline')
  static KickUserResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KickUserResponse>(
          KickUserResponse.$_createMessage);
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
    $0.DisplayMode? displayMode,
  }) {
    final result = UpdateRoomRequest._();
    if (roomId != null) result.roomId = roomId;
    if (autoOpen != null) result.autoOpen = autoOpen;
    if (displayMode != null) result.displayMode = displayMode;
    return result;
  }

  UpdateRoomRequest._();

  factory UpdateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRoomRequest()..mergeFromBuffer(data, registry);
  factory UpdateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: UpdateRoomRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOB(2, _omitFieldNames ? '' : 'autoOpen')
    ..aE<$0.DisplayMode>(3, _omitFieldNames ? '' : 'displayMode',
        enumValues: $0.DisplayMode.values)
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
  @$core.Deprecated('Use UpdateRoomRequest() / UpdateRoomRequest.new instead')
  static UpdateRoomRequest create() => UpdateRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateRoomRequest._();
  @$core.override
  UpdateRoomRequest createEmptyInstance() => UpdateRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRoomRequest>(
          UpdateRoomRequest.$_createMessage);
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
  $0.DisplayMode get displayMode => $_getN(2);
  @$pb.TagNumber(3)
  set displayMode($0.DisplayMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayMode() => $_clearField(3);
}

class UpdateRoomResponse extends $pb.GeneratedMessage {
  factory UpdateRoomResponse() => UpdateRoomResponse._();

  UpdateRoomResponse._();

  factory UpdateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRoomResponse()..mergeFromBuffer(data, registry);
  factory UpdateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: UpdateRoomResponse.$_createMessage)
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
  @$core.Deprecated('Use UpdateRoomResponse() / UpdateRoomResponse.new instead')
  static UpdateRoomResponse create() => UpdateRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateRoomResponse._();
  @$core.override
  UpdateRoomResponse createEmptyInstance() => UpdateRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomResponse>(
          UpdateRoomResponse.$_createMessage);
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
    final result = ToggleObserverModeRequest._();
    if (roomId != null) result.roomId = roomId;
    if (isObserver != null) result.isObserver = isObserver;
    return result;
  }

  ToggleObserverModeRequest._();

  factory ToggleObserverModeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleObserverModeRequest()..mergeFromBuffer(data, registry);
  factory ToggleObserverModeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleObserverModeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleObserverModeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: ToggleObserverModeRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use ToggleObserverModeRequest() / ToggleObserverModeRequest.new instead')
  static ToggleObserverModeRequest create() => ToggleObserverModeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ToggleObserverModeRequest._();
  @$core.override
  ToggleObserverModeRequest createEmptyInstance() =>
      ToggleObserverModeRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleObserverModeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleObserverModeRequest>(
          ToggleObserverModeRequest.$_createMessage);
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
  factory ToggleObserverModeResponse() => ToggleObserverModeResponse._();

  ToggleObserverModeResponse._();

  factory ToggleObserverModeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleObserverModeResponse()..mergeFromBuffer(data, registry);
  factory ToggleObserverModeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleObserverModeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleObserverModeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'porker.v2'),
      createEmptyInstance: ToggleObserverModeResponse.$_createMessage)
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
  @$core.Deprecated(
      'Use ToggleObserverModeResponse() / ToggleObserverModeResponse.new instead')
  static ToggleObserverModeResponse create() => ToggleObserverModeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ToggleObserverModeResponse._();
  @$core.override
  ToggleObserverModeResponse createEmptyInstance() =>
      ToggleObserverModeResponse._();
  @$core.pragma('dart2js:noInline')
  static ToggleObserverModeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleObserverModeResponse>(
          ToggleObserverModeResponse.$_createMessage);
  static ToggleObserverModeResponse? _defaultInstance;
}

class Porker2ServiceApi {
  final $pb.RpcClient _client;

  Porker2ServiceApi(this._client);

  $async.Future<LoginResponse> login(
          $pb.ClientContext? ctx, LoginRequest request) =>
      _client.invoke<LoginResponse>(
          ctx, 'Porker2Service', 'Login', request, LoginResponse());
  $async.Future<LogoutResponse> logout(
          $pb.ClientContext? ctx, LogoutRequest request) =>
      _client.invoke<LogoutResponse>(
          ctx, 'Porker2Service', 'Logout', request, LogoutResponse());
  $async.Future<VerifyUserResponse> verifyUser(
          $pb.ClientContext? ctx, VerifyUserRequest request) =>
      _client.invoke<VerifyUserResponse>(
          ctx, 'Porker2Service', 'VerifyUser', request, VerifyUserResponse());
  $async.Future<CreateRoomResponse> createRoom(
          $pb.ClientContext? ctx, CreateRoomRequest request) =>
      _client.invoke<CreateRoomResponse>(
          ctx, 'Porker2Service', 'CreateRoom', request, CreateRoomResponse());
  $async.Future<CheckRoomResponse> checkRoom(
          $pb.ClientContext? ctx, CheckRoomRequest request) =>
      _client.invoke<CheckRoomResponse>(
          ctx, 'Porker2Service', 'CheckRoom', request, CheckRoomResponse());
  $async.Future<JoinRoomResponse> joinRoom(
          $pb.ClientContext? ctx, JoinRoomRequest request) =>
      _client.invoke<JoinRoomResponse>(
          ctx, 'Porker2Service', 'JoinRoom', request, JoinRoomResponse());
  $async.Future<LeaveRoomResponse> leaveRoom(
          $pb.ClientContext? ctx, LeaveRoomRequest request) =>
      _client.invoke<LeaveRoomResponse>(
          ctx, 'Porker2Service', 'LeaveRoom', request, LeaveRoomResponse());
  $async.Future<CastVoteResponse> castVote(
          $pb.ClientContext? ctx, CastVoteRequest request) =>
      _client.invoke<CastVoteResponse>(
          ctx, 'Porker2Service', 'CastVote', request, CastVoteResponse());
  $async.Future<ShowVotesResponse> showVotes(
          $pb.ClientContext? ctx, ShowVotesRequest request) =>
      _client.invoke<ShowVotesResponse>(
          ctx, 'Porker2Service', 'ShowVotes', request, ShowVotesResponse());
  $async.Future<ResetVotesResponse> resetVotes(
          $pb.ClientContext? ctx, ResetVotesRequest request) =>
      _client.invoke<ResetVotesResponse>(
          ctx, 'Porker2Service', 'ResetVotes', request, ResetVotesResponse());
  $async.Future<KickUserResponse> kickUser(
          $pb.ClientContext? ctx, KickUserRequest request) =>
      _client.invoke<KickUserResponse>(
          ctx, 'Porker2Service', 'KickUser', request, KickUserResponse());
  $async.Future<UpdateRoomResponse> updateRoom(
          $pb.ClientContext? ctx, UpdateRoomRequest request) =>
      _client.invoke<UpdateRoomResponse>(
          ctx, 'Porker2Service', 'UpdateRoom', request, UpdateRoomResponse());
  $async.Future<ToggleObserverModeResponse> toggleObserverMode(
          $pb.ClientContext? ctx, ToggleObserverModeRequest request) =>
      _client.invoke<ToggleObserverModeResponse>(ctx, 'Porker2Service',
          'ToggleObserverMode', request, ToggleObserverModeResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
