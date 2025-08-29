import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/entity/user.dart';

class LoginResult {
  final String userID;

  LoginResult({required this.userID});
}

abstract class Porker2ServiceRepository {
  Future<LoginResult> login(String userName);

  Future<void> logout();

  Future<UserEntity> verifyUser();

  Future<String> createRoom();

  Future<void> checkRoom(String roomID);

  Future<void> joinRoom(String roomID, Function(RoomCondition rc) callback);

  Future<void> leaveRoom(String roomID);

  Future<void> castVote(String roomID, Point point);

  Future<void> showVotes(String roomID);

  Future<void> resetVotes(String roomID);

  Future<void> kickUser(String roomID, targetUserID);

  Future<void> updateRoom(String roomID, bool autoOpen, DisplayMode displayMode);
}

abstract class LocalStorageRepository {
  Future<String> getUserName();

  Future<void> setUserName(String name);
}
