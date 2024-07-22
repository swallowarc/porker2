import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';

class LoginResult {
  final String userID;
  final String token;

  LoginResult({required this.userID, required this.token});
}

abstract class Porker2ServiceRepository {
  Future<LoginResult> login(String userName);

  Future<void> logout();

  Future<void> kickUser(String roomID, targetUserID);

  Future<String> createRoom();

  Future<void> joinRoom(String roomID, Function(RoomCondition rc) callback);

  Future<void> leaveRoom(String roomID);

  Future<void> castVote(String roomID, Point point);

  Future<void> showVotes(String roomID);

  Future<void> resetVotes(String roomID);
}

abstract class LocalStorageRepository {
  Future<String> getUserName();

  Future<void> setUserName(String token);
}
