// lib/app/modules/test/test_binding.dart

import 'package:get/get.dart';
import 'test_controller.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../services/coin_service.dart';

class TestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<CoinService>(() => CoinService());
    Get.lazyPut<TestController>(() => TestController());
  }
}
