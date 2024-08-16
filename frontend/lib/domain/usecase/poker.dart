import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  ) = _PokerState;
}

class Poker extends StateNotifier<PokerState> {
  final Porker2ServiceRepository _svcRepo;

  Poker(this._svcRepo)
      : super(const PokerState("", "", [], VoteState.VOTE_STATE_HIDE));

  Future<String> createRoom() async {
    return _svcRepo.createRoom();
  }

  Future<void> joinRoom(String roomId) async {
    await _svcRepo.joinRoom(roomId, (RoomCondition rc) {
      state = state.copyWith(
        roomID: rc.roomId,
        adminUserID: rc.adminUserId,
        ballots: rc.ballots,
        voteState: rc.voteState,
      );
    });
  }

  Future<void> leaveRoom() async {
    _svcRepo.leaveRoom(state.roomID);
    state = state.copyWith(
      roomID: "",
      adminUserID: "",
      ballots: [],
      voteState: VoteState.VOTE_STATE_HIDE,
    );
  }

  Future<void> castVote(Point point) => _svcRepo.castVote(state.roomID, point);

  Future<void> showVotes() => _svcRepo.showVotes(state.roomID);

  Future<void> resetVotes() => _svcRepo.resetVotes(state.roomID);

  Future<void> kickUser(String targetUserID) => _svcRepo.kickUser(
        state.roomID,
        targetUserID,
      );

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
}
