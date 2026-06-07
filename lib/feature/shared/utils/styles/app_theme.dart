import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter/services.dart';

/// Professional app theme inspired by top apps like Zomato, Swiggy
class AppThemes {
  static ThemeData appTheme(Brightness brightness) {
    final colors = brightness == Brightness.light
        ? AppColor.lightColor
        : AppColor.darkColor;

    final SystemUiOverlayStyle overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: brightness == Brightness.light
          ? Brightness.light
          : Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.backgroundPrimary,
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 0.5),

      // App Bar - Clean and modern
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: overlay,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colors.textPrimary, size: 24),
      ),

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primaryColor,
        brightness: brightness,
        surface: colors.backgroundPrimary,
        primary: colors.primaryColor,
        secondary: colors.accentColor,
        error: colors.errorColor,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surfaceColor,
        selectedItemColor: colors.primaryColor,
        unselectedItemColor: colors.gray,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        textColor: colors.textPrimary,
        iconColor: colors.textSecondary,
      ),

      // Input Decoration - ChatGPT style
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
        hintStyle: TextStyle(color: colors.gray, fontSize: 14),
        filled: true,
        fillColor: colors.surfaceColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button - Modern style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // SnackBar Theme - Modern and colorful
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.light
            ? const Color(0xFF323232)
            : const Color(0xFF404040),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        actionTextColor: colors.primaryColor,
      ),
    );
  }

  // Simple clean background - no gradients
  static Color appBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light
        ? AppColor.lightColor.backgroundPrimary
        : AppColor.darkColor.backgroundPrimary;
  }
}
