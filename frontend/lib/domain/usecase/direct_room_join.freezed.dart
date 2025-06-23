// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'direct_room_join.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DirectRoomJoinState {
  String get presetRoomID;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DirectRoomJoinStateCopyWith<DirectRoomJoinState> get copyWith =>
      _$DirectRoomJoinStateCopyWithImpl<DirectRoomJoinState>(
          this as DirectRoomJoinState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DirectRoomJoinState &&
            (identical(other.presetRoomID, presetRoomID) ||
                other.presetRoomID == presetRoomID));
  }

  @override
  int get hashCode => Object.hash(runtimeType, presetRoomID);

  @override
  String toString() {
    return 'DirectRoomJoinState(presetRoomID: $presetRoomID)';
  }
}

/// @nodoc
abstract mixin class $DirectRoomJoinStateCopyWith<$Res> {
  factory $DirectRoomJoinStateCopyWith(
          DirectRoomJoinState value, $Res Function(DirectRoomJoinState) _then) =
      _$DirectRoomJoinStateCopyWithImpl;
  @useResult
  $Res call({String presetRoomID});
}

/// @nodoc
class _$DirectRoomJoinStateCopyWithImpl<$Res>
    implements $DirectRoomJoinStateCopyWith<$Res> {
  _$DirectRoomJoinStateCopyWithImpl(this._self, this._then);

  final DirectRoomJoinState _self;
  final $Res Function(DirectRoomJoinState) _then;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetRoomID = null,
  }) {
    return _then(_self.copyWith(
      presetRoomID: null == presetRoomID
          ? _self.presetRoomID
          : presetRoomID // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _DirectRoomJoinState implements DirectRoomJoinState {
  const _DirectRoomJoinState(this.presetRoomID);

  @override
  final String presetRoomID;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DirectRoomJoinStateCopyWith<_DirectRoomJoinState> get copyWith =>
      __$DirectRoomJoinStateCopyWithImpl<_DirectRoomJoinState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DirectRoomJoinState &&
            (identical(other.presetRoomID, presetRoomID) ||
                other.presetRoomID == presetRoomID));
  }

  @override
  int get hashCode => Object.hash(runtimeType, presetRoomID);

  @override
  String toString() {
    return 'DirectRoomJoinState(presetRoomID: $presetRoomID)';
  }
}

/// @nodoc
abstract mixin class _$DirectRoomJoinStateCopyWith<$Res>
    implements $DirectRoomJoinStateCopyWith<$Res> {
  factory _$DirectRoomJoinStateCopyWith(_DirectRoomJoinState value,
          $Res Function(_DirectRoomJoinState) _then) =
      __$DirectRoomJoinStateCopyWithImpl;
  @override
  @useResult
  $Res call({String presetRoomID});
}

/// @nodoc
class __$DirectRoomJoinStateCopyWithImpl<$Res>
    implements _$DirectRoomJoinStateCopyWith<$Res> {
  __$DirectRoomJoinStateCopyWithImpl(this._self, this._then);

  final _DirectRoomJoinState _self;
  final $Res Function(_DirectRoomJoinState) _then;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? presetRoomID = null,
  }) {
    return _then(_DirectRoomJoinState(
      null == presetRoomID
          ? _self.presetRoomID
          : presetRoomID // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
