import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/domain/user.dart';

typedef LoginResult = ({String userID});

/// バックエンドとの通信ポート。
///
/// 実装は通信ライブラリ固有の例外を外に出さず、次のいずれかを投げる:
/// - [UnauthenticatedError]: セッションが無効
/// - [ExpectedError]: 利用者に見せる想定内の失敗 (部屋がない・満員・名前が使用中)
/// - [UnexpectedError]: それ以外
abstract class Porker2Service {
  Future<LoginResult> login(String userName);

  Future<void> logout();

  Future<UserEntity> verifyUser();

  Future<String> createRoom();

  Future<void> checkRoom(String roomID);

  Stream<RoomCondition> joinRoom(String roomID);

  Future<void> leaveRoom(String roomID);

  Future<void> castVote(String roomID, Point point);

  Future<void> showVotes(String roomID);

  Future<void> resetVotes(String roomID);

  Future<void> kickUser(String roomID, String targetUserID);

  Future<void> updateRoom(String roomID, bool autoOpen, DisplayMode displayMode);

  Future<void> toggleObserverMode(String roomID, bool isObserver);
}

abstract class LocalStorage {
  Future<String> getUserName();

  Future<void> setUserName(String name);
}
