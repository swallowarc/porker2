import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/core/logger/logger.dart';

typedef ErrorCallback = void Function(String errMessage);

Future<void> errorHandle(
    Future<void> Function() call, ErrorCallback errCallBack) async {
  const unexpectedMessage = "An unexpected error has occurred";

  try {
    call();
  } on FormatException catch (e) {
    errCallBack(e.message);
  } on ArgumentError catch (e) {
    errCallBack(e.message);
  } on ExpectedError catch (e) {
    errCallBack(e.message);
  } on UnexpectedError catch (e) {
    logger.e(e.toString(), error: e.cause);
    errCallBack(unexpectedMessage);
  } catch (e) {
    logger.e(e.toString());
    errCallBack(unexpectedMessage);
    rethrow;
  }
}
