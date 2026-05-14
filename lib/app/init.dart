import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/navigation/navigators/overrides.dart';
import 'package:frontend/core/network/dio_provider.dart';
import 'package:frontend/core/storage/cookie_jar.dart';
import 'package:frontend/core/storage/shared_prefs.dart';
import 'package:frontend/core/sync/sync_orchestrator.dart';
import 'package:frontend/features/auth/data/unified_auth_repository.dart';
import 'package:frontend/features/notes/data/delegates/notes_sync_delegate.dart';
import 'package:frontend/features/notes/data/delegates/projects_sync_delegate.dart';
import 'package:frontend/features/notes/data/unified_notes_repository.dart';
import 'package:frontend/i18n/strings.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeGlobalSettings() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocaleSettings.useDeviceLocale();
}

Future<ProviderScope> wrapWithProviderScope({required Widget child}) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final cookiePath = '${appDocDir.path}/.cookies/';

  final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
  final sharedPrefs = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      cookieJarProvider.overrideWithValue(cookieJar),
      sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      tokenRefresherProvider.overrideWith(
        (ref) => ref.watch(unifiedAuthRepositoryProvider),
      ),
      registeredSyncablesProvider.overrideWith(
        (ref) {
          final concreteNotesRepo = ref.watch(unifiedNotesRepositoryProvider);

          return [
            ProjectsSyncDelegate(engine: concreteNotesRepo),
            NotesSyncDelegate(engine: concreteNotesRepo),
          ];
        },
      ),
      ...overrideNavigators(),
    ],
    child: child,
  );
}

Widget wrapWithTranslation({required Widget child}) {
  return TranslationProvider(child: child);
}
