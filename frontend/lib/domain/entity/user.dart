import 'package:porker2fe/core/error/error.dart';

final userNameFormatRegExp = RegExp(r"^[a-zA-Z0-9_-]{1,10}$");

const nameFormatError = FormatException(
  "invalid username format",
);

final alreadyLoginError = UnexpectedError(
  "tried to login with login information",
);

final alreadyUsedNameError = ExpectedError(
  "the name is already in use by another user",
);

class UserEntity {
  final String userID;
  final String userName;

  UserEntity({
    required this.userID,
    required this.userName,
  });

  bool get valid => userID.isNotEmpty && userName.isNotEmpty;
}
