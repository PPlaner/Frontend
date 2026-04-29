import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/init.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/theme/theme_provider.dart';
import 'package:frontend/features/profile/presentation/screens/profile_screen.dart';
import 'package:frontend/features/vault/presentation/screens/association_screen.dart';
import 'package:frontend/features/vault/presentation/screens/auth_method_selection_screen.dart';
import 'package:frontend/features/vault/presentation/screens/auth_screen.dart';
import 'package:frontend/features/vault/presentation/screens/create_pin_screen.dart';
import 'package:frontend/features/vault/presentation/screens/email_verification_screen.dart';
import 'package:frontend/features/vault/presentation/screens/login_screen.dart';
import 'package:frontend/features/vault/presentation/screens/pattern_lock_screen.dart';
import 'package:frontend/features/vault/presentation/screens/register_screen.dart';
import 'package:frontend/features/vault/presentation/screens/secret_phrase_screen.dart';
import 'package:frontend/features/vault/presentation/screens/security_method_screen.dart';
import 'package:frontend/features/vault/presentation/screens/splash_screen.dart';
import 'package:frontend/features/vault/presentation/screens/verify_phrase_screen.dart';
import 'package:frontend/i18n/strings.g.dart';

void main() async {
  await initializeGlobalSettings();

  const root = MyApp();

  final app = await wrapWithProviderScope(
    child: wrapWithTranslation(child: root),
  );

  runApp(app);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final t = context.t;

    return MaterialApp(
      title: t.appName,
      debugShowCheckedModeBanner: false,

      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      home: const ProfileScreen(),
    );
  }
}
