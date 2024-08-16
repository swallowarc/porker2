import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/port/repository.dart';

RoomCondition _defaultRoomCondition = RoomCondition(
  roomId: "",
  adminUserId: "",
  ballots: [],
  voteState: VoteState.VOTE_STATE_HIDE,
);

class Poker extends StateNotifier<RoomCondition> {
  final Porker2ServiceRepository _svcRepo;

  Poker(this._svcRepo) : super(_defaultRoomCondition);

  Future<String> createRoom() async {
    return _svcRepo.createRoom();
  }

  Future<void> joinRoom(String roomId) async {
    await _svcRepo.joinRoom(roomId, (RoomCondition rc) {
      // TODO: この方法では通知されないので修正が必要
      state = rc;
    });
  }

  Future<void> leaveRoom() async {
    _svcRepo.leaveRoom(state.roomId);
    state = _defaultRoomCondition;
  }

  Future<void> castVote(Point point) => _svcRepo.castVote(state.roomId, point);

  Future<void> showVotes() => _svcRepo.showVotes(state.roomId);

  Future<void> resetVotes() => _svcRepo.resetVotes(state.roomId);

  Future<void> kickUser(String targetUserID) => _svcRepo.kickUser(
        state.roomId,
        targetUserID,
      );

  bool get inRoom => state.roomId.isNotEmpty;

  List<Ballot> get ballots => state.ballots;

  bool get opened => state.voteState == VoteState.VOTE_STATE_OPEN;

  bool get openable =>
      state.voteState == VoteState.VOTE_STATE_HIDE &&
      state.ballots
          .where((e) => ![Point.POINT_UNSPECIFIED].contains(e.point))
          .isNotEmpty;
}
