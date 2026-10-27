import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/presentation/router/paths.dart';
import 'package:porker2fe/presentation/router/redirect.dart';

void main() {
  String? redirect({
    required bool isLoggedIn,
    required String? path,
    String roomID = '',
  }) =>
      resolveRedirect(isLoggedIn: isLoggedIn, path: path, roomID: roomID);

  group('logged in', () {
    test('stays on login, room select and a valid poker url', () {
      expect(redirect(isLoggedIn: true, path: loginPath), isNull);
      expect(redirect(isLoggedIn: true, path: roomSelectPath), isNull);
      expect(redirect(isLoggedIn: true, path: pokerPath, roomID: '12345'),
          isNull);
    });

    test('sends an invalid poker url back to room select', () {
      expect(redirect(isLoggedIn: true, path: pokerPath), roomSelectPath);
      expect(redirect(isLoggedIn: true, path: pokerPath, roomID: 'abc'),
          roomSelectPath);
    });
  });

  group('not logged in', () {
    test('stays on login', () {
      expect(redirect(isLoggedIn: false, path: loginPath), isNull);
      expect(redirect(isLoggedIn: false, path: loginPath, roomID: '12345'),
          isNull);
    });

    test('sends other pages to login without a room id', () {
      expect(redirect(isLoggedIn: false, path: roomSelectPath), loginPath);
      expect(redirect(isLoggedIn: false, path: pokerPath), loginPath);
      expect(redirect(isLoggedIn: false, path: pokerPath, roomID: 'abc'),
          loginPath);
      expect(redirect(isLoggedIn: false, path: null), loginPath);
    });

    test('carries a valid room id to the login page', () {
      expect(redirect(isLoggedIn: false, path: pokerPath, roomID: '12345'),
          '/?room-id=12345');
    });
  });
}
