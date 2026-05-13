import 'package:frontend/core/storage/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_config.g.dart';

class UserPreferences {
  UserPreferences(this._sharedPrefs);

  final SharedPreferences _sharedPrefs;

  static const _hasAuthenticatedKey = 'hasAuthenticatedBefore';

  bool get hasAuthenticatedBefore {
    return _sharedPrefs.getBool(_hasAuthenticatedKey) ?? false;
  }

  Future<void> setAuthenticatedBefore(bool value) async {
    await _sharedPrefs.setBool(_hasAuthenticatedKey, value);
  }
}

@riverpod
UserPreferences userPreferences(Ref ref) =>
    UserPreferences(ref.watch(sharedPreferencesProvider));
