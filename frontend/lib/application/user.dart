import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/application/port/port.dart';

part 'user.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState(
    String userID,
    String userName,
  ) = _UserState;
}

class User extends Notifier<UserState> {
  late final Porker2Service _svcRepo;
  late final LocalStorage _storageRepo;

  @override
  UserState build() {
    _svcRepo = ref.read(porker2ServiceProvider);
    _storageRepo = ref.read(localStorageProvider);
    return const UserState("", "");
  }

  Future<void> login(String userName) async {
    if (!userNameFormatRegExp.hasMatch(userName)) {
      throw nameFormatError;
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

  /// セッションが有効ならユーザー情報を復元して true を返す。
  /// 未ログインや通信失敗は false (ログイン画面に留まる)。
  Future<bool> verifyUser() async {
    try {
      final user = await _svcRepo.verifyUser();
      state = state.copyWith(
        userID: user.userID,
        userName: user.userName,
      );
      return true;
    } on UnauthenticatedError {
      return false;
    } catch (e, stackTrace) {
      logger.e("verify user failed", error: e, stackTrace: stackTrace);
      return false;
    }
  }

  bool get alreadyLogin => state.userID.isNotEmpty;

  /// 前回ログインに使った名前。なければ空文字。
  Future<String> latestUserName() => _storageRepo.getUserName();
}
