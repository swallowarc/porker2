// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PokerState {
  String get roomID => throw _privateConstructorUsedError;
  String get adminUserID => throw _privateConstructorUsedError;
  List<Ballot> get ballots => throw _privateConstructorUsedError;
  VoteState get voteState => throw _privateConstructorUsedError;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PokerStateCopyWith<PokerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PokerStateCopyWith<$Res> {
  factory $PokerStateCopyWith(
          PokerState value, $Res Function(PokerState) then) =
      _$PokerStateCopyWithImpl<$Res, PokerState>;
  @useResult
  $Res call(
      {String roomID,
      String adminUserID,
      List<Ballot> ballots,
      VoteState voteState});
}

/// @nodoc
class _$PokerStateCopyWithImpl<$Res, $Val extends PokerState>
    implements $PokerStateCopyWith<$Res> {
  _$PokerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomID = null,
    Object? adminUserID = null,
    Object? ballots = null,
    Object? voteState = null,
  }) {
    return _then(_value.copyWith(
      roomID: null == roomID
          ? _value.roomID
          : roomID // ignore: cast_nullable_to_non_nullable
              as String,
      adminUserID: null == adminUserID
          ? _value.adminUserID
          : adminUserID // ignore: cast_nullable_to_non_nullable
              as String,
      ballots: null == ballots
          ? _value.ballots
          : ballots // ignore: cast_nullable_to_non_nullable
              as List<Ballot>,
      voteState: null == voteState
          ? _value.voteState
          : voteState // ignore: cast_nullable_to_non_nullable
              as VoteState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PokerStateImplCopyWith<$Res>
    implements $PokerStateCopyWith<$Res> {
  factory _$$PokerStateImplCopyWith(
          _$PokerStateImpl value, $Res Function(_$PokerStateImpl) then) =
      __$$PokerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String roomID,
      String adminUserID,
      List<Ballot> ballots,
      VoteState voteState});
}

/// @nodoc
class __$$PokerStateImplCopyWithImpl<$Res>
    extends _$PokerStateCopyWithImpl<$Res, _$PokerStateImpl>
    implements _$$PokerStateImplCopyWith<$Res> {
  __$$PokerStateImplCopyWithImpl(
      _$PokerStateImpl _value, $Res Function(_$PokerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomID = null,
    Object? adminUserID = null,
    Object? ballots = null,
    Object? voteState = null,
  }) {
    return _then(_$PokerStateImpl(
      null == roomID
          ? _value.roomID
          : roomID // ignore: cast_nullable_to_non_nullable
              as String,
      null == adminUserID
          ? _value.adminUserID
          : adminUserID // ignore: cast_nullable_to_non_nullable
              as String,
      null == ballots
          ? _value._ballots
          : ballots // ignore: cast_nullable_to_non_nullable
              as List<Ballot>,
      null == voteState
          ? _value.voteState
          : voteState // ignore: cast_nullable_to_non_nullable
              as VoteState,
    ));
  }
}

/// @nodoc

class _$PokerStateImpl implements _PokerState {
  const _$PokerStateImpl(
      this.roomID, this.adminUserID, final List<Ballot> ballots, this.voteState)
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
  String toString() {
    return 'PokerState(roomID: $roomID, adminUserID: $adminUserID, ballots: $ballots, voteState: $voteState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PokerStateImpl &&
            (identical(other.roomID, roomID) || other.roomID == roomID) &&
            (identical(other.adminUserID, adminUserID) ||
                other.adminUserID == adminUserID) &&
            const DeepCollectionEquality().equals(other._ballots, _ballots) &&
            (identical(other.voteState, voteState) ||
                other.voteState == voteState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomID, adminUserID,
      const DeepCollectionEquality().hash(_ballots), voteState);

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PokerStateImplCopyWith<_$PokerStateImpl> get copyWith =>
      __$$PokerStateImplCopyWithImpl<_$PokerStateImpl>(this, _$identity);
}

abstract class _PokerState implements PokerState {
  const factory _PokerState(final String roomID, final String adminUserID,
      final List<Ballot> ballots, final VoteState voteState) = _$PokerStateImpl;

  @override
  String get roomID;
  @override
  String get adminUserID;
  @override
  List<Ballot> get ballots;
  @override
  VoteState get voteState;

  /// Create a copy of PokerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PokerStateImplCopyWith<_$PokerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
