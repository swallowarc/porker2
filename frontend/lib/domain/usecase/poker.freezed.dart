// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PokerState {
  String get roomID;
  String get adminUserID;
  List<Ballot> get ballots;
  VoteState get voteState;
  bool get autoOpen;
  DisplayMode get displayMode;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PokerStateCopyWith<PokerState> get copyWith =>
      _$PokerStateCopyWithImpl<PokerState>(this as PokerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PokerState &&
            (identical(other.roomID, roomID) || other.roomID == roomID) &&
            (identical(other.adminUserID, adminUserID) ||
                other.adminUserID == adminUserID) &&
            const DeepCollectionEquality().equals(other.ballots, ballots) &&
            (identical(other.voteState, voteState) ||
                other.voteState == voteState) &&
            (identical(other.autoOpen, autoOpen) ||
                other.autoOpen == autoOpen) &&
            (identical(other.displayMode, displayMode) ||
                other.displayMode == displayMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roomID,
      adminUserID,
      const DeepCollectionEquality().hash(ballots),
      voteState,
      autoOpen,
      displayMode);

  @override
  String toString() {
    return 'PokerState(roomID: $roomID, adminUserID: $adminUserID, ballots: $ballots, voteState: $voteState, autoOpen: $autoOpen, displayMode: $displayMode)';
  }
}

/// @nodoc
abstract mixin class $PokerStateCopyWith<$Res> {
  factory $PokerStateCopyWith(
          PokerState value, $Res Function(PokerState) _then) =
      _$PokerStateCopyWithImpl;
  @useResult
  $Res call(
      {String roomID,
      String adminUserID,
      List<Ballot> ballots,
      VoteState voteState,
      bool autoOpen,
      DisplayMode displayMode});
}

/// @nodoc
class _$PokerStateCopyWithImpl<$Res> implements $PokerStateCopyWith<$Res> {
  _$PokerStateCopyWithImpl(this._self, this._then);

  final PokerState _self;
  final $Res Function(PokerState) _then;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomID = null,
    Object? adminUserID = null,
    Object? ballots = null,
    Object? voteState = null,
    Object? autoOpen = null,
    Object? displayMode = null,
  }) {
    return _then(_self.copyWith(
      roomID: null == roomID
          ? _self.roomID
          : roomID // ignore: cast_nullable_to_non_nullable
              as String,
      adminUserID: null == adminUserID
          ? _self.adminUserID
          : adminUserID // ignore: cast_nullable_to_non_nullable
              as String,
      ballots: null == ballots
          ? _self.ballots
          : ballots // ignore: cast_nullable_to_non_nullable
              as List<Ballot>,
      voteState: null == voteState
          ? _self.voteState
          : voteState // ignore: cast_nullable_to_non_nullable
              as VoteState,
      autoOpen: null == autoOpen
          ? _self.autoOpen
          : autoOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      displayMode: null == displayMode
          ? _self.displayMode
          : displayMode // ignore: cast_nullable_to_non_nullable
              as DisplayMode,
    ));
  }
}

/// Adds pattern-matching-related methods to [PokerState].
extension PokerStatePatterns on PokerState {
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
    TResult Function(_PokerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PokerState() when $default != null:
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
    TResult Function(_PokerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PokerState():
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
    TResult? Function(_PokerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PokerState() when $default != null:
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
    TResult Function(String roomID, String adminUserID, List<Ballot> ballots,
            VoteState voteState, bool autoOpen, DisplayMode displayMode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PokerState() when $default != null:
        return $default(_that.roomID, _that.adminUserID, _that.ballots,
            _that.voteState, _that.autoOpen, _that.displayMode);
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
    TResult Function(String roomID, String adminUserID, List<Ballot> ballots,
            VoteState voteState, bool autoOpen, DisplayMode displayMode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PokerState():
        return $default(_that.roomID, _that.adminUserID, _that.ballots,
            _that.voteState, _that.autoOpen, _that.displayMode);
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
    TResult? Function(String roomID, String adminUserID, List<Ballot> ballots,
            VoteState voteState, bool autoOpen, DisplayMode displayMode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PokerState() when $default != null:
        return $default(_that.roomID, _that.adminUserID, _that.ballots,
            _that.voteState, _that.autoOpen, _that.displayMode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PokerState implements PokerState {
  const _PokerState(this.roomID, this.adminUserID, final List<Ballot> ballots,
      this.voteState, this.autoOpen, this.displayMode)
      : _ballots = ballots;

  @override
  final String roomID;
  @override
  final String adminUserID;
  final List<Ballot> _ballots;
  @override
  List<Ballot> get ballots {
    if (_ballots is EqualUnmodifiableListView) return _ballots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ballots);
  }

  @override
  final VoteState voteState;
  @override
  final bool autoOpen;
  @override
  final DisplayMode displayMode;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PokerStateCopyWith<_PokerState> get copyWith =>
      __$PokerStateCopyWithImpl<_PokerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PokerState &&
            (identical(other.roomID, roomID) || other.roomID == roomID) &&
            (identical(other.adminUserID, adminUserID) ||
                other.adminUserID == adminUserID) &&
            const DeepCollectionEquality().equals(other._ballots, _ballots) &&
            (identical(other.voteState, voteState) ||
                other.voteState == voteState) &&
            (identical(other.autoOpen, autoOpen) ||
                other.autoOpen == autoOpen) &&
            (identical(other.displayMode, displayMode) ||
                other.displayMode == displayMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roomID,
      adminUserID,
      const DeepCollectionEquality().hash(_ballots),
      voteState,
      autoOpen,
      displayMode);

  @override
  String toString() {
    return 'PokerState(roomID: $roomID, adminUserID: $adminUserID, ballots: $ballots, voteState: $voteState, autoOpen: $autoOpen, displayMode: $displayMode)';
  }
}

/// @nodoc
abstract mixin class _$PokerStateCopyWith<$Res>
    implements $PokerStateCopyWith<$Res> {
  factory _$PokerStateCopyWith(
          _PokerState value, $Res Function(_PokerState) _then) =
      __$PokerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String roomID,
      String adminUserID,
      List<Ballot> ballots,
      VoteState voteState,
      bool autoOpen,
      DisplayMode displayMode});
}

/// @nodoc
class __$PokerStateCopyWithImpl<$Res> implements _$PokerStateCopyWith<$Res> {
  __$PokerStateCopyWithImpl(this._self, this._then);

  final _PokerState _self;
  final $Res Function(_PokerState) _then;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? roomID = null,
    Object? adminUserID = null,
    Object? ballots = null,
    Object? voteState = null,
    Object? autoOpen = null,
    Object? displayMode = null,
  }) {
    return _then(_PokerState(
      null == roomID
          ? _self.roomID
          : roomID // ignore: cast_nullable_to_non_nullable
              as String,
      null == adminUserID
          ? _self.adminUserID
          : adminUserID // ignore: cast_nullable_to_non_nullable
              as String,
      null == ballots
          ? _self._ballots
          : ballots // ignore: cast_nullable_to_non_nullable
              as List<Ballot>,
      null == voteState
          ? _self.voteState
          : voteState // ignore: cast_nullable_to_non_nullable
              as VoteState,
      null == autoOpen
          ? _self.autoOpen
          : autoOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      null == displayMode
          ? _self.displayMode
          : displayMode // ignore: cast_nullable_to_non_nullable
              as DisplayMode,
    ));
  }
}

// dart format on
