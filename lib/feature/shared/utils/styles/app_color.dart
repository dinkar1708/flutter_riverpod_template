import 'package:flutter/material.dart';

// TODO manage readable names for colors
class AppColor {
  const AppColor({
    required this.textPrimary,
    required this.divider,
    required this.textSeconday,
    required this.gray,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.red,
  });

  final Color textPrimary;
  final Color divider;
  final Color textSeconday;
  final Color gray;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color red;

  static const lightColor = AppColor(
    // High-contrast text on light backgrounds
    textPrimary: Color(0xFF0F172A),
    // Subtle divider for light theme
    divider: Color(0xFFE5E7EB),
    // Secondary text
    textSeconday: Color(0xFF6B7280),
    gray: Color(0xFF9CA3AF),
    // Soft, pleasant light background (not pure white)
    backgroundPrimary: Color(0xFFF3F6FA),
    backgroundSecondary: Color(0xFFEAF0F6),
    red: Color(0xFFFF4D4F),
  );

  static const darkColor = AppColor(
    // Light text on dark backgrounds
    textPrimary: Color(0xFFF3F4F6),
    divider: Color(0xFF334155),
    textSeconday: Color(0xFF94A3B8),
    gray: Color(0xFF64748B),
    backgroundPrimary: Color(0xFF0F172A),
    backgroundSecondary: Color(0xFF111827),
    red: Color(0xFFFF6B6B),
  );
}

extension AppColorExtension on BuildContext {
  // get color set by brightness
  AppColor get color => _getColorByBrightness(Theme.of(this).brightness);
  // decide colors
  AppColor _getColorByBrightness(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return AppColor.lightColor;
      case Brightness.dark:
        return AppColor.darkColor;
    }
  }
}
