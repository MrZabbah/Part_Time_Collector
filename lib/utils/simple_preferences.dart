import 'package:shared_preferences/shared_preferences.dart';

class SimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyCompleted = 'itemsCompleted';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setCompletedCount(int completed) async =>
      await _preferences?.setInt(_keyCompleted, completed);

  static int getCompletedCount() => _preferences?.getInt(_keyCompleted) ?? 0;

  static Future clearPreferences() async => await _preferences?.clear();
}
