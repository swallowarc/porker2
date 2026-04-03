import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:porker2fe/core/error/error.dart';

part 'user.freezed.dart';

final userNameFormatRegExp = RegExp(r"^[a-zA-Z0-9_-]{1,10}$");

const nameFormatError = FormatException(
  "invalid username format",
);

final alreadyUsedNameError = ExpectedError(
  "the name is already in use by another user",
);

@freezed
abstract class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    required String userID,
    required String userName,
  }) = _UserEntity;

  bool get valid => userID.isNotEmpty && userName.isNotEmpty;
}
