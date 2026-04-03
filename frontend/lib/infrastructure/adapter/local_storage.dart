import 'package:porker2fe/domain/port/port.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userNameKey = "userName";

class LocalStorageImpl implements LocalStorage {
  @override
  Future<String> getUserName() async {
    final res = (await SharedPreferences.getInstance()).getString(_userNameKey);
    return (res == null) ? "" : res;
  }

  @override
  Future<void> setUserName(String name) async {
    (await SharedPreferences.getInstance()).setString(_userNameKey, name);
  }
}
