// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'direct_room_join.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DirectRoomJoinState {
  String get presetRoomID => throw _privateConstructorUsedError;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DirectRoomJoinStateCopyWith<DirectRoomJoinState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DirectRoomJoinStateCopyWith<$Res> {
  factory $DirectRoomJoinStateCopyWith(
          DirectRoomJoinState value, $Res Function(DirectRoomJoinState) then) =
      _$DirectRoomJoinStateCopyWithImpl<$Res, DirectRoomJoinState>;
  @useResult
  $Res call({String presetRoomID});
}

/// @nodoc
class _$DirectRoomJoinStateCopyWithImpl<$Res, $Val extends DirectRoomJoinState>
    implements $DirectRoomJoinStateCopyWith<$Res> {
  _$DirectRoomJoinStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetRoomID = null,
  }) {
    return _then(_value.copyWith(
      presetRoomID: null == presetRoomID
          ? _value.presetRoomID
          : presetRoomID // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DirectRoomJoinStateImplCopyWith<$Res>
    implements $DirectRoomJoinStateCopyWith<$Res> {
  factory _$$DirectRoomJoinStateImplCopyWith(_$DirectRoomJoinStateImpl value,
          $Res Function(_$DirectRoomJoinStateImpl) then) =
      __$$DirectRoomJoinStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String presetRoomID});
}

/// @nodoc
class __$$DirectRoomJoinStateImplCopyWithImpl<$Res>
    extends _$DirectRoomJoinStateCopyWithImpl<$Res, _$DirectRoomJoinStateImpl>
    implements _$$DirectRoomJoinStateImplCopyWith<$Res> {
  __$$DirectRoomJoinStateImplCopyWithImpl(_$DirectRoomJoinStateImpl _value,
      $Res Function(_$DirectRoomJoinStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? presetRoomID = null,
  }) {
    return _then(_$DirectRoomJoinStateImpl(
      null == presetRoomID
          ? _value.presetRoomID
          : presetRoomID // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DirectRoomJoinStateImpl implements _DirectRoomJoinState {
  const _$DirectRoomJoinStateImpl(this.presetRoomID);

  @override
  final String presetRoomID;

  @override
  String toString() {
    return 'DirectRoomJoinState(presetRoomID: $presetRoomID)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DirectRoomJoinStateImpl &&
            (identical(other.presetRoomID, presetRoomID) ||
                other.presetRoomID == presetRoomID));
  }

  @override
  int get hashCode => Object.hash(runtimeType, presetRoomID);

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DirectRoomJoinStateImplCopyWith<_$DirectRoomJoinStateImpl> get copyWith =>
      __$$DirectRoomJoinStateImplCopyWithImpl<_$DirectRoomJoinStateImpl>(
          this, _$identity);
}

abstract class _DirectRoomJoinState implements DirectRoomJoinState {
  const factory _DirectRoomJoinState(final String presetRoomID) =
      _$DirectRoomJoinStateImpl;

  @override
  String get presetRoomID;

  /// Create a copy of DirectRoomJoinState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DirectRoomJoinStateImplCopyWith<_$DirectRoomJoinStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
