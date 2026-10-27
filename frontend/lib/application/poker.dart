import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/application/port/port.dart';

/// 購読中の部屋。購読の終了は [done] で待てる。
class _RoomSubscription {
  _RoomSubscription(this.roomID);

  final String roomID;
  final done = Completer<void>();
  StreamSubscription<Room>? subscription;

  void cancel() {
    subscription?.cancel();
    subscription = null;
  }
}

/// 今いる部屋の状態。入っていなければ [Room.empty]。
class Poker extends Notifier<Room> {
  late final Porker2Service _svcRepo;

  _RoomSubscription? _current;

  @override
  Room build() {
    _svcRepo = ref.read(porker2ServiceProvider);
    ref.onDispose(() => _current?.cancel());
    return Room.empty;
  }

  Future<String> createRoom() async {
    return _svcRepo.createRoom();
  }

  Future<void> checkRoom(String roomId) async {
    await _svcRepo.checkRoom(roomId);
  }

  /// 部屋の状態を購読する。返す Future は購読が終わる (退室・キック・エラー) まで完了しない。
  /// 既に同じ部屋を購読中ならその購読の終了を待つ Future を返す (画面を開き直した場合)。
  /// 別の部屋を購読中ならそちらを打ち切って入り直す。打ち切られた側の Future は完了しない
  /// (完了させると古い画面の遷移処理が走ってしまう)。
  /// 購読がエラーで終わった場合はそのエラーを投げる。
  Future<void> joinRoom(String roomId) {
    final current = _current;
    if (current != null && current.roomID == roomId) {
      logger.d("already subscribing: $roomId");
      return current.done.future;
    }
    current?.cancel();

    final next = _RoomSubscription(roomId);
    _current = next;
    next.subscription = _svcRepo.joinRoom(roomId).listen(
      (room) {
        logger.d("subscribe room condition: $room");
        state = room;
      },
      onError: (Object error, StackTrace stackTrace) {
        logger.e("subscribe room condition error: $error",
            error: error, stackTrace: stackTrace);
        _finish(next);
        next.done.completeError(error, stackTrace);
      },
      onDone: () {
        logger.d("unsubscribe room condition");
        _finish(next);
        next.done.complete();
      },
      cancelOnError: true,
    );

    return next.done.future;
  }

  /// 購読の終了処理。cancel 済みの購読では onDone / onError は呼ばれないので
  /// identical の確認は防御的なもの (別の部屋へ入り直した後に古い購読の終了処理が走っても壊さない)。
  void _finish(_RoomSubscription finished) {
    if (!identical(_current, finished)) {
      return;
    }
    _current = null;
    state = Room.empty;
  }

  /// 退室する。成功したら購読を打ち切って状態を空にする。
  /// サーバーからの購読終了を待たない (部屋が TTL 切れで消えていると更新が配信されず、
  /// WriteTimeout まで終わらない)。打ち切った購読の joinRoom の Future は完了しない。
  Future<void> leaveRoom() async {
    await _svcRepo.leaveRoom(state.roomID);
    _current?.cancel();
    _current = null;
    state = Room.empty;
  }

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
}
