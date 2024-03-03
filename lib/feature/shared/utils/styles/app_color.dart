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
    textPrimary: Color(0xFF66D4CF),
    divider: Color(0xFFf4f6f6),
    textSeconday: Color(0xFFd9e2eb),
    gray: Color(0xFFCAC7CC),
    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFFFFFFF),
    red: Color(0xFFFF0000),
  );

  static const darkColor = AppColor(
    textPrimary: Color(0xFF66D4CF),
    divider: Color(0xFFf4f6f6),
    textSeconday: Color(0xFFd9e2eb),
    gray: Color(0xFFCAC7CC),
    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFFFFFFF),
    red: Color(0xFFFF0000),
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
