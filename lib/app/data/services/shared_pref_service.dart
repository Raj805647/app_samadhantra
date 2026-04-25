import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isFirstTime =>
      _prefs?.getBool('isFirstTime') ?? true;

  static Future setNotFirstTime() async {
    await _prefs?.setBool('isFirstTime', false);
  }
}
