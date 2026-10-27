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

  bool get opened => voteState == VoteState.open;

  /// 投票を受け付ける状態か
  bool get votable => voteState == VoteState.hide;

  /// 公開できる状態か (伏せられていて、誰かが投票済み)
  bool get openable => votable && ballots.any((e) => e.point.isVoted);

  Ballot? ballotOf(String userID) =>
      ballots.where((e) => e.userID == userID).firstOrNull;

  /// 指定ユーザーの投票。部屋にいない・未投票なら [Point.unspecified]
  Point pointOf(String userID) =>
      ballotOf(userID)?.point ?? Point.unspecified;

  bool isObserver(String userID) => ballotOf(userID)?.isObserver ?? false;

  /// 投票者 (観戦者を除く)
  List<Ballot> get voters =>
      ballots.where((e) => !e.isObserver).toList(growable: false);

  int get observerCount => ballots.where((e) => e.isObserver).length;

  /// 数値の票だけを数えた投票者数
  int get numericVoteCount => voters.where((e) => e.point.isNumeric).length;

  /// 数値の票の平均。数値の票がなければ 0
  double get average {
    final values = voters.map((e) => e.point.value).nonNulls.toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// 公開済みで、2 人以上の投票者が全員同じ札を出しているか (観戦者は数えない)
  bool get isUnanimity {
    if (!opened) return false;

    final vs = voters;
    if (vs.length < 2) return false;

    final first = vs.first.point;
    return first.isVoted && vs.every((e) => e.point == first);
  }
}
