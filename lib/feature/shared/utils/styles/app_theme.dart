import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';

class AppThemes {
  static ThemeData appTheme(Brightness brightness) {
    final colors = brightness == Brightness.light
        ? AppColor.lightColor
        : AppColor.darkColor;
    return ThemeData(
      // root widget background color
      scaffoldBackgroundColor: colors.backgroundPrimary,
      // common divider color
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 0.5),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        foregroundColor: colors.divider,
        backgroundColor: colors.backgroundPrimary,
        titleTextStyle: AppTextStyle.labelMedium.copyWith(
          color: colors.textSeconday,
        ),
      ),
      fontFamily: null, // set font here later
    );
  }
}
