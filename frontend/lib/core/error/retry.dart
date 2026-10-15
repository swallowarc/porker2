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
  // ブラウザの TypeError("network error") が JS の値のまま届く。
  // JS の値は Dart の Error にも Exception にも該当しないので、それだけをリトライする
  return e != null && e is! Error && e is! Exception;
}
