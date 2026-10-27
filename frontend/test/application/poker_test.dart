import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:porker2fe/application/port/port.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/application/provider.dart';

/// joinRoom / leaveRoom だけを差し替えられる Porker2Service。他のメソッドは呼ばれない想定。
class _FakeService implements Porker2Service {
  /// 部屋ごとの最新の購読。joinRoom を呼ぶたびに新しい StreamController を作る
  final controllers = <String, StreamController<Room>>{};
  final joinCalls = <String>[];
  final cancelled = <String>[];
  final left = <String>[];
  Object? leaveError;

  StreamController<Room> controllerFor(String roomID) =>
      controllers[roomID]!;

  @override
  Stream<Room> joinRoom(String roomID) {
    joinCalls.add(roomID);
    final controller = StreamController<Room>(
      onCancel: () => cancelled.add(roomID),
    );
    controllers[roomID] = controller;
    return controller.stream;
  }

  @override
  Future<void> leaveRoom(String roomID) async {
    if (leaveError != null) throw leaveError!;
    left.add(roomID);
  }

  @override
  Future<LoginResult> login(String userName) => throw UnimplementedError();

  @override
  Future<void> logout() => throw UnimplementedError();

  @override
  Future<UserEntity> verifyUser() => throw UnimplementedError();

  @override
  Future<String> createRoom() => throw UnimplementedError();

  @override
  Future<void> checkRoom(String roomID) => throw UnimplementedError();

  @override
  Future<void> castVote(String roomID, Point point) =>
      throw UnimplementedError();

  @override
  Future<void> showVotes(String roomID) => throw UnimplementedError();

  @override
  Future<void> resetVotes(String roomID) => throw UnimplementedError();

  @override
  Future<void> kickUser(String roomID, String targetUserID) =>
      throw UnimplementedError();

  @override
  Future<void> updateRoom(
          String roomID, bool autoOpen, DisplayMode displayMode) =>
      throw UnimplementedError();

  @override
  Future<void> toggleObserverMode(String roomID, bool isObserver) =>
      throw UnimplementedError();
}

Room _condition(
  String roomID, {
  VoteState voteState = VoteState.hide,
  List<Ballot> ballots = const [],
}) =>
    Room(
      roomID: roomID,
      adminUserID: 'admin',
      voteState: voteState,
      ballots: ballots,
      autoOpen: true,
      displayMode: DisplayMode.point,
    );

Ballot _ballot(String userID, Point point, {UserRole role = UserRole.voter}) =>
    Ballot(userID: userID, userName: userID, point: point, role: role);

