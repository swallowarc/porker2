import 'package:grpc/grpc_web.dart';
import 'package:porker2fe/core/error/retry.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/application/port/port.dart';

class Porker2ServiceImpl extends Porker2Service {
  final Porker2ServiceClient _client;

  Porker2ServiceImpl(this._client);

  @override
  Future<LoginResult> login(String userName) async {
    try {
      final res = await _client.login(LoginRequest()
        ..userName = userName);
      return (userID: res.userId); // tokenはcookieに保存される
    } on GrpcError catch (e) {
      throw (e.code == StatusCode.alreadyExists) ? alreadyUsedNameError : e;
    }
  }

  @override
  Future<void> logout() async {
    await _client.logout(LogoutRequest());
  }

  @override
  Future<UserEntity> verifyUser() async {
    final res = await _client.verifyUser(VerifyUserRequest());
    return Future.value(UserEntity(userID: res.userId, userName: res.userName));
  }

  @override
  Future<String> createRoom() async {
    final res = await _client.createRoom(CreateRoomRequest());
    return res.roomId;
  }

  @override
  Future<void> checkRoom(String roomID) async {
    try {
      await _client.checkRoom(CheckRoomRequest()
        ..roomId = roomID);
    } catch (e) {
      if (e is GrpcError) {
        if (e.code == StatusCode.notFound) {
          throw roomNotFoundError;
        }
      }
      rethrow;
    }
  }

  @override
  Stream<RoomCondition> joinRoom(String roomID) async* {
    bool subscribing = true;

    while (subscribing) {
      try {
        await for (final res in _client.joinRoom(JoinRoomRequest(roomId: roomID))) {
          yield res.condition;
        }
        // Stream completed normally
        subscribing = false;
      } catch (e, stackTrace) {
        if (shouldRetry(e)) {
          // server側のWriteTimeoutを超えた場合などを想定しリトライ
          logger.i('Stream retryable error', error: e);
          continue;
        }

        subscribing = false;
        logger.e('Stream error', error: e, stackTrace: stackTrace);

        if (e is GrpcError && e.code == StatusCode.notFound) {
          throw roomNotFoundError;
        }
      }
    }

    logger.d('Stream completed');
  }

  @override
  Future<void> leaveRoom(String roomID) async {
    await _client.leaveRoom(LeaveRoomRequest()
      ..roomId = roomID);
  }

  @override
  Future<void> castVote(String roomID, Point point) async {
    await _client.castVote(CastVoteRequest()
      ..roomId = roomID
      ..point = point);
  }

  @override
  Future<void> resetVotes(String roomID) async {
    await _client.resetVotes(ResetVotesRequest()
      ..roomId = roomID);
  }

  @override
  Future<void> showVotes(String roomID) async {
    await _client.showVotes(ShowVotesRequest()
      ..roomId = roomID);
  }

  @override
  Future<void> kickUser(String roomID, String targetUserID) async {
    await _client.kickUser(KickUserRequest()
      ..roomId = roomID
      ..targetUserId = targetUserID);
  }

  @override
  Future<void> updateRoom(String roomID, bool autoOpen, DisplayMode displayMode) async {
    await _client.updateRoom(UpdateRoomRequest()
      ..roomId = roomID
      ..autoOpen = autoOpen
      ..displayMode = displayMode);
  }

  @override
  Future<void> toggleObserverMode(String roomID, bool isObserver) async {
    await _client.toggleObserverMode(ToggleObserverModeRequest()
      ..roomId = roomID
      ..isObserver = isObserver);
  }
}
