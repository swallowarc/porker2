import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:porker2fe/application/port/port.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/application/provider.dart';

/// joinRoom だけを差し替えられる Porker2Service。他のメソッドは呼ばれない想定。
class _FakeService implements Porker2Service {
  final controllers = <String, StreamController<RoomCondition>>{};
  final cancelled = <String>[];

  StreamController<RoomCondition> controllerFor(String roomID) =>
      controllers.putIfAbsent(
        roomID,
        () => StreamController<RoomCondition>(
          onCancel: () => cancelled.add(roomID),
        ),
      );

  @override
  Stream<RoomCondition> joinRoom(String roomID) =>
      controllerFor(roomID).stream;

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
  Future<void> leaveRoom(String roomID) => throw UnimplementedError();

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

RoomCondition _condition(
  String roomID, {
  VoteState voteState = VoteState.VOTE_STATE_HIDE,
  List<Ballot> ballots = const [],
}) =>
    RoomCondition(
      roomId: roomID,
      adminUserId: 'admin',
      voteState: voteState,
      ballots: ballots,
      autoOpen: true,
      displayMode: DisplayMode.DISPLAY_MODE_POINT,
    );

Ballot _ballot(String userID, Point point,
        {UserRole role = UserRole.USER_ROLE_VOTER}) =>
    Ballot(userId: userID, userName: userID, point: point, role: role);

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
      expect(service.controllers.keys, ['11111'], reason: '購読は 1 本のまま');

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

    test('closing a superseded subscription does not clobber the new one',
        () async {
      final notifier = container.read(pokerProvider.notifier);
      // onCancel で close されないよう、broadcast にして古い購読を生かしたまま閉じる
      final first = StreamController<RoomCondition>.broadcast();
      service.controllers['11111'] = first;
      notifier.joinRoom('11111');
      notifier.joinRoom('22222');
      service.controllerFor('22222').add(_condition('22222'));
      await Future<void>.delayed(Duration.zero);

      await first.close();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(pokerProvider).roomID, '22222');
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

  group('derived values', () {
    Future<void> emit(RoomCondition condition) async {
      container.read(pokerProvider.notifier).joinRoom(condition.roomId);
      service.controllerFor(condition.roomId).add(condition);
      await Future<void>.delayed(Duration.zero);
    }

    test('openable requires a hidden state and at least one vote', () async {
      final notifier = container.read(pokerProvider.notifier);
      await emit(_condition('11111', ballots: [
        _ballot('a', Point.POINT_UNSPECIFIED),
      ]));
      expect(notifier.openable, isFalse);

      await emit(_condition('11111', ballots: [
        _ballot('a', Point.POINT_3),
      ]));
      expect(notifier.openable, isTrue);

      await emit(_condition('11111',
          voteState: VoteState.VOTE_STATE_OPEN,
          ballots: [_ballot('a', Point.POINT_3)]));
      expect(notifier.openable, isFalse);
    });

    test('voteAverage ignores observers and non-numeric points', () async {
      final notifier = container.read(pokerProvider.notifier);
      await emit(_condition('11111', ballots: [
        _ballot('a', Point.POINT_3),
        _ballot('b', Point.POINT_5),
        _ballot('c', Point.POINT_QUESTION),
        _ballot('d', Point.POINT_21, role: UserRole.USER_ROLE_OBSERVER),
      ]));
      expect(notifier.voteAverage, 4.0);
      expect(notifier.validVoteCount, 2);
      expect(notifier.observerCount, 1);
    });

    test('isUnanimity needs an open state and two or more equal voter points',
        () async {
      final notifier = container.read(pokerProvider.notifier);
      final same = [_ballot('a', Point.POINT_3), _ballot('b', Point.POINT_3)];

      await emit(_condition('11111', ballots: same));
      expect(notifier.isUnanimity, isFalse, reason: 'hidden');

      await emit(_condition('11111',
          voteState: VoteState.VOTE_STATE_OPEN, ballots: same));
      expect(notifier.isUnanimity, isTrue);

      await emit(_condition('11111',
          voteState: VoteState.VOTE_STATE_OPEN,
          ballots: [...same, _ballot('c', Point.POINT_5)]));
      expect(notifier.isUnanimity, isFalse);

      await emit(_condition('11111',
          voteState: VoteState.VOTE_STATE_OPEN,
          ballots: [
            ...same,
            _ballot('o', Point.POINT_UNSPECIFIED,
                role: UserRole.USER_ROLE_OBSERVER),
          ]));
      expect(notifier.isUnanimity, isTrue, reason: 'observers are ignored');
    });

    test('myPoint and isObserver look up the ballot by user id', () async {
      final notifier = container.read(pokerProvider.notifier);
      await emit(_condition('11111', ballots: [
        _ballot('a', Point.POINT_8),
        _ballot('o', Point.POINT_UNSPECIFIED,
            role: UserRole.USER_ROLE_OBSERVER),
      ]));
      expect(notifier.myPoint('a'), Point.POINT_8);
      expect(notifier.myPoint('zzz'), Point.POINT_UNSPECIFIED);
      expect(notifier.isObserver('o'), isTrue);
      expect(notifier.isObserver('a'), isFalse);
    });
  });
}