void main() {
  late _FakeService service;
  late ProviderContainer container;

  setUpAll(() {
    // logger は初回アクセス時に Logger.level を上書きするので、先に初期化してから黙らせる
    logger.hashCode;
    Logger.level = Level.off;
  });

  setUp(() {
    service = _FakeService();
    container = ProviderContainer(
      overrides: [porker2ServiceProvider.overrideWithValue(service)],
    );
    addTearDown(container.dispose);
  });

  group('joinRoom', () {
    test('reflects stream events into state and resets when stream closes',
        () async {
      final notifier = container.read(pokerProvider.notifier);
      final done = notifier.joinRoom('11111');

      service.controllerFor('11111').add(_condition('11111'));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(pokerProvider).roomID, '11111');

      await service.controllerFor('11111').close();
      await done;
      expect(container.read(pokerProvider).roomID, '');
    });

    test('returns the same pending future when the room is already subscribed',
        () async {
      final notifier = container.read(pokerProvider.notifier);
      final first = notifier.joinRoom('11111');
      var secondDone = false;
      final second = notifier.joinRoom('11111').then((_) => secondDone = true);

      await Future<void>.delayed(Duration.zero);
      expect(secondDone, isFalse, reason: '再入室は購読の終了を待つ');
      expect(service.joinCalls, ['11111'], reason: '購読は 1 本のまま');

      await service.controllerFor('11111').close();
      await Future.wait([first, second]);
      expect(secondDone, isTrue);
    });

    test('switching rooms cancels the previous subscription', () async {
      final notifier = container.read(pokerProvider.notifier);
      notifier.joinRoom('11111');
      service.controllerFor('11111').add(_condition('11111'));
      await Future<void>.delayed(Duration.zero);

      final second = notifier.joinRoom('22222');
      await Future<void>.delayed(Duration.zero);
      expect(service.cancelled, ['11111']);

      service.controllerFor('22222').add(_condition('22222'));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(pokerProvider).roomID, '22222');

      await service.controllerFor('22222').close();
      await second;
      expect(container.read(pokerProvider).roomID, '');
    });

    test('propagates stream errors and resets state', () async {
      final notifier = container.read(pokerProvider.notifier);
      final done = notifier.joinRoom('11111');
      service.controllerFor('11111').add(_condition('11111'));
      await Future<void>.delayed(Duration.zero);

      service.controllerFor('11111').addError(roomNotFoundError);
      await expectLater(done, throwsA(same(roomNotFoundError)));
      expect(container.read(pokerProvider).roomID, '');
    });
  });

  group('leaveRoom', () {
    test('cancels the subscription and resets state without waiting for the server',
        () async {
      final notifier = container.read(pokerProvider.notifier);
      notifier.joinRoom('11111');
      service.controllerFor('11111').add(_condition('11111'));
      await Future<void>.delayed(Duration.zero);

      await notifier.leaveRoom();
      expect(service.left, ['11111']);
      expect(service.cancelled, ['11111']);
      expect(container.read(pokerProvider).roomID, '');

      // 退室後は同じ部屋に入り直せる (古い購読が残っていない)
      notifier.joinRoom('11111');
      expect(service.joinCalls, ['11111', '11111']);
    });

    test('keeps the subscription when the server rejects leaving', () async {
      final notifier = container.read(pokerProvider.notifier);
      notifier.joinRoom('11111');
      service.controllerFor('11111').add(_condition('11111'));
      await Future<void>.delayed(Duration.zero);

      service.leaveError = StateError('boom');
      await expectLater(notifier.leaveRoom(), throwsStateError);
      expect(service.cancelled, isEmpty);
      expect(container.read(pokerProvider).roomID, '11111');
    });
  });

  group('derived values', () {
    Future<void> emit(Room condition) async {
      container.read(pokerProvider.notifier).joinRoom(condition.roomID);
      service.controllerFor(condition.roomID).add(condition);
      await Future<void>.delayed(Duration.zero);
    }

    test('openable requires a hidden state and at least one vote', () async {
      final notifier = container.read(pokerProvider.notifier);
      await emit(_condition('11111', ballots: [
        _ballot('a', Point.unspecified),
      ]));
      expect(notifier.openable, isFalse);

      await emit(_condition('11111', ballots: [
        _ballot('a', Point.p3),
      ]));
      expect(notifier.openable, isTrue);

      await emit(_condition('11111',
          voteState: VoteState.open,
          ballots: [_ballot('a', Point.p3)]));
      expect(notifier.openable, isFalse);
    });

    test('voteAverage ignores observers and non-numeric points', () async {
      final notifier = container.read(pokerProvider.notifier);
      await emit(_condition('11111', ballots: [
        _ballot('a', Point.p3),
        _ballot('b', Point.p5),
        _ballot('c', Point.question),
        _ballot('d', Point.p21, role: UserRole.observer),
      ]));
      expect(notifier.voteAverage, 4.0);
      expect(notifier.validVoteCount, 2);
      expect(notifier.observerCount, 1);
    });

    test('isUnanimity needs an open state and two or more equal voter points',
        () async {
      final notifier = container.read(pokerProvider.notifier);
      final same = [_ballot('a', Point.p3), _ballot('b', Point.p3)];

      await emit(_condition('11111', ballots: same));
      expect(notifier.isUnanimity, isFalse, reason: 'hidden');

      await emit(_condition('11111',
          voteState: VoteState.open, ballots: same));
      expect(notifier.isUnanimity, isTrue);

      await emit(_condition('11111',
          voteState: VoteState.open,
          ballots: [...same, _ballot('c', Point.p5)]));
      expect(notifier.isUnanimity, isFalse);

      await emit(_condition('11111',
          voteState: VoteState.open,
          ballots: [
            ...same,
            _ballot('o', Point.unspecified,
                role: UserRole.observer),
          ]));
      expect(notifier.isUnanimity, isTrue, reason: 'observers are ignored');
    });

    test('myPoint and isObserver look up the ballot by user id', () async {
      final notifier = container.read(pokerProvider.notifier);
      await emit(_condition('11111', ballots: [
        _ballot('a', Point.p8),
        _ballot('o', Point.unspecified,
            role: UserRole.observer),
      ]));
      expect(notifier.myPoint('a'), Point.p8);
      expect(notifier.myPoint('zzz'), Point.unspecified);
      expect(notifier.isObserver('o'), isTrue);
      expect(notifier.isObserver('a'), isFalse);
    });
  });
}
