// lib/app/modules/test/test_interface_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'test_controller.dart';

class TestInterfaceView extends GetView<TestController> {
  const TestInterfaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.quitTest();
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.deepGradient),
          child: SafeArea(
            child: Obx(() {
              final test = controller.currentTest.value;
              if (test == null) return const SizedBox();
              final question = test.questions[controller.currentQuestionIndex.value];

              return Column(
                children: [
                  _buildTopBar(test),
                  _buildTimerAndProgress(test),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuestion(question.question, controller.currentQuestionIndex.value + 1, test.questions.length),
                          const SizedBox(height: 24),
                          ...question.options.asMap().entries.map((e) => _buildOption(e.key, e.value, question.correctIndex)),
                          if (controller.showAnswer.value && question.explanation != null)
                            _buildExplanation(question.explanation!),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomNav(test),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(test) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.quitTest,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              test.title,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Obx(() => CoinBadge(coins: Get.find<TestController>().currentQuestionIndex.value + 1, compact: true)),
        ],
      ),
    );
  }

  Widget _buildTimerAndProgress(test) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Obx(() {
        final progress = (controller.currentQuestionIndex.value + 1) / test.questions.length;
        final timerColor = controller.timeRemaining.value < 30
            ? AppColors.accentRed
            : controller.timeRemaining.value < 60
                ? AppColors.accent
                : AppColors.secondary;

        return Row(
          children: [
            // Timer circle
            Container(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: controller.timerProgress,
                      strokeWidth: 4,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                    ),
                  ),
                  Text(
                    controller.formattedTime,
                    style: TextStyle(
                      color: timerColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Q ${controller.currentQuestionIndex.value + 1}/${test.questions.length}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuestion(String question, int qNum, int total) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      gradientColors: [
        AppColors.primary.withOpacity(0.15),
        Colors.transparent,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Question $qNum',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String option, int correctIndex) {
    return Obx(() {
      final selected = controller.selectedAnswer.value;
      final showAnswer = controller.showAnswer.value;
      final isSelected = selected == index;
      final isCorrect = index == correctIndex;

      Color borderColor = Colors.white.withOpacity(0.12);
      Color bgColor = Colors.white.withOpacity(0.05);
      Color textColor = AppColors.textSecondary;
      Widget? trailingIcon;

      if (showAnswer) {
        if (isCorrect) {
          borderColor = AppColors.accentGreen;
          bgColor = AppColors.accentGreen.withOpacity(0.15);
          textColor = AppColors.accentGreen;
          trailingIcon = const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 20);
        } else if (isSelected && !isCorrect) {
          borderColor = AppColors.accentRed;
          bgColor = AppColors.accentRed.withOpacity(0.15);
          textColor = AppColors.accentRed;
          trailingIcon = const Icon(Icons.cancel, color: AppColors.accentRed, size: 20);
        }
      } else if (isSelected) {
        borderColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.15);
        textColor = Colors.white;
      }

      final optionLabel = String.fromCharCode(65 + index); // A, B, C, D

      return GestureDetector(
        onTap: () => controller.selectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: showAnswer && isCorrect
                ? [BoxShadow(color: AppColors.accentGreen.withOpacity(0.2), blurRadius: 12)]
                : showAnswer && isSelected && !isCorrect
                    ? [BoxShadow(color: AppColors.accentRed.withOpacity(0.2), blurRadius: 12)]
                    : [],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor.withOpacity(0.15),
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Text(
                    optionLabel,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              if (trailingIcon != null) trailingIcon,
            ],
          ),
        ),
      );
    });
  }

  Widget _buildExplanation(String explanation) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              explanation,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(test) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Obx(() {
        final isLast = controller.currentQuestionIndex.value == test.questions.length - 1;
        final isFirst = controller.currentQuestionIndex.value == 0;
        return Row(
          children: [
            if (!isFirst)
              Expanded(
                child: GestureDetector(
                  onTap: controller.previousQuestion,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white70, size: 16),
                        SizedBox(width: 6),
                        Text('Previous', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            if (!isFirst) const SizedBox(width: 12),
            Expanded(
              flex: isFirst ? 1 : 1,
              child: GradientButton(
                text: isLast ? 'Submit Test ✓' : 'Next →',
                onPressed: controller.nextQuestion,
                height: 52,
              ),
            ),
          ],
        );
      }),
    );
  }
}
