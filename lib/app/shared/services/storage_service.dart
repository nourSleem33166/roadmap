import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SharedPreferencesHelper {
  static Future<bool> setUser(User user) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString('user', jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? jsonUser = pref.getString('user');
    if (jsonUser != null) {
      final User user = User.fromJson(jsonDecode(jsonUser));
      return user;
    } else {
      return null;
    }
  }

  static Future deleteUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("user");
  }
}
