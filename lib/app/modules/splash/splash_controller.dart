// lib/app/modules/splash/splash_controller.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    try {
      await Future.delayed(const Duration(milliseconds: 2800));

      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

      // Guard: check AuthService is registered before finding it
      if (!Get.isRegistered<AuthService>()) {
        Get.offAllNamed(Routes.auth);
        return;
      }

      final authService = Get.find<AuthService>();

      final hasSelectedClass = (prefs.getString('selectedClass') ?? '').isNotEmpty;

      if (!hasSeenOnboarding) {
        Get.offAllNamed(Routes.onboarding);
      } else if (authService.isLoggedIn) {
        // Show class select only once — skip if already chosen
        if (hasSelectedClass) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.classSelect);
        }
      } else {
        Get.offAllNamed(Routes.auth);
      }
    } catch (e) {
      // Fallback so the app never gets truly stuck
      print('[SplashController] Navigation error: $e');
      Get.offAllNamed(Routes.auth);
    }
  }
}