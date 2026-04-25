import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';


class TokenService {
  static final _storage = FlutterSecureStorage();

  // ---------------- TOKENS ----------------

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: "accessToken", value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: "refreshToken", value: token);
  }

  static Future<String?> getAccessToken() async {
    final userToken = await _storage.read(key: "accessToken");
    print('user_token=> $userToken');
    return userToken;
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: "refreshToken");
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // ---------------- USER PROFILE ----------------

  /// ✅ SAVE USER PROFILE (ProfileData)
  static Future<void> saveUser(ProfileData user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: "userKey", value: userJson);
  }

  /// ✅ GET USER PROFILE (ProfileData)
  static Future<ProfileData?> getUser() async {
    final userData = await _storage.read(key: "userKey");
    if (userData == null || userData.isEmpty) return null;

    final decoded = jsonDecode(userData) as Map<String, dynamic>;
    return ProfileData.fromJson(decoded);
  }

//save user id
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: "user_id", value: userId);
  }

  //get user id
  static Future<String?> getUserId() async {
    final userId = await _storage.read(key: "user_id");
    print('user_id => $userId');
    return userId;
  }

  static Future<void> saveUserType(String userId) async {
    await _storage.write(key: "user_type", value: userId);
  }

  //get user id
  static Future<String?> getUserType() async {
    final userId =  await _storage.read(key: "user_type");
    print('user_type=> $userId');
    return userId;
  }
}
