import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/presentation/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      appBarColor: AppColors.lightAppBar,
      error: AppColors.error,
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 20,
      elevatedButtonRadius: 20,
      filledButtonRadius: 20,
      outlinedButtonRadius: 20,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      bottomNavigationBarType: BottomNavigationBarType.fixed,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: _buildTextTheme(
      textColor: AppColors.lightTextPrimary,
      subtextColor: AppColors.lightTextSecondary,
    ),
  );

  static ThemeData get dark => FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: AppColors.primary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      appBarColor: AppColors.darkAppBar,
      error: AppColors.darkError,
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 20,
      elevatedButtonRadius: 20,
      filledButtonRadius: 20,
      outlinedButtonRadius: 20,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      bottomNavigationBarType: BottomNavigationBarType.fixed,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: _buildTextTheme(
      textColor: AppColors.darkTextPrimary,
      subtextColor: AppColors.darkTextSecondary,
    ),
  );

  static TextTheme _buildTextTheme({
    required Color textColor,
    required Color subtextColor,
  }) =>
      GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: textColor,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: textColor,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: textColor,
        ),
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: textColor,
        ),
        titleSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: subtextColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.5,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          height: 1.4,
          color: subtextColor,
        ),
        bodySmall: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 11,
          color: subtextColor,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: textColor,
        ),
        labelMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: subtextColor,
        ),
        labelSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: subtextColor,
        ),
      );
}
