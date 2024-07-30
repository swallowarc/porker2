import 'package:flutter/material.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/core/logger/logger.dart';

typedef ErrorCallback = void Function(String errMessage);

Future<void> invoke(
  BuildContext context,
  Future<void> Function() call,
  void Function() callback,
) async {
  const unexpectedMessage = "An unexpected error has occurred (＠_＠;)";

  await call().then((_) {
    callback();
  }).catchError((e) {
    logger.e(e.toString());
    String message = unexpectedMessage;

    switch (e.runtimeType) {
      case FormatException _:
        message = e.message;
        break;
      case ArgumentError _:
        message = e.message;
        break;
      case ExpectedError _:
        message = e.message;
        break;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  });
}
