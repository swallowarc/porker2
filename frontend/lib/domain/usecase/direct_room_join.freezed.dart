// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// Adds pattern-matching-related methods to [DirectRoomJoinState].
extension DirectRoomJoinStatePatterns on DirectRoomJoinState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DirectRoomJoinState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DirectRoomJoinState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DirectRoomJoinState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectRoomJoinState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DirectRoomJoinState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectRoomJoinState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String presetRoomID)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DirectRoomJoinState() when $default != null:
        return $default(_that.presetRoomID);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String presetRoomID) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectRoomJoinState():
        return $default(_that.presetRoomID);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String presetRoomID)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectRoomJoinState() when $default != null:
        return $default(_that.presetRoomID);
      case _:
        return null;
    }
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
