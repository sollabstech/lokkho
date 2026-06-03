// lib/app/modules/courses/courses_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import 'courses_controller.dart';

class CoursesView extends GetView<CoursesController> {
  const CoursesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.deepGradient),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildTabs(),
                _buildSubjectFilter(),
                const SizedBox(height: 4),
                Expanded(child: _buildCourseList()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📚 Courses', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
          SizedBox(height: 2),
          Text('Bengali, English, History & more', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: List.generate(controller.tabs.length, (i) {
              final isSelected = controller.selectedTab.value == i;
              Color tabColor = AppColors.primary;
              if (i == 1) tabColor = AppColors.accentGreen;
              if (i == 2) tabColor = AppColors.accent;
              return GestureDetector(
                onTap: () => controller.setTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? tabColor : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? tabColor : Colors.white12),
                  ),
                  child: Row(
                    children: [
                      if (i == 1) const Text('🆓 ', style: TextStyle(fontSize: 12)),
                      if (i == 2) const Text('👑 ', style: TextStyle(fontSize: 12)),
                      Text(
                        controller.tabs[i],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }

  Widget _buildSubjectFilter() {
    return Obx(() {
      final selectedSubject = controller.selectedSubject.value; // read observable here
      return SizedBox(
          height: 52,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            scrollDirection: Axis.horizontal,
            itemCount: controller.subjects.length,
            itemBuilder: (context, i) {
              final s = controller.subjects[i];
              final name = s['name'] as String;
              final isSelected = selectedSubject == name; // use captured value
              final color = Color(s['color'] as int);
              return GestureDetector(
                onTap: () => controller.toggleSubject(name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? color : Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Text(s['emoji'] as String, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        name,
                        style: TextStyle(
                          color: isSelected ? color : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
    });
  }

  Widget _buildCourseList() {
    return Obx(() {
      final courses = controller.filteredCourses;
      if (courses.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('📭', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('No courses found', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text('Try a different filter', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        physics: const BouncingScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (context, i) => _CourseCard(
          course: courses[i],
          onTap: () => controller.openCourse(courses[i]),
        ),
      );
    });
  }
}

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const _CourseCard({required this.course, required this.onTap});

  Color get _subjectColor {
    switch (course.subject) {
      case 'Bengali':          return const Color(0xFF6C63FF);
      case 'English':          return const Color(0xFF00D4FF);
      case 'History':          return const Color(0xFFFF6B35);
      case 'Political Science':return const Color(0xFF00E676);
      case 'Geography':        return const Color(0xFFFFD700);
      default:                 return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _subjectColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(course.emoji, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: course.isPaid
                              ? const Color(0xFFFFD700).withOpacity(0.2)
                              : AppColors.accentGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: course.isPaid
                                ? const Color(0xFFFFD700).withOpacity(0.5)
                                : AppColors.accentGreen.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          course.isPaid ? '👑 Paid' : '🆓 Free',
                          style: TextStyle(
                            color: course.isPaid ? const Color(0xFFFFD700) : AppColors.accentGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(course.description, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  // Meta row
                  Row(
                    children: [
                      _Meta(icon: Icons.play_lesson_outlined, label: '${course.lessons} lessons', color: color),
                      const SizedBox(width: 14),
                      _Meta(icon: Icons.schedule_outlined, label: course.duration, color: color),
                      const SizedBox(width: 14),
                      _Meta(icon: Icons.school_outlined, label: course.userClass, color: color),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Meta({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 12),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
