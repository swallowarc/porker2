import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/core/provider/repository_providers.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/entity/point.dart';
import 'package:porker2fe/domain/port/repository.dart';

part 'poker.freezed.dart';

@freezed
abstract class PokerState with _$PokerState {
  const factory PokerState(
    String roomID,
    String adminUserID,
    List<Ballot> ballots,
    VoteState voteState,
    bool autoOpen,
    DisplayMode displayMode,
    int observerCount,
  ) = _PokerState;
}

class Poker extends Notifier<PokerState> {
  late final Porker2ServiceRepository _svcRepo;
  String _subscribingRoomID = "";

  @override
  PokerState build() {
    _svcRepo = ref.read(porker2ServiceRepositoryProvider);
    return const PokerState("", "", [], VoteState.VOTE_STATE_HIDE, true, DisplayMode.DISPLAY_MODE_POINT, 0);
  }

  void _reset() {
    _subscribingRoomID = "";
    state = state.copyWith(
      roomID: "",
      adminUserID: "",
      ballots: [],
      voteState: VoteState.VOTE_STATE_HIDE,
      autoOpen: true,
      displayMode: DisplayMode.DISPLAY_MODE_POINT,
      observerCount: 0,
    );
  }

  Future<String> createRoom() async {
    return _svcRepo.createRoom();
  }

  Future<void> checkRoom(String roomId) async {
    await _svcRepo.checkRoom(roomId);
  }

  Future<void> joinRoom(String roomId) async {
    if (_subscribingRoomID == roomId) {
      logger.d("already subscribing: $roomId");
      return;
    }
    _subscribingRoomID = roomId;

    try {
      await for (final rc in _svcRepo.joinRoom(roomId)) {
        logger.d("subscribe room condition: $rc");

        state = state.copyWith(
          roomID: rc.roomId,
          adminUserID: rc.adminUserId,
          ballots: rc.ballots,
          voteState: rc.voteState,
          autoOpen: rc.autoOpen,
          displayMode: rc.displayMode,
          observerCount: rc.observerCount,
        );
      }
      logger.d("unsubscribe room condition");
      _reset();
    } catch (error, stackTrace) {
      logger.e("subscribe room condition error: $error",
          error: error, stackTrace: stackTrace);
      _reset();
    }
  }

  Future<void> leaveRoom() async => _svcRepo.leaveRoom(state.roomID);

  Future<void> castVote(Point point) => _svcRepo.castVote(state.roomID, point);

  Future<void> showVotes() => _svcRepo.showVotes(state.roomID);

  Future<void> resetVotes() => _svcRepo.resetVotes(state.roomID);

  Future<void> kickUser(String targetUserID) =>
      _svcRepo.kickUser(
        state.roomID,
        targetUserID,
      );

  Future<void> updateRoom(bool autoOpen, DisplayMode displayMode) async {
    await _svcRepo.updateRoom(state.roomID, autoOpen, displayMode);
  }

  Future<void> toggleObserverMode(bool isObserver) async {
    await _svcRepo.toggleObserverMode(state.roomID, isObserver);
  }

  bool get opened => state.voteState == VoteState.VOTE_STATE_OPEN;

  bool get openable =>
      state.voteState == VoteState.VOTE_STATE_HIDE &&
          state.ballots
              .where((e) => ![Point.POINT_UNSPECIFIED].contains(e.point))
              .isNotEmpty;

  bool get votable => state.voteState == VoteState.VOTE_STATE_HIDE;

  Point myPoint(String userID) =>
      state.ballots
          .firstWhere((e) => e.userId == userID, orElse: () => Ballot())
          .point;

  bool isObserver(String userID) =>
      state.ballots
          .firstWhere((e) => e.userId == userID, orElse: () => Ballot())
          .role == UserRole.USER_ROLE_OBSERVER;

  bool get subscribing => _subscribingRoomID.isNotEmpty;

  List<Ballot> get voterBallots =>
      state.ballots
          .where((e) => e.role != UserRole.USER_ROLE_OBSERVER)
          .toList();

  int get observerCount =>
      state.ballots
          .where((e) => e.role == UserRole.USER_ROLE_OBSERVER)
          .length;

  double get voteAverage {
    final voters = voterBallots;
    final validVotes = voters.where((e) => validPoint(e.point));
    if (validVotes.isEmpty) return 0;

    final total = validVotes.fold<double>(
        0, (prev, e) => prev + pointToDouble(e.point));
    return total / validVotes.length;
  }

  int get validVoteCount =>
      voterBallots.where((e) => validPoint(e.point)).length;

  bool get isUnanimity {
    if (state.voteState != VoteState.VOTE_STATE_OPEN) {
      return false;
    }

    final voterBallots = state.ballots
        .where((ballot) => ballot.role != UserRole.USER_ROLE_OBSERVER)
        .toList();

    if (voterBallots.length < 2) {
      return false;
    }

    final firstPoint = voterBallots.first.point;
    if (firstPoint == Point.POINT_UNSPECIFIED) {
      return false;
    }

    return voterBallots.every((ballot) => ballot.point == firstPoint);
  }
}
