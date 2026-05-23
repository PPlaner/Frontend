import 'package:flutter/material.dart';

/// Єдине джерело кольорів для всього додатку.
///
/// ## Як використовувати
///
/// ### 1. Статичні константи — для значень що НЕ змінюються між темами:
/// ```dart
/// color: AppColors.primary       // зелений — однаковий в обох темах
/// color: AppColors.error         // червоний — однаковий в обох темах
/// ```
///
/// ### 2. Адаптивні кольори — для фонів, тексту, карток (змінюються з темою):
/// ```dart
/// final colors = AppColors.of(context);
/// color: colors.background       // #EBEBEB (light) або #1A1A1A (dark)
/// color: colors.surface          // #FFFFFF (light) або #242424 (dark)
/// color: colors.textPrimary      // #2D2D2D (light) або #F0F0F0 (dark)
/// color: colors.textSecondary    // #828282 (light) або #AAAAAA (dark)
/// ```
abstract final class AppColors {
  AppColors._();

  // Кольори що НЕ змінюються між темами

  /// Основний зелений — кнопки, чекбокси, FAB, бордери активних елементів
  static const Color primary = Color(0xFF8BA88E);

  /// Світлий контейнер primary
  static const Color primaryContainer = Color(0xFFDDEEE0);

  /// Темно-зелений вторинний
  static const Color secondary = Color(0xFF006D39);

  /// Світлий контейнер secondary
  static const Color secondaryContainer = Color(0xFFF0F0F0);

  /// Tertiary зелений
  static const Color tertiary = Color(0xFF4CAF7D);

  /// Червоний — видалення, помилки
  static const Color error = Color(0xFFB00020);

  /// Світлий фон при свайпі видалення
  static const Color deleteBackground = Color(0xFFFFEBEE);

  /// Дуже світлий сірий — дні тижня в календарі
  static const Color calendarDayOfWeek = Color(0xFFBDBDBD);

  // Light-only константи (для AppTheme)

  static const Color lightBackground      = Color(0xFFEBEBEB);
  static const Color lightSurface         = Colors.white;
  static const Color lightAppBar          = Color(0xFFF0F0F0);
  static const Color lightBottomNav       = Color(0xFFD9D9D9);
  static const Color lightTextPrimary     = Color(0xFF2D2D2D);
  static const Color lightTextSecondary   = Color(0xFF828282);
  static const Color lightCardBorder      = Color(0xFFE0E0E0);
  static const Color lightDivider         = Color(0xFFD9D9D9);

  // Dark-only константи (для AppTheme)

  static const Color darkBackground       = Color(0xFF1A1A1A);
  static const Color darkSurface          = Color(0xFF242424);
  static const Color darkAppBar           = Color(0xFF2C2C2C);
  static const Color darkBottomNav        = Color(0xFF2C2C2C);
  static const Color darkTextPrimary      = Color(0xFFF0F0F0);
  static const Color darkTextSecondary    = Color(0xFFAAAAAA);
  static const Color darkCardBorder       = Color(0xFF3A3A3A);
  static const Color darkDivider          = Color(0xFF3A3A3A);
  static const Color darkPrimaryContainer = Color(0xFF2A3D2C);
  static const Color darkSecondary        = Color(0xFF4CAF7D);
  static const Color darkSecondaryContainer = Color(0xFF1E2E1F);
  static const Color darkTertiary         = Color(0xFF81C784);
  static const Color darkError            = Color(0xFFCF6679);

  // Адаптивний доступ через context

  /// Повертає набір кольорів що автоматично адаптується до поточної теми.
  ///
  /// ```dart
  /// final colors = AppColors.of(context);
  /// Container(color: colors.background)
  /// ```
  static AppColorScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const _DarkScheme() : const _LightScheme();
  }
}

// Абстрактний інтерфейс схеми кольорів

abstract class AppColorScheme {
  const AppColorScheme();

  Color get background;
  Color get surface;
  Color get surfaceVariant;
  Color get appBar;
  Color get bottomNav;
  Color get textPrimary;
  Color get textSecondary;
  Color get cardBorder;
  Color get divider;
}

// Light схема

class _LightScheme extends AppColorScheme {
  const _LightScheme();

  @override Color get background    => AppColors.lightBackground;
  @override Color get surface       => AppColors.lightSurface;
  @override Color get surfaceVariant => const Color(0xFFF5F5F5);
  @override Color get appBar        => AppColors.lightAppBar;
  @override Color get bottomNav     => AppColors.lightBottomNav;
  @override Color get textPrimary   => AppColors.lightTextPrimary;
  @override Color get textSecondary => AppColors.lightTextSecondary;
  @override Color get cardBorder    => AppColors.lightCardBorder;
  @override Color get divider       => AppColors.lightDivider;
}

// Dark схема

class _DarkScheme extends AppColorScheme {
  const _DarkScheme();

  @override Color get background    => AppColors.darkBackground;
  @override Color get surface       => AppColors.darkSurface;
  @override Color get surfaceVariant => const Color(0xFF2C2C2C);
  @override Color get appBar        => AppColors.darkAppBar;
  @override Color get bottomNav     => AppColors.darkBottomNav;
  @override Color get textPrimary   => AppColors.darkTextPrimary;
  @override Color get textSecondary => AppColors.darkTextSecondary;
  @override Color get cardBorder    => AppColors.darkCardBorder;
  @override Color get divider       => AppColors.darkDivider;
}
