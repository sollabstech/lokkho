// lib/app/modules/scoreboard/scoreboard_view.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import 'scoreboard_controller.dart';

class ScoreboardView extends GetView<ScoreboardController> {
  const ScoreboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final result = controller.result;
    final scoreColor = AppHelpers.getScoreColor(result.accuracy);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.deepGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildScoreCard(result, scoreColor),
                const SizedBox(height: 20),
                _buildStatsRow(result),
                const SizedBox(height: 20),
                _buildAccuracyChart(result),
                const SizedBox(height: 20),
                _buildMessageCard(result),
                const SizedBox(height: 20),
                _buildCoinsEarned(result),
                const SizedBox(height: 24),
                _buildActions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.goHome,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_rounded, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Test Complete! 🎉', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            Text('Here are your results', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreCard(result, Color scoreColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      gradientColors: [scoreColor.withOpacity(0.15), Colors.transparent],
      boxShadow: [BoxShadow(color: scoreColor.withOpacity(0.2), blurRadius: 30, spreadRadius: 2)],
      child: Column(
        children: [
          Text(result.testTitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 20),
          ScoreGauge(score: result.score.toDouble(), maxScore: result.totalMarks.toDouble(), size: 160),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scoreColor.withOpacity(0.4)),
            ),
            child: Text(
              controller.badge,
              style: TextStyle(color: scoreColor, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${result.score} / ${result.totalMarks} marks',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(result) {
    return Row(
      children: [
        Expanded(child: _StatCard(value: '${result.correctAnswers}', label: 'Correct', color: AppColors.accentGreen, icon: '✅')),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(value: '${result.wrongAnswers}', label: 'Wrong', color: AppColors.accentRed, icon: '❌')),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(value: '${result.skippedAnswers}', label: 'Skipped', color: AppColors.accent, icon: '⏭️')),
      ],
    );
  }

  Widget _buildAccuracyChart(result) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Breakdown', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: result.totalMarks.toDouble(),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Correct', 'Wrong', 'Skipped'];
                        if (value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(labels[value.toInt()],
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBar(0, result.correctAnswers.toDouble(), AppColors.accentGreen),
                  _makeBar(1, result.wrongAnswers.toDouble(), AppColors.accentRed),
                  _makeBar(2, result.skippedAnswers.toDouble(), AppColors.accent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeRow(result),
        ],
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: 36,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.white.withOpacity(0.04),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow(result) {
    final minutes = result.timeTaken ~/ 60;
    final seconds = result.timeTaken % 60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 16),
        const SizedBox(width: 6),
        Text(
          'Completed in ${minutes}m ${seconds}s',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildMessageCard(result) {
    final msg = AppHelpers.getScoreMessage(result.accuracy);
    return GlassCard(
      padding: const EdgeInsets.all(20),
      gradientColors: [AppColors.primary.withOpacity(0.1), Colors.transparent],
      child: Text(
        msg,
        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600, height: 1.4),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCoinsEarned(result) {
    final coins = result.coinsEarned;
    if (coins == 0) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Text('+$coins Coins Earned!', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        GradientButton(text: 'Back to Home', onPressed: controller.goHome),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: controller.retakeTest,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: const Center(
              child: Text('Try Another Test', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final String icon;

  const _StatCard({Key? key, required this.value, required this.label, required this.color, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
