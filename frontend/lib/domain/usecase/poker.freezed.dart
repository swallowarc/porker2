// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
                other.autoOpen == autoOpen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomID, adminUserID,
      const DeepCollectionEquality().hash(ballots), voteState, autoOpen);

  @override
  String toString() {
    return 'PokerState(roomID: $roomID, adminUserID: $adminUserID, ballots: $ballots, voteState: $voteState, autoOpen: $autoOpen)';
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
      bool autoOpen});
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
    ));
  }
}

/// @nodoc

class _PokerState implements PokerState {
  const _PokerState(this.roomID, this.adminUserID, final List<Ballot> ballots,
      this.voteState, this.autoOpen)
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
                other.autoOpen == autoOpen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomID, adminUserID,
      const DeepCollectionEquality().hash(_ballots), voteState, autoOpen);

  @override
  String toString() {
    return 'PokerState(roomID: $roomID, adminUserID: $adminUserID, ballots: $ballots, voteState: $voteState, autoOpen: $autoOpen)';
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
      bool autoOpen});
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
    ));
  }
}

// dart format on
