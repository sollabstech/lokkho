// lib/app/modules/scoreboard/scoreboard_binding.dart

import 'package:get/get.dart';
import 'scoreboard_controller.dart';

class ScoreboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScoreboardController>(() => ScoreboardController());
  }
}
