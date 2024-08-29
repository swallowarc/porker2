import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/entity/user.dart';
import 'package:porker2fe/domain/port/repository.dart';

part 'user.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState(
    String userID,
    String userName,
  ) = _UserState;
}

class User extends StateNotifier<UserState> {
  final Porker2ServiceRepository _svcRepo;
  final LocalStorageRepository _storageRepo;

  User(this._svcRepo, this._storageRepo) : super(const UserState("", ""));

  Future<void> login(String userName) async {
    if (!userNameFormatRegExp.hasMatch(userName)) {
      throw nameFormatError;
    }

    if (state.userID.isNotEmpty) {
      throw alreadyLoginError;
    }

    final result = await _svcRepo.login(userName);

    state = state.copyWith(
      userName: userName,
      userID: result.userID,
    );

    await _storageRepo.setUserName(userName);
  }

  Future<void> logout() async {
    await _svcRepo.logout();
    state = const UserState("", "");
  }

  Future<bool> verifyUser() async {
    try {
      final user = await _svcRepo.verifyUser();
      state = state.copyWith(
        userID: user.userID,
        userName: user.userName,
      );
      return true;
    } catch (e) {
      if (e is GrpcError && e.code == StatusCode.unauthenticated) {
        return false;
      } else {
        logger.e(e.toString());
        return false;
      }
    }
  }

  bool get alreadyLogin => state.userID.isNotEmpty;

  Future<String> latestUserName() async {
    final userName = await _storageRepo.getUserName();
    if (userName.isNotEmpty) {
      return userName;
    }

    return "";
  }
}
