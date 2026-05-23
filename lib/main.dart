import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/init.dart';
import 'package:frontend/app/navigation/app_router.dart';
import 'package:frontend/core/presentation/theme/generated_app_theme.dart';
import 'package:frontend/core/presentation/theme/theme_provider.dart';
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
    final router = ref.watch(appRouterProvider);
    final t = context.t;

    return MaterialApp.router(
      title: t.common.app_name,
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

      routerConfig: router,
    );
  }
}
