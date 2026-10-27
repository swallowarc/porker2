// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Ballot {

 String get userID; String get userName; Point get point; UserRole get role;
/// Create a copy of Ballot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BallotCopyWith<Ballot> get copyWith => _$BallotCopyWithImpl<Ballot>(this as Ballot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Ballot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ballot&&(identical(other.userID, _this.userID) || other.userID == _this.userID)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.point, _this.point) || other.point == _this.point)&&(identical(other.role, _this.role) || other.role == _this.role));
}


@override
int get hashCode {
  final _this = this as Ballot;
  return Object.hash(runtimeType,_this.userID,_this.userName,_this.point,_this.role);
}

@override
String toString() {
  final _this = this as Ballot;
  return 'Ballot(userID: ${_this.userID}, userName: ${_this.userName}, point: ${_this.point}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $BallotCopyWith<$Res>  {
  factory $BallotCopyWith(Ballot value, $Res Function(Ballot) _then) = _$BallotCopyWithImpl;
@useResult
$Res call({
 String userID, String userName, Point point, UserRole role
});




}
/// @nodoc
class _$BallotCopyWithImpl<$Res>
    implements $BallotCopyWith<$Res> {
  _$BallotCopyWithImpl(this._self, this._then);

  final Ballot _self;
  final $Res Function(Ballot) _then;

/// Create a copy of Ballot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userID = null,Object? userName = null,Object? point = null,Object? role = null,}) {
  return _then(Ballot(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as Point,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}

}


/// Adds pattern-matching-related methods to [Ballot].
extension BallotPatterns on Ballot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ballot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ballot() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ballot value)  $default,){
final _that = this;
switch (_that) {
case _Ballot():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ballot value)?  $default,){
final _that = this;
switch (_that) {
case _Ballot() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userID,  String userName,  Point point,  UserRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ballot() when $default != null:
return $default(_that.userID,_that.userName,_that.point,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userID,  String userName,  Point point,  UserRole role)  $default,) {final _that = this;
switch (_that) {
case _Ballot():
return $default(_that.userID,_that.userName,_that.point,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userID,  String userName,  Point point,  UserRole role)?  $default,) {final _that = this;
switch (_that) {
case _Ballot() when $default != null:
return $default(_that.userID,_that.userName,_that.point,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _Ballot extends Ballot {
  const _Ballot({required this.userID, required this.userName, required this.point, required this.role}): super._();
  

@override final  String userID;
@override final  String userName;
@override final  Point point;
@override final  UserRole role;

/// Create a copy of Ballot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallotCopyWith<_Ballot> get copyWith => __$BallotCopyWithImpl<_Ballot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ballot&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.point, point) || other.point == point)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userID,userName,point,role);
}

@override
String toString() {
    return 'Ballot(userID: $userID, userName: $userName, point: $point, role: $role)';
}


}

/// @nodoc
abstract mixin class _$BallotCopyWith<$Res> implements $BallotCopyWith<$Res> {
  factory _$BallotCopyWith(_Ballot value, $Res Function(_Ballot) _then) = __$BallotCopyWithImpl;
@override @useResult
$Res call({
 String userID, String userName, Point point, UserRole role
});




}
/// @nodoc
class __$BallotCopyWithImpl<$Res>
    implements _$BallotCopyWith<$Res> {
  __$BallotCopyWithImpl(this._self, this._then);

  final _Ballot _self;
  final $Res Function(_Ballot) _then;

/// Create a copy of Ballot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userID = null,Object? userName = null,Object? point = null,Object? role = null,}) {
  return _then(_Ballot(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as Point,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

/// @nodoc
mixin _$Room {

 String get roomID; String get adminUserID; List<Ballot> get ballots; VoteState get voteState; bool get autoOpen; DisplayMode get displayMode;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Room;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.roomID, _this.roomID) || other.roomID == _this.roomID)&&(identical(other.adminUserID, _this.adminUserID) || other.adminUserID == _this.adminUserID)&&const DeepCollectionEquality().equals(other.ballots, _this.ballots)&&(identical(other.voteState, _this.voteState) || other.voteState == _this.voteState)&&(identical(other.autoOpen, _this.autoOpen) || other.autoOpen == _this.autoOpen)&&(identical(other.displayMode, _this.displayMode) || other.displayMode == _this.displayMode));
}


@override
int get hashCode {
  final _this = this as Room;
  return Object.hash(runtimeType,_this.roomID,_this.adminUserID,const DeepCollectionEquality().hash(_this.ballots),_this.voteState,_this.autoOpen,_this.displayMode);
}

@override
String toString() {
  final _this = this as Room;
  return 'Room(roomID: ${_this.roomID}, adminUserID: ${_this.adminUserID}, ballots: ${_this.ballots}, voteState: ${_this.voteState}, autoOpen: ${_this.autoOpen}, displayMode: ${_this.displayMode})';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
 String roomID, String adminUserID, List<Ballot> ballots, VoteState voteState, bool autoOpen, DisplayMode displayMode
});




}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomID = null,Object? adminUserID = null,Object? ballots = null,Object? voteState = null,Object? autoOpen = null,Object? displayMode = null,}) {
  return _then(Room(
roomID: null == roomID ? _self.roomID : roomID // ignore: cast_nullable_to_non_nullable
as String,adminUserID: null == adminUserID ? _self.adminUserID : adminUserID // ignore: cast_nullable_to_non_nullable
as String,ballots: null == ballots ? _self.ballots : ballots // ignore: cast_nullable_to_non_nullable
as List<Ballot>,voteState: null == voteState ? _self.voteState : voteState // ignore: cast_nullable_to_non_nullable
as VoteState,autoOpen: null == autoOpen ? _self.autoOpen : autoOpen // ignore: cast_nullable_to_non_nullable
as bool,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as DisplayMode,
  ));
}

}


