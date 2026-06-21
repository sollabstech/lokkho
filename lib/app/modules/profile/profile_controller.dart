// lib/app/modules/profile/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

const _whatsappNumber = '918670347631';
const _phoneNumber = '+918670347631';
const _whatsappChannel = 'https://whatsapp.com/channel/0029Vb6u3BtCHDynkBx33C3A';
const _youtubeUrl = 'https://www.youtube.com/@LokkhoEducation';
const _instagramUrl = 'https://www.instagram.com/lokkho.insta';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final isDarkMode = true.obs;

  get currentUser => _authService.currentUser.value;

  int get xpToNextLevel {
    final user = currentUser;
    if (user == null) return 100;
    return 100 * (user.level as int);
  }

  double get xpProgress {
    final user = currentUser;
    if (user == null) return 0;
    return (user.xp % xpToNextLevel) / xpToNextLevel;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A35),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Color(0xFFB0B0C8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
            ),
            onPressed: () async {
              await _authService.signOut();
              Get.offAllNamed(Routes.auth);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void customerSupport() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A35),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('We are here to help you!', style: TextStyle(color: Color(0xFFB0B0C8), fontSize: 13)),
            const SizedBox(height: 24),
            _contactOption(
              icon: Icons.chat_rounded,
              color: const Color(0xFF25D366),
              title: 'WhatsApp',
              subtitle: '+91 93841 99108',
              onTap: () => _launchUrl('https://wa.me/$_whatsappNumber'),
            ),
            const SizedBox(height: 12),
            _contactOption(
              icon: Icons.call_rounded,
              color: const Color(0xFF6C63FF),
              title: 'Phone Call',
              subtitle: '+91 93841 99108',
              onTap: () => _launchUrl('tel:$_phoneNumber'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(subtitle, style: const TextStyle(color: Color(0xFFB0B0C8), fontSize: 13)),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ],
        ),
      ),
    );
  }

  Future<void> changeClass() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedClass');
    Get.offAllNamed(Routes.classSelect);
  }

  void openYoutube() => _launchUrl(_youtubeUrl);
  void openWhatsappChannel() => _launchUrl(_whatsappChannel);
  void openInstagram() => _launchUrl(_instagramUrl);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open link', backgroundColor: const Color(0xFF1A1A35), colorText: Colors.white);
    }
  }

  final achievements = [
    {'icon': '🔥', 'title': '7-Day Streak', 'unlocked': true},
    {'icon': '🏆', 'title': 'Top 10', 'unlocked': true},
    {'icon': '📚', 'title': '10 Tests Done', 'unlocked': true},
    {'icon': '⭐', 'title': 'Perfect Score', 'unlocked': false},
    {'icon': '🎯', 'title': '100 Questions', 'unlocked': false},
    {'icon': '💎', 'title': '1000 Coins', 'unlocked': false},
  ];
}