import 'dart:convert';

import 'package:polmitra_admin/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async => _prefs ??= await SharedPreferences.getInstance();

  static Future<void> init() async {
    _prefs ??= await _instance;
  }

  /// auth methods


  /// login status
  static Future<void> setLoginStatus(bool value) async {
    final prefs = await _instance;
    await prefs.setBool('isLoggedIn', value);
  }

  static Future<bool?> getLoginStatus() async {
    final prefs = await _instance;
    return prefs.getBool('isLoggedIn');
  }


  /// user id
  static Future<void> setUserId(String value) async {
    final prefs = await _instance;
    await prefs.setString('userId', value);
  }

  static Future<String?> getUserId() async {
    final prefs = await _instance;
    return prefs.getString('userId');
  }

  /// role
  static Future<void> setRole(String value) async {
    final prefs = await _instance;
    await prefs.setString('role', value);
  }

  static Future<String?> getRole() async {
    final prefs = await _instance;
    return prefs.getString('role');
  }

  /// neta id
  static Future<void> setNetaId(String value) async {
    final prefs = await _instance;
    await prefs.setString('netaId', value);
  }

  static Future<String?> getNetaId() async {
    final prefs = await _instance;
    return prefs.getString('netaId');
  }

  /// user
  static Future<void> saveUser(PolmitraUser user) async {
    final prefs = await _instance;
    String userJson = jsonEncode(user.toMap());
    await prefs.setString('user', userJson);
  }

  static Future<PolmitraUser?> getUser() async {
    final prefs = await _instance;
    String? userJson = prefs.getString('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return PolmitraUser.fromMap(userMap);
  }


  /// general methods

  static Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }


}
