// lib/app/modules/test/test_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'test_controller.dart';

class TestView extends GetView<TestController> {
  const TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.deepGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFilterBar(),
            Expanded(child: _buildTestList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 Tests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Challenge yourself & earn coins',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _FilterChip(
                label: controller.selectedClass.value.isEmpty
                    ? 'All Classes'
                    : controller.selectedClass.value,
                isActive: controller.selectedClass.value.isNotEmpty,
                onTap: () => _showClassPicker(),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: controller.selectedSubject.value.isEmpty
                    ? 'All Subjects'
                    : controller.selectedSubject.value,
                isActive: controller.selectedSubject.value.isNotEmpty,
                onTap: () => _showSubjectPicker(),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: controller.selectedDifficulty.value.isEmpty
                    ? 'Any Difficulty'
                    : controller.selectedDifficulty.value,
                isActive: controller.selectedDifficulty.value.isNotEmpty,
                onTap: () => _showDifficultyPicker(),
              ),
              if (controller.selectedClass.value.isNotEmpty ||
                  controller.selectedSubject.value.isNotEmpty ||
                  controller.selectedDifficulty.value.isNotEmpty) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    controller.applyFilter(cls: '', subject: '', difficulty: '');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentRed.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, color: AppColors.accentRed, size: 14),
                        SizedBox(width: 4),
                        Text('Clear', style: TextStyle(color: AppColors.accentRed, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildTestList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 4,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ShimmerCard(width: double.infinity, height: 140),
          ),
        );
      }
      if (controller.tests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📭', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              const Text('No tests found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Try changing your filters', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        itemCount: controller.tests.length,
        itemBuilder: (context, i) => _buildTestCard(controller.tests[i]),
      );
    });
  }

  Widget _buildTestCard(TestModel test) {
    final difficultyColor = test.difficulty == 'Easy'
        ? AppColors.accentGreen
        : test.difficulty == 'Medium'
            ? AppColors.accent
            : AppColors.accentRed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        onTap: () => controller.startTest(test),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${test.userClass} • ${test.chapter}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                CoinBadge(coins: test.coinCost, compact: true),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoBadge(icon: Icons.quiz_outlined, label: '${test.questions.length} Qs', color: AppColors.primary),
                const SizedBox(width: 8),
                _InfoBadge(icon: Icons.timer_outlined, label: '${test.duration ~/ 60} min', color: AppColors.secondary),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: difficultyColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    test.difficulty,
                    style: TextStyle(color: difficultyColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClassPicker() {
    Get.bottomSheet(
      _PickerSheet(
        title: 'Select Class',
        items: AppSubjects.classes,
        selected: controller.selectedClass.value,
        onSelect: (v) => controller.applyFilter(cls: v),
      ),
    );
  }

  void _showSubjectPicker() {
    Get.bottomSheet(
      _PickerSheet(
        title: 'Select Subject',
        items: AppSubjects.subjects.map((s) => s['name'] as String).toList(),
        selected: controller.selectedSubject.value,
        onSelect: (v) => controller.applyFilter(subject: v),
      ),
    );
  }

  void _showDifficultyPicker() {
    Get.bottomSheet(
      _PickerSheet(
        title: 'Select Difficulty',
        items: AppSubjects.difficulties,
        selected: controller.selectedDifficulty.value,
        onSelect: (v) => controller.applyFilter(difficulty: v),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({Key? key, required this.label, required this.isActive, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? AppColors.primaryGradient
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: isActive ? Colors.white : AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge({Key? key, required this.icon, required this.label, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selected;
  final Function(String) onSelect;

  const _PickerSheet({Key? key, required this.title, required this.items, required this.selected, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              final isSelected = item == selected;
              return GestureDetector(
                onTap: () {
                  onSelect(isSelected ? '' : item);
                  Get.back();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? Colors.transparent : Colors.white12),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
