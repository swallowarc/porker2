import 'package:connectrpc/connect.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/infrastructure/adapter/retry.dart';

void main() {
  group('shouldRetry', () {
    test('retries ConnectException with retryable codes', () {
      for (final code in retryCodes) {
        expect(shouldRetry(ConnectException(code, 'retryable')), isTrue,
            reason: code.name);
      }
    });

    test('does not retry ConnectException with other codes', () {
      final others = Code.values.where((c) => !retryCodes.contains(c));
      for (final code in others) {
        expect(shouldRetry(ConnectException(code, 'not retryable')), isFalse,
            reason: code.name);
      }
    });

    test('retries values that are neither Error nor Exception', () {
      // ブラウザの TypeError のように JS の値のまま届く例外の代わり
      expect(shouldRetry(Object()), isTrue);
    });

    test('does not retry Dart Exception', () {
      expect(shouldRetry(const FormatException('bad')), isFalse);
    });

    test('does not retry Dart Error', () {
      expect(shouldRetry(StateError('bug')), isFalse);
    });

    test('does not retry null', () {
      expect(shouldRetry(null), isFalse);
    });
  });
}
