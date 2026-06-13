import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static const String fontFamily = 'Plus Jakarta Sans';

  static TextTheme textTheme(Color textColor) =>
      GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          bodyLarge: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodySmall: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          labelLarge: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
          labelSmall: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      );
}
