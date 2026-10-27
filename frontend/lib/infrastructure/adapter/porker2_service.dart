import 'dart:async';

import 'package:connectrpc/connect.dart';
import 'package:porker2fe/core/error/retry.dart' as retry;
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.connect.client.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.pb.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/application/port/port.dart';

class Porker2ServiceImpl extends Porker2Service {
  final Porker2ServiceClient _client;
  final Duration _retryInterval;

  Porker2ServiceImpl(this._client, {Duration? retryInterval})
      : _retryInterval = retryInterval ?? retry.retryInterval;

  @override
  Future<LoginResult> login(String userName) async {
    try {
      final res = await _client.login(LoginRequest()
        ..userName = userName);
      return (userID: res.userId); // tokenはcookieに保存される
    } on ConnectException catch (e) {
      throw (e.code == Code.alreadyExists) ? alreadyUsedNameError : e;
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
    } on ConnectException catch (e) {
      throw _roomError(e);
    }
  }

  /// 部屋の状態を購読する。リトライ対象のエラー (サーバーの WriteTimeout など) では
  /// 間を置いて再接続する。購読が cancel されたら、進行中のリクエストを中断し、再接続もしない
  /// (async* だと cancel が次の yield まで効かず、cancel 後に JoinRoom を呼び直して
  /// 退室した部屋へ入り直してしまう)。
  @override
  Stream<RoomCondition> joinRoom(String roomID) {
    late final StreamController<RoomCondition> controller;
    CancelableSignal? signal;
    Timer? retryTimer;
    var cancelled = false;

    void connect() {
      if (cancelled) return;
      signal = CancelableSignal();
      _client.joinRoom(JoinRoomRequest(roomId: roomID), signal: signal).listen(
        (res) {
          if (!cancelled) controller.add(res.condition);
        },
        onError: (Object e, StackTrace stackTrace) {
          // cancel 後は signal の中断で Canceled が届く。購読者はもういないので捨てる
          if (cancelled) return;
          if (retry.shouldRetry(e)) {
            logger.i('Stream retryable error', error: e);
            retryTimer = Timer(_retryInterval, connect);
            return;
          }
          controller.addError((e is ConnectException) ? _roomError(e) : e, stackTrace);
          controller.close();
        },
        onDone: () {
          if (cancelled) return;
          // サーバーが購読を終えた (退室・キックなど)
          logger.d('Stream completed');
          controller.close();
        },
        cancelOnError: true,
      );
    }

    controller = StreamController<RoomCondition>(
      onListen: connect,
      onCancel: () {
        cancelled = true;
        retryTimer?.cancel();
        // リクエストを中断する。内側の購読は中断エラーで自然に終わる
        // (cancel() の完了を待つと、応答が来るまで購読の cancel が返らない)
        signal?.cancel();
      },
    );
    return controller.stream;
  }

  /// 部屋に対する操作で返るエラーのうち、利用者に見せるものを ExpectedError に変換する
  Exception _roomError(ConnectException e) {
    switch (e.code) {
      case Code.notFound:
        return roomNotFoundError;
      case Code.failedPrecondition:
        return roomFullError;
      default:
        return e;
    }
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
