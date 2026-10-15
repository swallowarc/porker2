import 'package:connectrpc/connect.dart';

const List<Code> retryCodes = [
  Code.unavailable,
  Code.deadlineExceeded,
  Code.canceled,
];

const retryInterval = Duration(seconds: 1);

bool shouldRetry(Object? e) {
  if (e is ConnectException) {
    return retryCodes.contains(e.code);
  }
  // fetch の通信断（server側のWriteTimeoutなど）は ConnectException に包まれず、
  // ブラウザの TypeError("network error") がそのまま届くためリトライする。
  // Dart の Error は実装の不具合なのでリトライしない
  return e != null && e is! Error;
}
