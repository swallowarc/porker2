import 'package:porker2fe/core/error/error.dart';

final userNameRegExp = RegExp(r"^[a-zA-Z0-9_-]{1,10}$");

const nameFormatError = FormatException(
  "user name format exception",
);

final alreadyLoginError = UnexpectedError(
  "tried to login with login information",
);

final alreadyUsedNameError = ExpectedError(
  "user name that is already in use has been specified",
);
