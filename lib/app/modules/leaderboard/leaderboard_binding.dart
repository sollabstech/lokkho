// lib/app/modules/leaderboard/leaderboard_binding.dart

import 'package:get/get.dart';
import 'leaderboard_controller.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<LeaderboardController>(() => LeaderboardController());
  }
}
