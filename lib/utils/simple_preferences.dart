import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class SimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyCompleted = 'itemsCompleted';
  static const _keyAvailable = 'availableItems';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setCompletedCount(int completed) async =>
      await _preferences?.setInt(_keyCompleted, completed);

  static Future setAvailablePositions(List<int> positions) async {
    List<String> list = [];
    for (int element in positions) {
      list.add(element.toString());
    }
    await _preferences?.setStringList(_keyAvailable, list);
  }

  static int getCompletedCount() => _preferences?.getInt(_keyCompleted) ?? 0;

  static Queue<int> getAvailable() {
    final pref = _preferences?.getStringList(_keyAvailable);
    List<int> list = [];
    if (pref == null) {
      list = List.generate(25, (index) => index);
      list.shuffle();
    } else {
      for (var i = 0; i < pref.length; i++) {
        list.add(int.parse(pref[i]));
      }
    }
    return Queue.of(list);
  }

  static Future clearPreferences() async => await _preferences?.clear();
}
