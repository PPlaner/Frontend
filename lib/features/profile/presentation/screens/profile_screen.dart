import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/theme_provider.dart';
import 'package:frontend/i18n/strings.g.dart';

// ProfileScreen

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final bool _hasAccount = false;

  int _currentNavIndex = 2;
  AppLocale _language = LocaleSettings.currentLocale;

  // Використовуємо ключ з JSON замість прямого тексту
  String _timezone = 'ukraine';

  Future<void> _openLanguage() async {
    final result = await showLanguageSheet(context, _language);
    if (result != null) {
      await LocaleSettings.setLocale(result);
      setState(() => _language = result);
    }
  }

  Future<void> _openAppearance() async {
    await showAppearanceSheet(context, ref);
  }

  Future<void> _openTimezone() async {
    final result = await showTimezoneSheet(context, _timezone);
    if (result != null) setState(() => _timezone = result);
  }

  Future<void> _openWidgets() async {
    await showWidgetsSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: _hasAccount
            ? _AccountView(
          onLanguageTap: _openLanguage,
          onAppearanceTap: _openAppearance,
          onTimezoneTap: _openTimezone,
          onWidgetsTap: _openWidgets,
        )
            : _LocalView(
          onLanguageTap: _openLanguage,
          onAppearanceTap: _openAppearance,
          onTimezoneTap: _openTimezone,
          onWidgetsTap: _openWidgets,
          onLogout: () {},
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}

// Стан "є акаунт"

class _AccountView extends StatelessWidget {
  const _AccountView({
    required this.onLanguageTap,
    required this.onAppearanceTap,
    required this.onTimezoneTap,
    required this.onWidgetsTap,
  });

  final VoidCallback onLanguageTap;
  final VoidCallback onAppearanceTap;
  final VoidCallback onTimezoneTap;
  final VoidCallback onWidgetsTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        _ProfileHeader(
          name: t.profile.name,
          email: t.profile.email,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.lock_outline,
              title: t.profile.createAccount,
              subtitle: t.profile.createAccountSubtitle,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.language_outlined,
              title: t.profile.language,
              onTap: onLanguageTap,
            ),
            _TileDivider(),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: t.profile.appearance,
              onTap: onAppearanceTap,
            ),
            _TileDivider(),
            _SettingsTile(
              icon: Icons.access_time_outlined,
              title: t.profile.dateTime,
              onTap: onTimezoneTap,
            ),
            _TileDivider(),
            _SettingsTile(
              icon: Icons.widgets_outlined,
              title: t.profile.widgets,
              onTap: onWidgetsTap,
            ),
          ],
        ),
      ],
    );
  }
}

// Стан "локальне / без акаунту"

class _LocalView extends StatelessWidget {
  const _LocalView({
    required this.onLanguageTap,
    required this.onAppearanceTap,
    required this.onTimezoneTap,
    required this.onWidgetsTap,
    required this.onLogout,
  });

  final VoidCallback onLanguageTap;
  final VoidCallback onAppearanceTap;
  final VoidCallback onTimezoneTap;
  final VoidCallback onWidgetsTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        _ProfileHeader(
          name: t.profile.name,
          email: t.profile.email,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.lock_outline,
              title: t.profile.personalization,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.language_outlined,
              title: t.profile.language,
              onTap: onLanguageTap,
            ),
            _TileDivider(),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: t.profile.appearance,
              onTap: onAppearanceTap,
            ),
            _TileDivider(),
            _SettingsTile(
              icon: Icons.access_time_outlined,
              title: t.profile.dateTime,
              onTap: onTimezoneTap,
            ),
            _TileDivider(),
            _SettingsTile(
              icon: Icons.widgets_outlined,
              title: t.profile.widgets,
              onTap: onWidgetsTap,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [_LogoutTile(onTap: onLogout)],
        ),
      ],
    );
  }
}

// Шапка профілю

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.onTap,
  });

  final String name;
  final String email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                color: colors.surface,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(email, style: textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Картка-контейнер

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

// Рядок налаштування

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Рядок "Вийти"

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Center(
          child: Text(
            t.auth.logout,
            style: textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// Розділювач між тайлами

class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Divider(
      height: 1,
      indent: 66,
      endIndent: 16,
      color: colors.cardBorder,
    );
  }
}

// Bottom Navigation Bar

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.bottomNav,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: colors.textPrimary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_box_outlined),
            label: t.bottomNav.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: t.bottomNav.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: t.bottomNav.profile,
          ),
        ],
      ),
    );
  }
}

