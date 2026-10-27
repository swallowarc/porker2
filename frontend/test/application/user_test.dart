import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:porker2fe/application/port/port.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/application/user.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';

class _FakeService implements Porker2Service {
  Object? verifyError;
  Object? loginError;
  final loginCalls = <String>[];

  @override
  Future<UserEntity> verifyUser() async {
    if (verifyError != null) throw verifyError!;
    return const UserEntity(userID: 'u1', userName: 'bob');
  }

  @override
  Future<LoginResult> login(String userName) async {
    loginCalls.add(userName);
    if (loginError != null) throw loginError!;
    return (userID: 'u-$userName');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<String> createRoom() => throw UnimplementedError();
  @override
  Future<void> checkRoom(String roomID) => throw UnimplementedError();
  @override
  Stream<Room> joinRoom(String roomID) => throw UnimplementedError();
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

class _FakeStorage implements LocalStorage {
  String name = '';
  @override
  Future<String> getUserName() async => name;
  @override
  Future<void> setUserName(String name) async => this.name = name;
}

void main() {
  late _FakeService service;
  late _FakeStorage storage;
  late ProviderContainer container;

  setUpAll(() {
    logger.hashCode;
    Logger.level = Level.off;
  });

  setUp(() {
    service = _FakeService();
    storage = _FakeStorage();
    container = ProviderContainer(overrides: [
      porker2ServiceProvider.overrideWithValue(service),
      localStorageProvider.overrideWithValue(storage),
    ]);
    addTearDown(container.dispose);
  });

  group('verifyUser', () {
    test('restores the user when the session is valid', () async {
      expect(await container.read(userProvider.notifier).verifyUser(), isTrue);
      final state = container.read(userProvider);
      expect(state.isLoggedIn, isTrue);
      expect(state.userName, 'bob');
    });

    test('returns false and stays logged out when unauthenticated', () async {
      service.verifyError = const UnauthenticatedError();
      expect(await container.read(userProvider.notifier).verifyUser(), isFalse);
      expect(container.read(userProvider).isLoggedIn, isFalse);
    });

    test('returns false on any other failure', () async {
      service.verifyError = UnexpectedError('down');
      expect(await container.read(userProvider.notifier).verifyUser(), isFalse);
      expect(container.read(userProvider).isLoggedIn, isFalse);
    });
  });

  group('login', () {
    test('rejects an invalid name before calling the server', () async {
      await expectLater(container.read(userProvider.notifier).login('bad name!'),
          throwsFormatException);
      expect(service.loginCalls, isEmpty);
    });

    test('stores the name and user id on success', () async {
      await container.read(userProvider.notifier).login('bob');
      expect(container.read(userProvider),
          const UserState('u-bob', 'bob'));
      expect(storage.name, 'bob');
    });

    test('logout clears the state', () async {
      await container.read(userProvider.notifier).login('bob');
      await container.read(userProvider.notifier).logout();
      expect(container.read(userProvider).isLoggedIn, isFalse);
    });
  });
}
