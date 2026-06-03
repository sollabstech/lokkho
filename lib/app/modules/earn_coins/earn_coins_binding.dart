// lib/app/modules/earn_coins/earn_coins_binding.dart

import 'package:get/get.dart';
import 'earn_coins_controller.dart';
import '../../services/auth_service.dart';
import '../../services/coin_service.dart';
import '../../services/firestore_service.dart';

class EarnCoinsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<CoinService>(() => CoinService());
    Get.lazyPut<EarnCoinsController>(() => EarnCoinsController());
  }
}
