import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkter/features/auth/models/user_info_model/user_info_model.dart';

class UserLocalStorage {
  static const String _userKey = 'user_data';

  Future<void> saveUser({
    required UserInfo user,
    required String avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final userData = {
      'name': user.name,
      'username': user.userName,
      'email': user.email,
      'phone': user.phone,
      'profile_pic_url': avatarUrl,
    };

    await prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<UserInfo?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userString = prefs.getString(_userKey);

    if (userString == null) {
      return null;
    }

    final Map<String, dynamic> userData = jsonDecode(userString);

    return UserInfo(
      name: userData['name'] ?? '',
      userName: userData['username'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
    );
  }

  Future<String?> getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();

    final userString = prefs.getString(_userKey);

    if (userString == null) {
      return null;
    }

    final Map<String, dynamic> userData = jsonDecode(userString);

    return userData['profile_pic_url'];
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);
  }

  Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(_userKey);
  }
}
