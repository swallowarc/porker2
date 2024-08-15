import 'package:flutter/material.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/core/logger/logger.dart';

typedef ErrorCallback = void Function(String errMessage);

Future<void> invoke<T>(
  BuildContext context,
  Future<T> Function() call,
  void Function(T result) callback,
) async {
  const unexpectedMessage = "An unexpected error has occurred (＠_＠;)";

  await call().then((result) {
    callback(result);
  }).catchError((e) {
    logger.e(e.toString());
    String message = unexpectedMessage;

    switch (e.runtimeType) {
      case FormatException _:
        message = (e as FormatException).message;
        break;
      case ArgumentError _:
        message = (e as ArgumentError).message;
        break;
      case ExpectedError _:
        message = (e as ExpectedError).message;
        break;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  });
}
