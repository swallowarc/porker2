import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<void> putMap(String key, Map<String, dynamic> param) async {
    final json = jsonEncode(param);
    SharedPreferences.getInstance().then(
      (data) => data.setString(key, json),
    );
  }

  Future<void> putList(String key, List<dynamic> param) async {
    final json = jsonEncode(param);
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, json);
  }

  Future<Map<String, dynamic>> getMap(String key) async {
    final pref = await SharedPreferences.getInstance();
    final json = pref.get(key);
    if (json == null) {
      return <String, dynamic>{};
    }
    return jsonDecode(json.toString());
  }

  Future<List> getList(String key) async {
    final pref = await SharedPreferences.getInstance();
    final json = pref.get(key);
    if (json == null) {
      return [];
    }
    return jsonDecode(json.toString());
  }

  Future<void> delete(String key) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }
}
