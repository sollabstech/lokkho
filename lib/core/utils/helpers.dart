// lib/core/utils/helpers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class AppHelpers {
  static String formatCoins(int coins) {
    if (coins >= 1000) {
      return '${(coins / 1000).toStringAsFixed(1)}K';
    }
    return coins.toString();
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String getMotivationalQuote() {
    final quotes = [
      '"Education is the most powerful weapon you can use to change the world." — Nelson Mandela',
      '"The beautiful thing about learning is that no one can take it away from you." — B.B. King',
      '"An investment in knowledge pays the best interest." — Benjamin Franklin',
      '"The more that you read, the more things you will know." — Dr. Seuss',
      '"Live as if you were to die tomorrow. Learn as if you were to live forever." — Gandhi',
    ];
    final index = DateTime.now().day % quotes.length;
    return quotes[index];
  }

  static Color getScoreColor(double score) {
    if (score >= 80) return AppColors.accentGreen;
    if (score >= 60) return AppColors.accent;
    if (score >= 40) return AppColors.accentOrange;
    return AppColors.accentRed;
  }

  static String getScoreMessage(double score) {
    if (score >= 90) return '🏆 Outstanding! You\'re a star!';
    if (score >= 75) return '🎉 Excellent work! Keep it up!';
    if (score >= 60) return '👍 Good job! Room to improve!';
    if (score >= 40) return '💪 Keep practicing, you\'ll get there!';
    return '📚 Review the material and try again!';
  }

  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.accentGreen.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.accentRed.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  static void showCoinEarnedSnackbar(int coins) {
    Get.snackbar(
      '🪙 Coins Earned!',
      '+$coins coins added to your wallet',
      backgroundColor: AppColors.accent.withOpacity(0.9),
      colorText: Colors.black,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}
