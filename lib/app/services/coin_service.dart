// lib/app/services/coin_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import '../../core/utils/helpers.dart';

class CoinService extends GetxService {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  Future<bool> deductCoins(int amount, String description) async {
    final user = _authService.currentUser.value;
    if (user == null) return false;
    if (user.coins < amount) {
      AppHelpers.showErrorSnackbar(
          'Insufficient Coins', 'You need $amount coins to start this test.');
      return false;
    }

    final newCoins = user.coins - amount;
    await _firestoreService.updateUser(user.uid, {'coins': newCoins});
    await _addCoinHistory(-amount, 'deduction', description);
    _authService.currentUser.value = user.copyWith(coins: newCoins);
    return true;
  }

  Future<void> addCoins(int amount, String type, String description) async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    final newCoins = user.coins + amount;
    await _firestoreService.updateUser(user.uid, {'coins': newCoins});
    await _addCoinHistory(amount, type, description);
    _authService.currentUser.value = user.copyWith(coins: newCoins);
    AppHelpers.showCoinEarnedSnackbar(amount);
  }

  Future<void> _addCoinHistory(
      int amount, String type, String description) async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    await _firestoreService.addCoinHistory(user.uid, {
      'amount': amount,
      'type': type,
      'description': description,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> dailyLoginReward() async {
    await addCoins(5, 'daily_login', 'Daily Login Bonus');
  }

  Future<void> videoWatchReward() async {
    await addCoins(2, 'video_watch', 'Watched a video');
  }

  Future<void> testCompletionReward(int score, int totalMarks) async {
    final percentage = (score / totalMarks) * 100;
    final coinReward = (percentage / 10).floor() * 2;
    if (coinReward > 0) {
      await addCoins(coinReward, 'test_completion',
          'Completed test with ${percentage.toStringAsFixed(0)}% score');
    }
  }

  Future<void> referralReward() async {
    await addCoins(50, 'referral', 'Friend referral bonus');
  }
}
