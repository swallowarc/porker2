import 'package:grpc/grpc_web.dart';
import 'package:porker2fe/core/error/retry.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/domain/entity/room.dart';
import 'package:porker2fe/domain/entity/user.dart';
import 'package:porker2fe/domain/port/repository.dart';

class Porker2ServiceRepositoryImpl extends Porker2ServiceRepository {
  final Porker2ServiceClient _client;

  Porker2ServiceRepositoryImpl(this._client);

  @override
  Future<LoginResult> login(String userName) async {
    try {
      final res = await _client.login(LoginRequest()..userName = userName);
      return LoginResult(userID: res.userId); // tokenはcookieに保存される
    } on GrpcError catch (e) {
      throw (e.code == StatusCode.alreadyExists) ? alreadyUsedNameError : e;
    }
  }

  @override
  Future<void> logout() async {
    _client.logout(LogoutRequest());
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
      await _client.checkRoom(CheckRoomRequest()..roomId = roomID);
    } on GrpcError catch (e) {
      if (e.code == StatusCode.notFound) {
        throw roomNotFoundError;
      }
    }
  }

  @override
  Future<void> joinRoom(
      String roomID, Function(RoomCondition rc) callback) async {
    bool subscribing = true;

    while (subscribing) {
      await _client // await しないと無限ループ
          .joinRoom(JoinRoomRequest(roomId: roomID))
          .listen((res) {
            callback(res.condition);
          })
          .asFuture() // gRPC streamは try-catchでエラーハンドリングできないので注意
          .then((_) {
            logger.d('Stream completed');
            subscribing = false;
          })
          .onError((e, stackTrace) {
            if (shouldRetry(e)) {
              // server側のWriteTimeoutを超えた場合などを想定しリトライ
              logger.i('Stream retryable error', error: e);
              return;
            }

            subscribing = false;
            logger.e('Stream error', error: e, stackTrace: stackTrace);

            if (e is GrpcError) {
              switch (e.code) {
                case StatusCode.notFound:
                  throw roomNotFoundError;
                default:
                  break;
              }
            }
          });
    }
  }

  @override
  Future<void> leaveRoom(String roomID) async {
    _client.leaveRoom(LeaveRoomRequest()..roomId = roomID);
  }

  @override
  Future<void> castVote(String roomID, Point point) async {
    _client.castVote(CastVoteRequest()
      ..roomId = roomID
      ..point = point);
  }

  @override
  Future<void> resetVotes(String roomID) async {
    _client.resetVotes(ResetVotesRequest()..roomId = roomID);
  }

  @override
  Future<void> showVotes(String roomID) async {
    _client.showVotes(ShowVotesRequest()..roomId = roomID);
  }

  @override
  Future<void> kickUser(String roomID, targetUserID) async {
    _client.kickUser(KickUserRequest()
      ..roomId = roomID
      ..targetUserId = targetUserID);
  }

  @override
  Future<void> updateRoom(String roomID, bool autoOpen) async {
    _client.updateRoom(UpdateRoomRequest()
      ..roomId = roomID
      ..autoOpen = autoOpen);
  }
}
