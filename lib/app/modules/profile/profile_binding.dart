// lib/app/modules/profile/profile_binding.dart

import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/coin_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<CoinService>(() => CoinService());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
