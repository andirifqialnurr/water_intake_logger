import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceElevated;

  final Color onSurface;
  final Color onSurfaceMuted;

  final Color primary;
  final Color onPrimary;
  final Color primarySoft;

  final Color outline;
  final Color shadow;

  final Color navBackground;
  final Color navSelectedBackground;
  final Color navUnselectedBackground;
  final Color navSelectedIcon;
  final Color navUnselectedIcon;

  final Color switchTrackOn;
  final Color switchTrackOff;
  final Color switchThumb;

  final Color chartGrid;
  final Color chartBar;
  final Color chartBarActive;

  final Color success;
  final Color error;

  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceElevated,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.outline,
    required this.shadow,
    required this.navBackground,
    required this.navSelectedBackground,
    required this.navUnselectedBackground,
    required this.navSelectedIcon,
    required this.navUnselectedIcon,
    required this.switchTrackOn,
    required this.switchTrackOff,
    required this.switchThumb,
    required this.chartGrid,
    required this.chartBar,
    required this.chartBarActive,
    required this.success,
    required this.error,
  });

  static const light = AppThemeColors(
    background: Color(0xFFF7F9FB),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEFF1F3),
    surfaceElevated: Color(0xFFF2F4F6),

    onSurface: Color(0xFF191C1E),
    onSurfaceMuted: Color(0xFF404850),

    primary: Color(0xFF005D90),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFF94CCFF),

    outline: Color(0xFF707881),
    shadow: Color(0x1A707881),

    navBackground: Color(0xFFFFFFFF),
    navSelectedBackground: Color(0xFF005D90),
    navUnselectedBackground: Color(0xFFEFF1F3),
    navSelectedIcon: Color(0xFFFFFFFF),
    navUnselectedIcon: Color(0xFFBFC7D1),

    switchTrackOn: Color(0xFF005D90),
    switchTrackOff: Color(0xFFBFC7D1),
    switchThumb: Color(0xFFFFFFFF),

    chartGrid: Color(0x33707881),
    chartBar: Color(0xFF94CCFF),
    chartBarActive: Color(0xFF005D90),

    success: Color(0xFF006875),
    error: Color(0xFFBA1A1A),
  );

  static const dark = AppThemeColors(
    background: Color(0xFF101417),
    surface: Color(0xFF191C1E),
    surfaceMuted: Color(0xFF2D3133),
    surfaceElevated: Color(0xFF22272A),

    onSurface: Color(0xFFEFF1F3),
    onSurfaceMuted: Color(0xFFBFC7D1),

    primary: Color(0xFF94CCFF),
    onPrimary: Color(0xFF001D32),
    primarySoft: Color(0xFF004B74),

    outline: Color(0xFF8A929B),
    shadow: Color(0x66000000),

    navBackground: Color(0xFF191C1E),
    navSelectedBackground: Color(0xFF94CCFF),
    navUnselectedBackground: Color(0xFF2D3133),
    navSelectedIcon: Color(0xFF001D32),
    navUnselectedIcon: Color(0xFFBFC7D1),

    switchTrackOn: Color(0xFF94CCFF),
    switchTrackOff: Color(0xFF707881),
    switchThumb: Color(0xFFFFFFFF),

    chartGrid: Color(0x338A929B),
    chartBar: Color(0xFF53777E),
    chartBarActive: Color(0xFF94CCFF),

    success: Color(0xFF83D3E1),
    error: Color(0xFFFFB4AB),
  );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceElevated,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? primary,
    Color? onPrimary,
    Color? primarySoft,
    Color? outline,
    Color? shadow,
    Color? navBackground,
    Color? navSelectedBackground,
    Color? navUnselectedBackground,
    Color? navSelectedIcon,
    Color? navUnselectedIcon,
    Color? switchTrackOn,
    Color? switchTrackOff,
    Color? switchThumb,
    Color? chartGrid,
    Color? chartBar,
    Color? chartBarActive,
    Color? success,
    Color? error,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primarySoft: primarySoft ?? this.primarySoft,
      outline: outline ?? this.outline,
      shadow: shadow ?? this.shadow,
      navBackground: navBackground ?? this.navBackground,
      navSelectedBackground:
          navSelectedBackground ?? this.navSelectedBackground,
      navUnselectedBackground:
          navUnselectedBackground ?? this.navUnselectedBackground,
      navSelectedIcon: navSelectedIcon ?? this.navSelectedIcon,
      navUnselectedIcon: navUnselectedIcon ?? this.navUnselectedIcon,
      switchTrackOn: switchTrackOn ?? this.switchTrackOn,
      switchTrackOff: switchTrackOff ?? this.switchTrackOff,
      switchThumb: switchThumb ?? this.switchThumb,
      chartGrid: chartGrid ?? this.chartGrid,
      chartBar: chartBar ?? this.chartBar,
      chartBarActive: chartBarActive ?? this.chartBarActive,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navSelectedBackground: Color.lerp(
        navSelectedBackground,
        other.navSelectedBackground,
        t,
      )!,
      navUnselectedBackground: Color.lerp(
        navUnselectedBackground,
        other.navUnselectedBackground,
        t,
      )!,
      navSelectedIcon: Color.lerp(navSelectedIcon, other.navSelectedIcon, t)!,
      navUnselectedIcon: Color.lerp(
        navUnselectedIcon,
        other.navUnselectedIcon,
        t,
      )!,
      switchTrackOn: Color.lerp(switchTrackOn, other.switchTrackOn, t)!,
      switchTrackOff: Color.lerp(switchTrackOff, other.switchTrackOff, t)!,
      switchThumb: Color.lerp(switchThumb, other.switchThumb, t)!,
      chartGrid: Color.lerp(chartGrid, other.chartGrid, t)!,
      chartBar: Color.lerp(chartBar, other.chartBar, t)!,
      chartBarActive: Color.lerp(chartBarActive, other.chartBarActive, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get colors {
    return Theme.of(this).extension<AppThemeColors>()!;
  }
}
