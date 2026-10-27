import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/presentation/router/paths.dart';

/// GoRouter の redirect の本体。遷移先を返し、遷移しないなら null。
///
/// 未ログインで部屋 URL を直接開いた場合は、ログイン完了後にその部屋へ入れるよう
/// [parkRoomID] で room-id を預けてからログイン画面へ送る。
String? resolveRedirect({
  required bool isLoggedIn,
  required String? path,
  required String roomID,
  required void Function(String roomID) parkRoomID,
}) {
  final isPoker = path == pokerPath;
  final validRoomID = roomIDFormatRegExp.hasMatch(roomID);

  if (isLoggedIn) {
    // room-id が不正な /poker は入室できないので部屋選択へ戻す
    return (isPoker && !validRoomID) ? roomSelectPath : null;
  }

  if (path == loginPath) {
    return null;
  }

  if (isPoker && validRoomID) {
    parkRoomID(roomID);
  }
  return loginPath;
}
