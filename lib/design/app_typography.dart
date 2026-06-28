import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Plus Jakarta Sans';

  static TextTheme textTheme(Color textColor) {
    const baseFamily = fontFamily;

    return ThemeData.light().textTheme.copyWith(
      displayLarge: TextStyle(
        fontFamily: baseFamily,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontFamily: baseFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: TextStyle(
        fontFamily: baseFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontFamily: baseFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontFamily: baseFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: baseFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: baseFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: baseFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontFamily: baseFamily,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.0,
      ),
    );
  }
}
