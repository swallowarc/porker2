import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/domain/point.dart';

part 'room.freezed.dart';

final roomIDFormatRegExp = RegExp(r"^[0-9]{5}$");

final roomNotFoundError = ExpectedError(
  "Room not found",
);

final roomFullError = ExpectedError(
  "Room is full",
);

/// 札の見せ方
enum DisplayMode { point, tshirt }

/// 投票の公開状態
enum VoteState { hide, open }

/// 部屋での役割
enum UserRole { voter, observer }

/// 部屋にいる 1 人のユーザーとその投票
@freezed
abstract class Ballot with _$Ballot {
  const Ballot._();

  const factory Ballot({
    required String userID,
    required String userName,
    required Point point,
    required UserRole role,
  }) = _Ballot;

  bool get isObserver => role == UserRole.observer;
}

/// 部屋の状態。サーバーから配信されるスナップショットで、クライアント側では変更しない。
@freezed
abstract class Room with _$Room {
  const Room._();

  const factory Room({
    required String roomID,
    required String adminUserID,
    required List<Ballot> ballots,
    required VoteState voteState,
    required bool autoOpen,
    required DisplayMode displayMode,
  }) = _Room;

  /// どの部屋にも入っていない状態
  static const empty = Room(
    roomID: "",
    adminUserID: "",
    ballots: [],
    voteState: VoteState.hide,
    autoOpen: true,
    displayMode: DisplayMode.point,
  );

  bool get isEmpty => roomID.isEmpty;
}
