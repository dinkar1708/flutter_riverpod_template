import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';

class AppThemes {
  static ThemeData appTheme(Brightness brightness) {
    final colors = brightness == Brightness.light
        ? AppColor.lightColor
        : AppColor.darkColor;
    return ThemeData(
      // root widget background color
      // this is very nice to set default colors for all scaffold widget
      scaffoldBackgroundColor: colors.backgroundPrimary,
      // common divider color
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 0.5),
      fontFamily: null, // set font here later
    );
  }
}
