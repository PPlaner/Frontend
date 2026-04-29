import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/i18n/strings.g.dart';

class PersonalizationScreen extends StatelessWidget {
  const PersonalizationScreen({super.key});

  /// Показує діалог підтвердження видалення акаунту (Головна 15)
  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) {
        final dialogColors = AppColors.of(ctx);
        final t = ctx.t;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: dialogColors.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.profile.deleteConfirmTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Скасувати — зелена filled кнопка
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: dialogColors.surface,
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          t.common.cancel,
                          style: textTheme.labelMedium?.copyWith(
                            color: dialogColors.surface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Видалити — червона outlined кнопка
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(
                            color: AppColors.error,
                            width: 1,
                          ),
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          t.common.delete,
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true && context.mounted) {
      // Зробити: логіка видалення акаунту через Riverpod
      Navigator.of(context).pop(); // повернутись на ProfileScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок зі стрілкою назад
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Стрілка назад зліва
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: colors.textPrimary,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Text(
                    t.profile.personalization,
                    style: textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            // Контент
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  // Картка "Видалити акаунт"
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.lock_outline,
                        title: t.profile.deleteAccount,
                        subtitle: t.profile.deleteAccountSubtitle,
                        onTap: () => _showDeleteConfirmDialog(context),
                        showArrow: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Картка з опціями зміни
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        title: t.profile.changeName,
                        onTap: () {
                          // Зробити: екран зміни імені
                        },
                      ),
                      _TileDivider(),
                      _SettingsTile(
                        title: t.profile.changePassword,
                        onTap: () {
                          // Зробити: екран зміни пароля
                        },
                      ),
                      _TileDivider(),
                      _SettingsTile(
                        title: t.profile.changeEncryption,
                        onTap: () {
                          // Зробити: екран зміни шифрування
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
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
    required this.title,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.showArrow = true,
  });

  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showArrow;

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
            // Іконка (опціональна)
            if (icon != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: colors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
            ],

            // Текст
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

            // Стрілка (опціональна)
            if (showArrow)
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

// Розділювач між тайлами

class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: colors.cardBorder,
    );
  }
}

// Bottom Navigation Bar

class _BottomNav extends StatelessWidget {
  const _BottomNav();

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
        currentIndex: 2,
        onTap: (_) {},
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
