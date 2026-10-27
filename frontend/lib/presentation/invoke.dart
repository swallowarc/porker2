import 'package:material_ui/material_ui.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/presentation/router/router.dart';

/// [call] を実行し、成功したら [callback] を呼ぶ。
/// 失敗した場合はエラーをスナックバーで表示し、[onError] があれば呼ぶ。
/// ただし Unauthenticated はログイン画面へ戻し、[onError] は呼ばない。
Future<void> invoke<T>(
  BuildContext context,
  Future<T> Function() call,
  void Function(T result) callback, {
  void Function()? onError,
}) async {
  const unexpectedMessage = "An unexpected error has occurred (＠_＠;)";

  await call().then((result) {
    // 画面遷移を伴う callback が、呼び出し中に破棄された画面の context で動かないようにする
    if (context.mounted) {
      callback(result);
    }
  }).catchError((e) {
    if (e is UnauthenticatedError) {
      logger.w("session is invalid, back to login");
      if (context.mounted) {
        LoginRoute().go(context);
      }
      return;
    }

    logger.e(e.toString());
    String message = unexpectedMessage;
    bool isExpectedError = false;

    if (e is ExpectedError) {
      message = e.message;
      isExpectedError = true;
    } else if (e is FormatException) {
      message = e.message;
    } else if (e is ArgumentError) {
      message = e.message;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor:
            isExpectedError ? Colors.yellow.shade200 : Colors.red.shade200,
      ));
      onError?.call();
    }
  });
}
