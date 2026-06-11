// lib/core/utils/constants.dart

import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme
  static const Color darkBg = Color(0xFF0A0A1A);
  static const Color darkSurface = Color(0xFF12122A);
  static const Color darkCard = Color(0xFF1A1A35);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00D4FF);
  static const Color accent = Color(0xFFFFD700);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentGreen = Color(0xFF00E676);
  static const Color accentRed = Color(0xFFFF4444);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C8);
  static const Color textMuted = Color(0xFF6B6B8A);

  // Light Theme
  static const Color lightBg = Color(0xFFF0F2FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF5A52E0);
  static const Color lightAccent = Color(0xFFFFB800);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepGradient = LinearGradient(
    colors: [Color(0xFF0A0A1A), Color(0xFF1A0A3A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleCyanGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFD700)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A40), Color(0xFF0D0D25)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration glassDecoration({
    double opacity = 0.1,
    double borderRadius = 20,
    List<Color>? gradientColors,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        colors: gradientColors ??
            [
              Colors.white.withOpacity(opacity),
              Colors.white.withOpacity(opacity * 0.3),
            ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: Colors.white.withOpacity(0.15),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: primary.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class AppStrings {
  static const String appName = 'Lokkho';
  static const String tagline = 'Focus. Target. Achieve.';

  // Onboarding
  static const List<String> onboardingTitles = [
    'Learn Smarter',
    'Test & Compete',
    'Earn While Learning',
  ];

  static const List<String> onboardingSubtitles = [
    'Access premium study materials curated for Class 1-12. Video lessons, PDFs, and interactive content.',
    'Challenge yourself with timed MCQ tests. Compete with students across India and climb the leaderboard.',
    'Earn coins for every activity. Watch videos, complete tests, and redeem rewards.',
  ];
}

class AppSizes {
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;
  static const double paddingXXL = 48;

  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 20;
  static const double radiusXL = 28;
  static const double radiusXXL = 40;
}

class AppSubjects {
  static const List<Map<String, dynamic>> subjects = [
    {'name': 'Bengali', 'icon': '🅱️', 'color': Color(0xFF6C63FF)},
    {'name': 'English', 'icon': '📚', 'color': Color(0xFF00E676)},
    {'name': 'Political Science', 'icon': '🏛️', 'color': Color(0xFF00D4FF)},
    {'name': 'History', 'icon': '📜', 'color': Color(0xFFFF6B35)},
    {'name': 'Geography', 'icon': '🌍', 'color': Color(0xFFFFD700)},
  ];

  static const List<String> classes = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6',
    'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12',
  ];

  static const List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  static const List<String> mediums = ['English', 'Bengali'];
}
