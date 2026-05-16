import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  CustomColors({required this.containerColor, required this.background});

  final Color background;
  final Color containerColor;

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? background,
    Color? containerColor,
  }) {
    return CustomColors(
      background: background ?? this.background,
      containerColor: containerColor ?? this.containerColor,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) return this;

    return CustomColors(
      background: Color.lerp(background, other.background, t)!,
      containerColor: Color.lerp(containerColor, other.containerColor, t)!,
    );
  }
}
