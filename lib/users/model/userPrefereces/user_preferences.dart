import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:organ_donation_app/users/model/user.dart';

class RememberUserPrefs {
  // Key for storing user info
  static const String userKey = "userData";

  // Save user information
  static Future<void> saveRememberUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(userKey, userJson);
  }

  // Retrieve user information
  static Future<User?> readRememberUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Clear user information
  static Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }
}
