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

    return ThemeData(
      // Let the global gradient show through
      scaffoldBackgroundColor: Colors.transparent,
      // common divider color
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 0.5),
      fontFamily: null, // set font here later
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        systemOverlayStyle: overlay,
      ),
      // Apply a color scheme so default text/icon colors have proper contrast
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.textPrimary,
        brightness: brightness,
        surface: colors.backgroundPrimary,
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
