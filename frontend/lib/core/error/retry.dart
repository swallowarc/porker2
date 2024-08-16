import 'package:grpc/grpc_web.dart';

const List<int> retryCodes = [
  StatusCode.unavailable,
  StatusCode.deadlineExceeded,
  StatusCode.cancelled,
];

bool shouldRetry(Object? e) {
  if (e is GrpcError) {
    return retryCodes.contains(e.code);
  }
  return false;
}
