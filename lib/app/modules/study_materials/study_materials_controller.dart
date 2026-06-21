// lib/app/modules/study_materials/study_materials_controller.dart

import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../services/firestore_service.dart';
import '../../services/coin_service.dart';
import '../../../core/utils/helpers.dart';
import '../home/home_controller.dart';

class StudyMaterialsController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final CoinService _coinService = Get.find<CoinService>();

  final materials = <StudyMaterialModel>[].obs;
  final isLoading = false.obs;
  final selectedSubject = ''.obs;
  final selectedClass = ''.obs;
  final selectedMedium = ''.obs;
  final downloadingIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _syncClassFromHome();
    loadMaterials();
  }

  void _syncClassFromHome() {
    if (!Get.isRegistered<HomeController>()) return;
    final homeCtrl = Get.find<HomeController>();
    selectedClass.value = homeCtrl.selectedClass.value;
    ever(homeCtrl.selectedClass, (String cls) {
      selectedClass.value = cls;
      loadMaterials();
    });
  }

  Future<void> loadMaterials() async {
    isLoading.value = true;
    try {
      final result = await _firestoreService.getStudyMaterials(
        subject: selectedSubject.value.isEmpty ? null : selectedSubject.value,
        userClass: selectedClass.value.isEmpty ? null : selectedClass.value,
        medium: selectedMedium.value.isEmpty ? null : selectedMedium.value,
      );
      materials.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter({String? subject, String? cls, String? medium}) {
    if (subject != null) selectedSubject.value = subject;
    if (cls != null) selectedClass.value = cls;
    if (medium != null) selectedMedium.value = medium;
    loadMaterials();
  }

  void clearFilters() {
    selectedSubject.value = '';
    selectedClass.value = '';
    selectedMedium.value = '';
    loadMaterials();
  }

  Future<void> downloadMaterial(StudyMaterialModel material) async {
    if (downloadingIds.contains(material.id)) return;
    downloadingIds.add(material.id);
    try {
      // Simulate download
      await Future.delayed(const Duration(seconds: 2));
      // Award coins for watching
      await _coinService.videoWatchReward();
      AppHelpers.showSuccessSnackbar('Downloaded!', '${material.title} saved to your device.');
    } finally {
      downloadingIds.remove(material.id);
    }
  }

  void toggleBookmark(StudyMaterialModel material) {
    material.isBookmarked = !material.isBookmarked;
    materials.refresh();
  }
}
