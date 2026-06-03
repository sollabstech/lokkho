// lib/app/modules/home/home_binding.dart

import 'package:get/get.dart';
import 'home_controller.dart';
import '../test/test_controller.dart';
import '../courses/courses_controller.dart';
import '../earn_coins/earn_coins_controller.dart';
import '../profile/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TestController>(() => TestController());
    Get.lazyPut<CoursesController>(() => CoursesController());
    Get.lazyPut<EarnCoinsController>(() => EarnCoinsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
