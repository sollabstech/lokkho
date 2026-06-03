// lib/app/modules/splash/splash_binding.dart

import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Use put() not lazyPut() — ensures controller is created immediately
    // so onInit() fires and navigation actually runs
    Get.put<SplashController>(SplashController());
  }
}