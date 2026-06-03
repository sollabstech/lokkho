// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/auth_service.dart';
import 'app/services/firestore_service.dart';
import 'app/services/coin_service.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent google_fonts from fetching over network — use bundled/system fonts
  GoogleFonts.config.allowRuntimeFetching = false;

  // Lock portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A1A),
  ));

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize AdMob
  await MobileAds.instance.initialize();

  // Register services
  Get.put<FirestoreService>(FirestoreService(), permanent: true);
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<CoinService>(CoinService(), permanent: true);

  runApp(const LokkhoApp());
}

class LokkhoApp extends StatelessWidget {
  const LokkhoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lokkho',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),

      // Themes
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.dark,

      // Routes
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,

      // Global unknown route handler
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const _NotFoundPage(),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('Page Not Found', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.offAllNamed(Routes.home),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Go Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
