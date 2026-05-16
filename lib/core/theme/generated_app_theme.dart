import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  static const _colorsLight = FlexSchemeColor(
    primary: Color(0xFF8BA88E),
    primaryContainer: Color(0xFFE8EEE9),
    secondary: Color(0xFFA1C5A5),
    secondaryContainer: Color(0xFFD9E8DB),
    tertiary: Color(0xFFB1CEB4),
    tertiaryContainer: Color(0xFFB1CEB4),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
  );

  // ignoring currently since using _colorsLight.toDark() during dev
  // ignore: unused_field
  static const _colorsDark = FlexSchemeColor(
    primary: Color(0xFF8BA88E),
    primaryContainer: Color(0xFF3D4B3F),
    primaryLightRef: Color(0xFFA1C5A5), // The color of light mode primary
    secondary: Color(0xFFADCEAF),
    secondaryContainer: Color(0xFF687C69),
    secondaryLightRef: Color(0xFFA1C5A5), // The color of light mode secondary
    tertiary: Color(0xFFBDD7BF),
    tertiaryContainer: Color(0xFF577C5A),
    tertiaryLightRef: Color(0xFFB1CEB4), // The color of light mode tertiary
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
  );

  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData lightBase = FlexThemeData.light(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: _colorsLight,
    textTheme: _buildTextTheme(),
    // Input color modifiers.
    usedColors: 1,
    useMaterial3ErrorColors: true,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData darkBase = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: _colorsLight.toDark(),
    textTheme: _buildTextTheme(),
    // Input color modifiers.
    usedColors: 1,
    useMaterial3ErrorColors: true,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  static ThemeData get light => lightBase.copyWith(
    extensions: [
      CustomColors(
        background: lightBase.colorScheme.surfaceContainer,
        containerColor: lightBase.colorScheme.surface,
      ),
    ],
  );

  static ThemeData get dark => darkBase.copyWith(
    extensions: [
      CustomColors(
        background: darkBase.colorScheme.surfaceContainer,
        containerColor: darkBase.colorScheme.surfaceContainerHigh,
      ),
    ],
  );

  static TextTheme _buildTextTheme() => GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ),
    headlineMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    titleSmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 11,
    ),
    labelLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    labelMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 13,
    ),
    labelSmall: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 11,
    ),
  );
}
