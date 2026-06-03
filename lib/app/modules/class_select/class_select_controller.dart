// lib/app/modules/class_select/class_select_controller.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class ClassSelectController extends GetxController {
  final selectedClass = ''.obs;

  final List<Map<String, dynamic>> classes = [
    {'class': 'Class 10', 'label': 'Madhyamik', 'emoji': '📘', 'color': 0xFF6C63FF},
    {'class': 'Class 11', 'label': 'Higher Secondary Yr 1', 'emoji': '📗', 'color': 0xFF00D4FF},
    {'class': 'Class 12', 'label': 'Higher Secondary Yr 2', 'emoji': '📕', 'color': 0xFFFF6B35},
  ];

  void selectClass(String cls) async {
    selectedClass.value = cls;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedClass', cls);
    await Future.delayed(const Duration(milliseconds: 200));
    Get.offAllNamed(Routes.home);
  }
}
