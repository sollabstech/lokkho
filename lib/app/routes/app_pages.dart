// lib/app/routes/app_pages.dart

import 'package:get/get.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/class_select/class_select_binding.dart';
import '../modules/class_select/class_select_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/test/test_binding.dart';
import '../modules/test/test_view.dart';
import '../modules/test/test_interface_view.dart';
import '../modules/scoreboard/scoreboard_binding.dart';
import '../modules/scoreboard/scoreboard_view.dart';
import '../modules/earn_coins/earn_coins_binding.dart';
import '../modules/earn_coins/earn_coins_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/leaderboard/leaderboard_binding.dart';
import '../modules/leaderboard/leaderboard_view.dart';
import '../modules/study_materials/study_materials_binding.dart';
import '../modules/study_materials/study_materials_view.dart';
import '../modules/courses/courses_binding.dart';
import '../modules/courses/courses_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.classSelect,
      page: () => const ClassSelectView(),
      binding: ClassSelectBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.test,
      page: () => const TestView(),
      binding: TestBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.testInterface,
      page: () => const TestInterfaceView(),
      binding: TestBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.scoreboard,
      page: () => const ScoreboardView(),
      binding: ScoreboardBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.earnCoins,
      page: () => const EarnCoinsView(),
      binding: EarnCoinsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.leaderboard,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.studyMaterials,
      page: () => const StudyMaterialsView(),
      binding: StudyMaterialsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.courses,
      page: () => const CoursesView(),
      binding: CoursesBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
