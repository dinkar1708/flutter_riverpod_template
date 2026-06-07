import 'package:flutter/material.dart';

/// Professional app colors inspired by top apps like Zomato, Swiggy
class AppColor {
  const AppColor({
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.gray,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.cardBackground,
    required this.primaryColor,
    required this.accentColor,
    required this.successColor,
    required this.errorColor,
    required this.warningColor,
    required this.surfaceColor,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color gray;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color cardBackground;
  final Color primaryColor;
  final Color accentColor;
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color surfaceColor;

  // Light theme - Clean and professional like Zomato/Swiggy
  static const lightColor = AppColor(
    textPrimary: Color(0xFF1C1C1C),        // Near black for excellent readability
    textSecondary: Color(0xFF696969),      // Subtle gray for secondary text
    divider: Color(0xFFE8E8E8),            // Light divider
    gray: Color(0xFF9E9E9E),               // Medium gray
    backgroundPrimary: Color(0xFFFFFFFF),   // Pure white
    backgroundSecondary: Color(0xFFF8F8F8), // Off-white for cards
    cardBackground: Color(0xFFFFFFFF),      // White cards with shadow
    primaryColor: Color(0xFFE23744),        // Zomato-inspired red
    accentColor: Color(0xFFFC8019),         // Swiggy-inspired orange
    successColor: Color(0xFF48C479),        // Fresh green
    errorColor: Color(0xFFE84849),          // Error red
    warningColor: Color(0xFFFFA931),        // Warning orange
    surfaceColor: Color(0xFFFAFAFA),        // Subtle surface
  );

  // Dark theme - Elegant and modern
  static const darkColor = AppColor(
    textPrimary: Color(0xFFFFFFFF),         // Pure white text
    textSecondary: Color(0xFFB0B0B0),       // Light gray
    divider: Color(0xFF2C2C2C),             // Dark divider
    gray: Color(0xFF7A7A7A),                // Medium gray
    backgroundPrimary: Color(0xFF121212),    // True dark
    backgroundSecondary: Color(0xFF1E1E1E),  // Slightly lighter dark
    cardBackground: Color(0xFF1E1E1E),       // Dark cards
    primaryColor: Color(0xFFFF6B6B),         // Softer red for dark
    accentColor: Color(0xFFFF9051),          // Warm orange
    successColor: Color(0xFF5DD39E),         // Bright green
    errorColor: Color(0xFFFF6B6B),           // Error red
    warningColor: Color(0xFFFFB74D),         // Warning orange
    surfaceColor: Color(0xFF2C2C2C),         // Surface color
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
