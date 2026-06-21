import 'package:flutter/material.dart';
import 'package:water_intake_logger/design/app_typography.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final colors = AppThemeColors.light;

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
      ),
      textTheme: AppTypography.textTheme(colors.onSurface),
      extensions: const [AppThemeColors.light],
    );
  }

  static ThemeData get dark {
    final colors = AppThemeColors.dark;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
      ),
      textTheme: AppTypography.textTheme(colors.onSurface),
      extensions: const [AppThemeColors.dark],
    );
  }
}
