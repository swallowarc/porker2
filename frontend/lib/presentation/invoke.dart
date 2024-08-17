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

    bool isExpectedError = false;

    if (e is ExpectedError) {
      message = e.message;
      isExpectedError = true;
    }

    if (e is FormatException) {
      message = e.message;
    }

    if (e is ArgumentError) {
      message = e.message;
    }

    Color snackBackgroundColor = Colors.red.shade200;
    if (isExpectedError) {
      snackBackgroundColor = Colors.yellow.shade200;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: snackBackgroundColor,
    ));
  });
}
