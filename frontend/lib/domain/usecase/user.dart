import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/domain/entity/user.dart';
import 'package:porker2fe/domain/port/repository.dart';

part 'user.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState(
    String userID,
    String userName,
    String accessToken,
  ) = _UserState;
}

class User extends StateNotifier<UserState> {
  final Porker2ServiceRepository _svcRepo;
  final LocalStorageRepository _storageRepo;

  User(this._svcRepo, this._storageRepo) : super(const UserState("", "", ""));

  Future<void> login(String userName) async {
    if (state.accessToken.isNotEmpty) {
      throw alreadyLoginError;
    }

    if (!userNameRegExp.hasMatch(userName)) {
      throw nameFormatError;
    }

    final result = await _svcRepo.login(userName);
    state = state.copyWith(
      userName: userName,
      userID: result.userID,
      accessToken: result.token,
    );

    await _storageRepo.setUserName(userName);
  }

  Future<void> logout() async {
    await _svcRepo.logout();
    state = const UserState("", "", "");
  }

  bool get alreadyLogin => state.accessToken.isNotEmpty;
}