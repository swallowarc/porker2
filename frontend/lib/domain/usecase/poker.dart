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
  bool _subscribing = false;

  Poker(this._svcRepo) : super(_defaultRoomCondition);

  Future<String> createRoom(String roomName) => _svcRepo.createRoom();

  Future<void> joinRoom(String roomId) async {
    _subscribing = true;

    _svcRepo.joinRoom(roomId, (RoomCondition rc) {
      if (!_subscribing) return;
      state = rc;
    });

    _subscribing = false;
  }

  Future<void> leaveRoom() async {
    _svcRepo.leaveRoom(state.roomId);
    _subscribing = false;
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
}
