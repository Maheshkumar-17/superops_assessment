import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPreferences;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  List<String> getStringListValue(String key) {
    return _sharedPreferences?.getStringList(key) ?? [];
  }

  Future<bool>? putStringListValue(String key, List<String> value) {
    return _sharedPreferences?.setStringList(key, value);
  }

  void clearPref() async {
    await _sharedPreferences?.clear();
  }
}
