// lib/app/modules/class_select/class_select_binding.dart

import 'package:get/get.dart';
import 'class_select_controller.dart';

class ClassSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassSelectController>(() => ClassSelectController());
  }
}
