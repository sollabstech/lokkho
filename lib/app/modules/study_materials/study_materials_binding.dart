// lib/app/modules/study_materials/study_materials_binding.dart

import 'package:get/get.dart';
import 'study_materials_controller.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../services/coin_service.dart';

class StudyMaterialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirestoreService>(() => FirestoreService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<CoinService>(() => CoinService());
    Get.lazyPut<StudyMaterialsController>(() => StudyMaterialsController());
  }
}
