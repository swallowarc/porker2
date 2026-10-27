import 'dart:async';

import 'package:connectrpc/connect.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/infrastructure/adapter/retry.dart' as retry;
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.connect.client.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.pb.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/application/port/port.dart';

/// Porker2Service の Connect RPC 実装。
/// ConnectException はここで application 層のエラー型に変換し、外へ漏らさない。
class Porker2ServiceImpl extends Porker2Service {
  final Porker2ServiceClient _client;
  final Duration _retryInterval;

  Porker2ServiceImpl(this._client, {Duration? retryInterval})
      : _retryInterval = retryInterval ?? retry.retryInterval;

  @override
  Future<LoginResult> login(String userName) => _call(() async {
        final res = await _client.login(LoginRequest()..userName = userName);
        return (userID: res.userId); // tokenはcookieに保存される
      }, (e) => e.code == Code.alreadyExists ? alreadyUsedNameError : null);

  @override
  Future<void> logout() => _call(() => _client.logout(LogoutRequest()));

  @override
  Future<UserEntity> verifyUser() => _call(() async {
        final res = await _client.verifyUser(VerifyUserRequest());
        return UserEntity(userID: res.userId, userName: res.userName);
      });

  @override
  Future<String> createRoom() => _call(() async {
        final res = await _client.createRoom(CreateRoomRequest());
        return res.roomId;
      });

  @override
  Future<void> checkRoom(String roomID) => _call(
        () => _client.checkRoom(CheckRoomRequest()..roomId = roomID),
        _roomError,
      );

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
          controller.addError(_translate(e, _roomError), stackTrace);
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

  @override
  Future<void> leaveRoom(String roomID) =>
      _call(() => _client.leaveRoom(LeaveRoomRequest()..roomId = roomID));

  @override
  Future<void> castVote(String roomID, Point point) => _call(() => _client
      .castVote(CastVoteRequest()
        ..roomId = roomID
        ..point = point));

  @override
  Future<void> resetVotes(String roomID) =>
      _call(() => _client.resetVotes(ResetVotesRequest()..roomId = roomID));

  @override
  Future<void> showVotes(String roomID) =>
      _call(() => _client.showVotes(ShowVotesRequest()..roomId = roomID));

  @override
  Future<void> kickUser(String roomID, String targetUserID) =>
      _call(() => _client.kickUser(KickUserRequest()
        ..roomId = roomID
        ..targetUserId = targetUserID));

  @override
  Future<void> updateRoom(
          String roomID, bool autoOpen, DisplayMode displayMode) =>
      _call(() => _client.updateRoom(UpdateRoomRequest()
        ..roomId = roomID
        ..autoOpen = autoOpen
        ..displayMode = displayMode));

  @override
  Future<void> toggleObserverMode(String roomID, bool isObserver) =>
      _call(() => _client.toggleObserverMode(ToggleObserverModeRequest()
        ..roomId = roomID
        ..isObserver = isObserver));

  /// RPC を呼び、失敗したら application 層のエラー型に変換して投げ直す。
  /// [specific] は RPC 固有の変換 (該当しなければ null を返す)。
  Future<T> _call<T>(
    Future<T> Function() rpc, [
    Exception? Function(ConnectException e)? specific,
  ]) async {
    try {
      return await rpc();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(_translate(e, specific), stackTrace);
    }
  }

  /// 部屋に対する操作で返るエラーのうち、利用者に見せるものを ExpectedError に変換する
  Exception? _roomError(ConnectException e) {
    switch (e.code) {
      case Code.notFound:
        return roomNotFoundError;
      case Code.failedPrecondition:
        return roomFullError;
      default:
        return null;
    }
  }

  Object _translate(
    Object e,
    Exception? Function(ConnectException e)? specific,
  ) {
    if (e is Error) {
      // プログラムの不具合はそのまま伝える
      return e;
    }
    if (e is! ConnectException) {
      return UnexpectedError('request failed', e);
    }
    if (e.code == Code.unauthenticated) {
      return const UnauthenticatedError();
    }
    return specific?.call(e) ?? UnexpectedError('rpc failed: ${e.code.name}', e);
  }
}
