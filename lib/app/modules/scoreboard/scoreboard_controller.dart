// lib/app/modules/scoreboard/scoreboard_controller.dart

import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../routes/app_routes.dart';

class ScoreboardController extends GetxController {
  late TestResultModel result;

  @override
  void onInit() {
    super.onInit();
    result = Get.arguments as TestResultModel;
  }

  void retakeTest() {
    Get.offAllNamed(Routes.home);
  }

  void goHome() {
    Get.offAllNamed(Routes.home);
  }

  String get badge {
    final acc = result.accuracy;
    if (acc >= 90) return '🏆 Master';
    if (acc >= 75) return '⭐ Expert';
    if (acc >= 60) return '👍 Learner';
    return '📚 Beginner';
  }
}
