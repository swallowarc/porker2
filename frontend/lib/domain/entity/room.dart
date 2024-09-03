import 'package:porker2fe/core/error/error.dart';

final roomIDFormatRegExp = RegExp(r"^[0-9]{5}$");

final roomNotFoundError = ExpectedError(
  "Room not found",
);
