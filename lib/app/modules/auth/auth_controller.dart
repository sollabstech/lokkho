// lib/app/modules/auth/auth_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../../core/utils/helpers.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final isLoading = false.obs;

  Future<void> signInWithGoogle() async {
    debugPrint('[AUTH_CTRL] signInWithGoogle button tapped');
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('[AUTH_CTRL] Sign-in timed out after 15s');
          return null;
        },
      );
      if (user != null) {
        debugPrint('[AUTH_CTRL] Sign-in success. User: ${user.name}');
        AppHelpers.showSuccessSnackbar(
          'Welcome to Lokkho! 🎉',
          'Hello, ${user.name.split(' ').first}! Ready to learn?',
        );
        // Show class select only if not already chosen
        final prefs = await SharedPreferences.getInstance();
        final hasSelectedClass = (prefs.getString('selectedClass') ?? '').isNotEmpty;
        if (hasSelectedClass) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.classSelect);
        }
      } else {
        debugPrint('[AUTH_CTRL] Sign-in returned null (user cancelled or timed out)');
        AppHelpers.showErrorSnackbar(
          'Sign In Failed',
          'Could not sign in with Google. Please check your internet connection and try again.',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[AUTH_CTRL] Sign-in exception: $e');
      debugPrint('[AUTH_CTRL] StackTrace: $stackTrace');
      final message = e.toString().contains('network_error')
          ? 'Network error. Please check your internet connection and try again.'
          : 'Sign in failed. Please try again.';
      AppHelpers.showErrorSnackbar('Sign In Failed', message);
    } finally {
      isLoading.value = false;
      debugPrint('[AUTH_CTRL] signInWithGoogle complete, isLoading=false');
    }
  }
}
