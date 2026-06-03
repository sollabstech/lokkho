// lib/app/modules/earn_coins/earn_coins_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/models/models.dart';
import '../../services/auth_service.dart';
import '../../services/coin_service.dart';
import '../../services/firestore_service.dart';
import '../../../core/utils/helpers.dart';

// Use real ad unit ID for production, test ID for debug
const _rewardedAdUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/5224354917' // Google test ad unit
    : 'ca-app-pub-2198003580349280/2474618119'; // Production ad unit

class EarnCoinsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final CoinService _coinService = Get.find<CoinService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final coinHistory = <CoinHistoryModel>[].obs;
  final isLoadingHistory = false.obs;
  final isWatchingAd = false.obs;
  final isAdLoading = false.obs;
  final dailyLoginClaimed = false.obs;

  RewardedAd? _rewardedAd;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
    _loadRewardedAd();
  }

  @override
  void onClose() {
    _rewardedAd?.dispose();
    super.onClose();
  }

  void _loadRewardedAd() {
    isAdLoading.value = true;
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[AD] Rewarded ad loaded');
          _rewardedAd = ad;
          isAdLoading.value = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AD] Rewarded ad failed to load: ${error.message}');
          _rewardedAd = null;
          isAdLoading.value = false;
        },
      ),
    );
  }

  Future<void> watchAd() async {
    if (isWatchingAd.value) return;

    if (_rewardedAd == null) {
      AppHelpers.showErrorSnackbar('Ad Not Ready', 'Please wait a moment and try again.');
      _loadRewardedAd();
      return;
    }

    isWatchingAd.value = true;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('[AD] Rewarded ad shown');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('[AD] Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        isWatchingAd.value = false;
        _loadRewardedAd(); // Pre-load next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AD] Rewarded ad failed to show: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        isWatchingAd.value = false;
        AppHelpers.showErrorSnackbar('Ad Error', 'Could not show ad. Try again.');
        _loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) async {
        debugPrint('[AD] User earned reward: ${reward.amount} ${reward.type}');
        await _coinService.addCoins(10, 'ad_watch', 'Watched a rewarded ad 📺');
        await _loadHistory();
        AppHelpers.showSuccessSnackbar('🎉 +10 Coins!', 'Thanks for watching the ad!');
      },
    );
  }

  Future<void> _loadHistory() async {
    isLoadingHistory.value = true;
    final user = _authService.currentUser.value;
    if (user != null) {
      coinHistory.value = await _firestoreService.getCoinHistory(user.uid);
    }
    isLoadingHistory.value = false;
  }

  int get totalCoins => _authService.currentUser.value?.coins ?? 0;

  Future<void> claimDailyLogin() async {
    if (dailyLoginClaimed.value) {
      AppHelpers.showErrorSnackbar('Already Claimed', 'Come back tomorrow for your daily bonus!');
      return;
    }
    await _coinService.dailyLoginReward();
    dailyLoginClaimed.value = true;
    await _loadHistory();
  }

  Future<void> referFriend() async {
    AppHelpers.showSuccessSnackbar('Referral Link Copied!', 'Share with friends to earn 50 coins each!');
  }

  Future<void> buyCoins(int amount, int price) async {
    AppHelpers.showSuccessSnackbar('🛒 Coming Soon', 'In-app purchases will be available soon!');
  }
}
