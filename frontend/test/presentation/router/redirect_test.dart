import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/presentation/router/paths.dart';
import 'package:porker2fe/presentation/router/redirect.dart';

void main() {
  late List<String> parked;
  String? redirect({
    required bool isLoggedIn,
    required String? path,
    String roomID = '',
  }) =>
      resolveRedirect(
        isLoggedIn: isLoggedIn,
        path: path,
        roomID: roomID,
        parkRoomID: parked.add,
      );

  setUp(() => parked = []);

  group('logged in', () {
    test('stays on login, room select and a valid poker url', () {
      expect(redirect(isLoggedIn: true, path: loginPath), isNull);
      expect(redirect(isLoggedIn: true, path: roomSelectPath), isNull);
      expect(redirect(isLoggedIn: true, path: pokerPath, roomID: '12345'),
          isNull);
      expect(parked, isEmpty);
    });

    test('sends an invalid poker url back to room select', () {
      expect(redirect(isLoggedIn: true, path: pokerPath), roomSelectPath);
      expect(redirect(isLoggedIn: true, path: pokerPath, roomID: 'abc'),
          roomSelectPath);
      expect(parked, isEmpty);
    });
  });

  group('not logged in', () {
    test('stays on login', () {
      expect(redirect(isLoggedIn: false, path: loginPath), isNull);
    });

    test('sends other pages to login without parking a room', () {
      expect(redirect(isLoggedIn: false, path: roomSelectPath), loginPath);
      expect(redirect(isLoggedIn: false, path: pokerPath), loginPath);
      expect(redirect(isLoggedIn: false, path: pokerPath, roomID: 'abc'),
          loginPath);
      expect(redirect(isLoggedIn: false, path: null), loginPath);
      expect(parked, isEmpty);
    });

    test('parks a valid room id before sending to login', () {
      expect(redirect(isLoggedIn: false, path: pokerPath, roomID: '12345'),
          loginPath);
      expect(parked, ['12345']);
    });
  });
}
