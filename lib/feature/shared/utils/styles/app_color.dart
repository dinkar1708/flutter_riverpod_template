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
    // High-contrast text for gradient backgrounds
    textPrimary: Color(0xFF2D3748),
    // Subtle divider for light theme
    divider: Color(0xFFE2E8F0),
    // Secondary text
    textSeconday: Color(0xFF718096),
    gray: Color(0xFFA0AEC0),
    // These won't be used since we have gradient background
    backgroundPrimary: Color(0xFFF7FAFC),
    backgroundSecondary: Color(0xFFEDF2F7),
    red: Color(0xFFE53E3E),
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
