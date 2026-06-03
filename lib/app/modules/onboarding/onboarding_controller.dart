// lib/app/modules/onboarding/onboarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final List<Map<String, dynamic>> slides = [
    {
      'title': 'Learn Smarter',
      'subtitle': 'Access premium study materials for Class 1-12. Video lessons, PDFs, and interactive content curated by top educators.',
      'emoji': '📚',
      'gradient': [const Color(0xFF6C63FF), const Color(0xFF3B35CC)],
      'accentColor': const Color(0xFF6C63FF),
    },
    {
      'title': 'Test & Compete',
      'subtitle': 'Challenge yourself with timed MCQ tests. Compete with thousands of students across India and climb the leaderboard.',
      'emoji': '🏆',
      'gradient': [const Color(0xFF00D4FF), const Color(0xFF0080CC)],
      'accentColor': const Color(0xFF00D4FF),
    },
    {
      'title': 'Earn While Learning',
      'subtitle': 'Earn coins for every activity. Watch videos, complete tests, and redeem exciting rewards!',
      'emoji': '🪙',
      'gradient': [const Color(0xFFFFD700), const Color(0xFFFF8C00)],
      'accentColor': const Color(0xFFFFD700),
    },
  ];

  void nextPage() {
    if (currentPage.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void skip() => _completeOnboarding();

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Get.offAllNamed(Routes.auth);
  }

  void onPageChanged(int page) => currentPage.value = page;
}
