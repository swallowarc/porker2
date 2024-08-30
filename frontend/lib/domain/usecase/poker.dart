import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/port/repository.dart';

part 'poker.freezed.dart';

@freezed
class PokerState with _$PokerState {
  const factory PokerState(
    String roomID,
    String adminUserID,
    List<Ballot> ballots,
    VoteState voteState,
    bool autoOpen,
  ) = _PokerState;
}

class Poker extends StateNotifier<PokerState> {
  final Porker2ServiceRepository _svcRepo;

  bool _subscribing = false;

  Poker(this._svcRepo)
      : super(const PokerState("", "", [], VoteState.VOTE_STATE_HIDE, true));

  void _reset() {
    state = state.copyWith(
      roomID: "",
      adminUserID: "",
      ballots: [],
      voteState: VoteState.VOTE_STATE_HIDE,
      autoOpen: true,
    );
  }

  Future<String> createRoom() async {
    return _svcRepo.createRoom();
  }

  Future<void> checkRoom(String roomId) async {
    await _svcRepo.checkRoom(roomId);
  }

  Future<void> joinRoom(String roomId) async {
    if (_subscribing) {
      logger.d("already subscribing");
      return;
    }
    _subscribing = true;

    _svcRepo.joinRoom(roomId, (RoomCondition rc) {
      logger.d("subscribe room condition: $rc");

      state = state.copyWith(
        roomID: rc.roomId,
        adminUserID: rc.adminUserId,
        ballots: rc.ballots,
        voteState: rc.voteState,
        autoOpen: rc.autoOpen,
      );
    }).then((_) {
      logger.d("unsubscribe room condition");
      _subscribing = false;
      _reset();
    }).onError((error, stackTrace) {
      logger.e("subscribe room condition error: $error",
          error: error, stackTrace: stackTrace);
      _subscribing = false;
      _reset();
    });
  }

  Future<void> leaveRoom() async {
    _svcRepo.leaveRoom(state.roomID);
    _reset();
  }

  Future<void> castVote(Point point) => _svcRepo.castVote(state.roomID, point);

  Future<void> showVotes() => _svcRepo.showVotes(state.roomID);

  Future<void> resetVotes() => _svcRepo.resetVotes(state.roomID);

  Future<void> kickUser(String targetUserID) => _svcRepo.kickUser(
        state.roomID,
        targetUserID,
      );

  Future<void> updateRoom(bool autoOpen) async {
    await _svcRepo.updateRoom(state.roomID, autoOpen);
  }

  bool get opened => state.voteState == VoteState.VOTE_STATE_OPEN;

  bool get openable =>
      state.voteState == VoteState.VOTE_STATE_HIDE &&
      state.ballots
          .where((e) => ![Point.POINT_UNSPECIFIED].contains(e.point))
          .isNotEmpty;

  bool get votable => state.voteState == VoteState.VOTE_STATE_HIDE;

  Point myPoint(String userID) => state.ballots
      .firstWhere((e) => e.userId == userID, orElse: () => Ballot())
      .point;

  bool get subscribing => _subscribing;
}