/// Adds pattern-matching-related methods to [Room].
extension RoomPatterns on Room {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Room value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Room value)  $default,){
final _that = this;
switch (_that) {
case _Room():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Room value)?  $default,){
final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomID,  String adminUserID,  List<Ballot> ballots,  VoteState voteState,  bool autoOpen,  DisplayMode displayMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.roomID,_that.adminUserID,_that.ballots,_that.voteState,_that.autoOpen,_that.displayMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomID,  String adminUserID,  List<Ballot> ballots,  VoteState voteState,  bool autoOpen,  DisplayMode displayMode)  $default,) {final _that = this;
switch (_that) {
case _Room():
return $default(_that.roomID,_that.adminUserID,_that.ballots,_that.voteState,_that.autoOpen,_that.displayMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomID,  String adminUserID,  List<Ballot> ballots,  VoteState voteState,  bool autoOpen,  DisplayMode displayMode)?  $default,) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.roomID,_that.adminUserID,_that.ballots,_that.voteState,_that.autoOpen,_that.displayMode);case _:
  return null;

}
}

}

/// @nodoc


class _Room extends Room {
  const _Room({required this.roomID, required this.adminUserID, required  List<Ballot> ballots, required this.voteState, required this.autoOpen, required this.displayMode}): _ballots = ballots,super._();
  

@override final  String roomID;
@override final  String adminUserID;
 final  List<Ballot> _ballots;
@override List<Ballot> get ballots {
  if (_ballots is EqualUnmodifiableListView) return _ballots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ballots);
}

@override final  VoteState voteState;
@override final  bool autoOpen;
@override final  DisplayMode displayMode;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.roomID, roomID) || other.roomID == roomID)&&(identical(other.adminUserID, adminUserID) || other.adminUserID == adminUserID)&&const DeepCollectionEquality().equals(other.ballots, _ballots)&&(identical(other.voteState, voteState) || other.voteState == voteState)&&(identical(other.autoOpen, autoOpen) || other.autoOpen == autoOpen)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,roomID,adminUserID,const DeepCollectionEquality().hash(_ballots),voteState,autoOpen,displayMode);
}

@override
String toString() {
    return 'Room(roomID: $roomID, adminUserID: $adminUserID, ballots: $ballots, voteState: $voteState, autoOpen: $autoOpen, displayMode: $displayMode)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
 String roomID, String adminUserID, List<Ballot> ballots, VoteState voteState, bool autoOpen, DisplayMode displayMode
});




}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomID = null,Object? adminUserID = null,Object? ballots = null,Object? voteState = null,Object? autoOpen = null,Object? displayMode = null,}) {
  return _then(_Room(
roomID: null == roomID ? _self.roomID : roomID // ignore: cast_nullable_to_non_nullable
as String,adminUserID: null == adminUserID ? _self.adminUserID : adminUserID // ignore: cast_nullable_to_non_nullable
as String,ballots: null == ballots ? _self._ballots : ballots // ignore: cast_nullable_to_non_nullable
as List<Ballot>,voteState: null == voteState ? _self.voteState : voteState // ignore: cast_nullable_to_non_nullable
as VoteState,autoOpen: null == autoOpen ? _self.autoOpen : autoOpen // ignore: cast_nullable_to_non_nullable
as bool,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as DisplayMode,
  ));
}


}

// dart format on
