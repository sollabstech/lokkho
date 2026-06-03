// lib/app/modules/leaderboard/leaderboard_controller.dart

import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

class LeaderboardController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  final currentTab = 0.obs;
  final isLoading = false.obs;
  final leaderboardData = <LeaderboardModel>[].obs;

  final tabs = ['Monthly', 'Weekly', 'Daily'];
  final periodKeys = ['monthly', 'weekly', 'daily'];

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    isLoading.value = true;
    try {
      final data = await _firestoreService.getLeaderboard(periodKeys[currentTab.value]);
      leaderboardData.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  void switchTab(int index) {
    currentTab.value = index;
    loadLeaderboard();
  }

  bool isCurrentUser(String uid) => _authService.currentUser.value?.uid == uid;

  List<LeaderboardModel> get top3 => leaderboardData.take(3).toList();
  List<LeaderboardModel> get rest => leaderboardData.skip(3).toList();
}
