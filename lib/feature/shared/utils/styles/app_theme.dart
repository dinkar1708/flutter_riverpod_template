import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static ThemeData appTheme(Brightness brightness) {
    final colors = brightness == Brightness.light
        ? AppColor.lightColor
        : AppColor.darkColor;
    final SystemUiOverlayStyle overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Android
      statusBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      // iOS
      statusBarBrightness: brightness == Brightness.light
          ? Brightness.light
          : Brightness.dark,
    );

    final ThemeData base = ThemeData(
      // Let the global gradient show through
      scaffoldBackgroundColor: Colors.transparent,
      // common divider color
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 0.5),
      fontFamily: null, // set font here later
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(
          0xFF667eea,
        ).withValues(alpha: 0.8), // Semi-transparent blue from gradient
        foregroundColor: Colors.white, // White text for contrast against blue
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: overlay,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
      ),
      // Apply a color scheme so default text/icon colors have proper contrast
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.textPrimary,
        brightness: brightness,
        surface: colors.backgroundPrimary,
      ),
      // Improve bottom navigation visibility
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black.withValues(alpha: 0.05),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        elevation: 2,
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white70,
      ),
      // Inputs: improve hint/label contrast on gradient
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.85),
            width: 1.2,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      // Common elevated button style reusable across app
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: 0.4);
            }
            return Colors.white.withValues(alpha: 0.9);
          }),
          foregroundColor: WidgetStateProperty.all(const Color(0xFF2D3748)),
          overlayColor: WidgetStateProperty.all(
            Colors.white.withValues(alpha: 0.2),
          ),
          elevation: WidgetStateProperty.all(3),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );

    // Make all default text/icons readable on gradients
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        decorationColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      colorScheme: base.colorScheme.copyWith(
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
    );
  }

  static LinearGradient appBackgroundGradient(Brightness brightness) {
    if (brightness == Brightness.light) {
      // More vibrant blue to purple gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea), // vibrant blue
          Color(0xFF764ba2), // purple
          Color(0xFFf093fb), // pink accent
        ],
        stops: [0.0, 0.5, 1.0],
      );
    }
    // Dark gradient with blue tones
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1e3c72), // dark blue
        Color(0xFF2a5298), // medium blue
        Color(0xFF1e3c72), // dark blue
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }
}
