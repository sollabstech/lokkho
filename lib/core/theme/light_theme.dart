// lib/core/theme/light_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      background: AppColors.lightBg,
      error: AppColors.accentRed,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBg,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.poppins(
        color: const Color(0xFF1A1A35),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF1A1A35)),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: const Color(0xFF1A1A35),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: const Color(0xFF1A1A35),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: const Color(0xFF1A1A35),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        color: const Color(0xFF1A1A35),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: const Color(0xFF2D2D4A),
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: const Color(0xFF5A5A7A),
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.poppins(
        color: const Color(0xFF8A8AAA),
        fontSize: 12,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(       // ✅ Fixed: CardTheme → CardThemeData
      color: AppColors.lightSurface,
      elevation: 2,
      shadowColor: AppColors.lightPrimary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
    ),
    dividerColor: Colors.black.withOpacity(0.08),
  );
}