// lib/core/theme/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBg,
      error: AppColors.accentRed,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.poppins(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.poppins(
        color: AppColors.textMuted,
        fontSize: 12,
      ),
      labelLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
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
    cardTheme: CardThemeData(        // ✅ Fixed: CardTheme → CardThemeData
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerColor: Colors.white.withOpacity(0.08),
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}