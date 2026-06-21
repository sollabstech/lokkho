// lib/app/modules/test/test_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../services/auth_service.dart';
import '../../services/coin_service.dart';
import '../../services/firestore_service.dart';
import '../../routes/app_routes.dart';
import '../../../core/utils/helpers.dart';
import '../home/home_controller.dart';

class TestController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();
  final CoinService _coinService = Get.find<CoinService>();

  // Test listing
  final tests = <TestModel>[].obs;
  final isLoading = false.obs;
  final selectedClass = ''.obs;
  final selectedSubject = ''.obs;
  final selectedDifficulty = ''.obs;

  // Test interface
  final currentTest = Rx<TestModel?>(null);
  final currentQuestionIndex = 0.obs;
  final userAnswers = <int?>[].obs;
  final timeRemaining = 0.obs;
  final isTestActive = false.obs;
  Timer? _timer;

  // Answer states: null = unanswered, int = selected option
  final selectedAnswer = Rx<int?>(null);
  final showAnswer = false.obs;

  @override
  void onInit() {
    super.onInit();
    _syncClassFromHome();
    loadTests();
  }

  void _syncClassFromHome() {
    if (!Get.isRegistered<HomeController>()) return;
    final homeCtrl = Get.find<HomeController>();
    selectedClass.value = homeCtrl.selectedClass.value;
    ever(homeCtrl.selectedClass, (String cls) {
      selectedClass.value = cls;
      loadTests();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadTests() async {
    isLoading.value = true;
    try {
      final result = await _firestoreService.getTests(
        subject: selectedSubject.value.isEmpty ? null : selectedSubject.value,
        userClass: selectedClass.value.isEmpty ? null : selectedClass.value,
        difficulty: selectedDifficulty.value.isEmpty ? null : selectedDifficulty.value,
      );
      tests.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter({String? cls, String? subject, String? difficulty}) {
    if (cls != null) selectedClass.value = cls;
    if (subject != null) selectedSubject.value = subject;
    if (difficulty != null) selectedDifficulty.value = difficulty;
    loadTests();
  }

  Future<void> startTest(TestModel test) async {
    final deducted = await _coinService.deductCoins(
      test.coinCost,
      'Started test: ${test.title}',
    );
    if (!deducted) return;

    currentTest.value = test;
    userAnswers.value = List.filled(test.questions.length, null);
    currentQuestionIndex.value = 0;
    timeRemaining.value = test.duration;
    selectedAnswer.value = null;
    showAnswer.value = false;
    isTestActive.value = true;

    _startTimer();
    Get.toNamed(Routes.testInterface);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        _submitTest();
      }
    });
  }

  void selectAnswer(int answerIndex) {
    if (showAnswer.value) return;
    selectedAnswer.value = answerIndex;
    userAnswers[currentQuestionIndex.value] = answerIndex;
    showAnswer.value = true;
  }

  void nextQuestion() {
    final test = currentTest.value;
    if (test == null) return;

    if (currentQuestionIndex.value < test.questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = userAnswers[currentQuestionIndex.value];
      showAnswer.value = selectedAnswer.value != null;
    } else {
      _submitTest();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      selectedAnswer.value = userAnswers[currentQuestionIndex.value];
      showAnswer.value = selectedAnswer.value != null;
    }
  }

  void _submitTest() {
    _timer?.cancel();
    isTestActive.value = false;

    final test = currentTest.value;
    if (test == null) return;

    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (int i = 0; i < test.questions.length; i++) {
      final answer = userAnswers[i];
      if (answer == null) {
        skipped++;
      } else if (answer == test.questions[i].correctIndex) {
        correct++;
      } else {
        wrong++;
      }
    }

    final timeTaken = test.duration - timeRemaining.value;

    final result = TestResultModel(
      testId: test.id,
      testTitle: test.title,
      score: correct,
      totalMarks: test.questions.length,
      correctAnswers: correct,
      wrongAnswers: wrong,
      skippedAnswers: skipped,
      timeTaken: timeTaken,
      subject: test.subject,
      userAnswers: userAnswers.toList(),
      questions: test.questions,
    );

    // Save to Firestore
    _saveResult(result);

    // Award coins
    _coinService.testCompletionReward(correct, test.questions.length);

    Get.offNamed(Routes.scoreboard, arguments: result);
  }

  void quitTest() {
    Get.dialog(
      _QuitDialog(onConfirm: () {
        _timer?.cancel();
        isTestActive.value = false;
        Get.back();
        Get.back();
      }),
    );
  }

  Future<void> _saveResult(TestResultModel result) async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    await _firestoreService.saveTestResult(user.uid, {
      'testId': result.testId,
      'score': result.score,
      'accuracy': result.accuracy,
      'timeTaken': result.timeTaken,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  String get formattedTime => AppHelpers.formatTime(timeRemaining.value);
  double get timerProgress {
    final test = currentTest.value;
    if (test == null) return 0;
    return timeRemaining.value / test.duration;
  }
}

class _QuitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _QuitDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 16),
            const Text(
              'Quit Test?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your progress will be lost and coins will not be refunded.',
              style: TextStyle(color: Color(0xFFB0B0C8), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4444).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFFF4444).withOpacity(0.4),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Quit',
                          style: TextStyle(
                            color: Color(0xFFFF4444),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
