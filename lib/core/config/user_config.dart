import 'dart:ui';

import 'package:frontend/core/infrastructure/storage/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_config.g.dart';

class UserPreferences {
  UserPreferences(this._sharedPrefs);

  final SharedPreferences _sharedPrefs;

  static const _hasAuthenticatedKey = 'hasAuthenticatedBefore';
  static const _localeCodeKey = 'localeCode';

  bool get hasAuthenticatedBefore =>
      _sharedPrefs.getBool(_hasAuthenticatedKey) ?? false;

  Future<void> setAuthenticatedBefore({required bool authenticated}) async =>
      _sharedPrefs.setBool(_hasAuthenticatedKey, authenticated);

  String get localeCode =>
      _sharedPrefs.getString(_localeCodeKey) ??
      PlatformDispatcher.instance.locale.languageCode;

  Future<void> setLocaleCode(String code) async =>
      _sharedPrefs.setString(_localeCodeKey, code);
}

@Riverpod(keepAlive: true)
UserPreferences userPreferences(Ref ref) =>
    UserPreferences(ref.watch(sharedPreferencesProvider));
