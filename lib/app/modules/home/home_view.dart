// lib/app/modules/home/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/animated_bottom_nav.dart';
import '../test/test_view.dart';
import '../courses/courses_view.dart';
import '../earn_coins/earn_coins_view.dart';
import '../profile/profile_view.dart';
import 'home_controller.dart';
import 'home_tab_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() {
        switch (controller.currentTabIndex.value) {
          case 1: return const TestView();
          case 2: return const CoursesView();
          case 3: return const EarnCoinsView();
          case 4: return const ProfileView();
          default: return const HomeTabView();
        }
      }),
      bottomNavigationBar: Obx(() => AnimatedBottomNav(
            currentIndex: controller.currentTabIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }
}