/// BOTTOM SHEETS

extension AppLocaleLabel on AppLocale {
  String get label => switch (this) {
    AppLocale.uk => 'Українська',
    AppLocale.en => 'English',
  };
}

Future<AppLocale?> showLanguageSheet(BuildContext context, AppLocale current) {
  return showModalBottomSheet<AppLocale>(
    context: context,
    backgroundColor: AppColors.of(context).surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _LanguageSheet(current: current),
  );
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.current});
  final AppLocale current;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            const SizedBox(height: 20),
            Text(t.profile.chooseLanguage, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            ...AppLocale.values.map(
                  (lang) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(lang.label, style: textTheme.titleMedium),
                trailing: current == lang
                    ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                    : null,
                onTap: () => Navigator.pop(context, lang),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

Future<void> showAppearanceSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.of(context).surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _AppearanceSheet(ref: ref),
  );
}

class _AppearanceSheet extends ConsumerWidget {
  const _AppearanceSheet({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef innerRef) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final currentMode = ref.watch(themeModeProvider);
    final t = context.t;

    final options = [
      (mode: ThemeMode.light, label: t.profile.appearanceLight, icon: Icons.light_mode_outlined),
      (mode: ThemeMode.dark, label: t.profile.appearanceDark, icon: Icons.dark_mode_outlined),
      (mode: ThemeMode.system, label: t.profile.appearanceSystem, icon: Icons.brightness_auto_outlined),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            const SizedBox(height: 20),
            Text(t.profile.chooseAppearance, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            ...options.map(
                  (opt) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  opt.icon,
                  color: currentMode == opt.mode
                      ? AppColors.primary
                      : colors.textSecondary,
                  size: 22,
                ),
                title: Text(opt.label, style: textTheme.titleMedium),
                trailing: currentMode == opt.mode
                    ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setTheme(opt.mode);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

const List<String> _timezones = [
  'ukraine', 'poland', 'germany', 'usaNy', 'usaLa', 'greatBritain',
];

Future<String?> showTimezoneSheet(BuildContext context, String current) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.of(context).surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _TimezoneSheet(current: current),
  );
}

class _TimezoneSheet extends StatefulWidget {
  const _TimezoneSheet({required this.current});
  final String current;

  @override
  State<_TimezoneSheet> createState() => _TimezoneSheetState();
}

class _TimezoneSheetState extends State<_TimezoneSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            const SizedBox(height: 20),
            Text(t.calendar.chooseTimezone, style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selected,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: colors.textSecondary,
                  ),
                  style: textTheme.titleMedium,
                  items: _timezones.map((tz) => DropdownMenuItem(
                      value: tz,
                      child: Text(t['timezones.$tz'].toString())
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selected = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, _selected),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: colors.surface,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                t.common.save,
                style: textTheme.labelLarge?.copyWith(color: colors.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showWidgetsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.of(context).surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _WidgetsSheet(),
  );
}

class _WidgetsSheet extends StatefulWidget {
  const _WidgetsSheet();

  @override
  State<_WidgetsSheet> createState() => _WidgetsSheetState();
}

class _WidgetsSheetState extends State<_WidgetsSheet> {
  final List<({String title, bool enabled})> _widgets = [
    (title: 'tasks', enabled: true),
    (title: 'calendar', enabled: false),
    (title: 'progress', enabled: false),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            const SizedBox(height: 20),
            Text(t.profile.addWidget, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._widgets.asMap().entries.map(
                  (entry) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t['widgets.${entry.value.title}'].toString(), style: textTheme.titleMedium),
                value: entry.value.enabled,

                activeThumbColor: AppColors.primary,
                activeTrackColor: colors.surface,
                trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return null;
                }),

                onChanged: (val) {
                  setState(() {
                    _widgets[entry.key] = (
                    title: entry.value.title,
                    enabled: val,
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: colors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}