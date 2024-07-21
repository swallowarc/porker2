import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/data/datasource/local_storage/local_storage.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pb.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:protobuf/protobuf.dart';

part 'user.freezed.dart';

final userNameRegExp = RegExp(r"^[a-zA-Z0-9_-]{1,10}$");

const nameFormatError = FormatException("user name format exception");
final alreadyLoginError =
    UnexpectedError("tried to login with login information");
final alreadyUsedNameError =
    ExpectedError("user name that is already in use has been specified");

@freezed
class UserState with _$UserState {
  const factory UserState(
    String userID,
    String userName,
    String accessToken,
  ) = _UserState;
}

class User extends StateNotifier<UserState> {
  final Porker2ServiceClient _apiCli;
  final LocalStorage _localStorage;

  User(this._apiCli, this._localStorage) : super(const UserState("", "", ""));

  Future<void> login(String userName) async {
    if (state.accessToken.isNotEmpty) {
      throw alreadyLoginError;
    }

    if (!userNameRegExp.hasMatch(userName)) {
      throw nameFormatError;
    }

    try {
      final LoginResponse res =
          await _apiCli.login(LoginRequest(userName: userName));
      state = state.copyWith(
          userName: userName, userID: res.userId, accessToken: res.token);
    } on GrpcError catch (e) {
      if (e.code == StatusCode.alreadyExists) {
        throw alreadyUsedNameError;
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiCli.logout(LogoutRequest());
    state = const UserState("", "", "");
  }

  bool get alreadyLogin => state.accessToken.isNotEmpty;
}
