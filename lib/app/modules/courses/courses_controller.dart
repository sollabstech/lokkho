// lib/app/modules/courses/courses_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';

class CourseModel {
  final String id;
  final String title;
  final String subject;
  final String userClass;
  final bool isPaid;
  final String description;
  final String emoji;
  final int lessons;
  final String duration;

  const CourseModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.userClass,
    required this.isPaid,
    required this.description,
    required this.emoji,
    required this.lessons,
    required this.duration,
  });
}

class CoursesController extends GetxController {
  final selectedTab = 0.obs;     // 0=All, 1=Free, 2=Paid
  final selectedSubject = ''.obs;
  final selectedClass = ''.obs;

  final tabs = ['All', 'Free', 'Paid'];

  final subjects = [
    {'name': 'Bengali',          'emoji': '🔤', 'color': 0xFF6C63FF},
    {'name': 'English',          'emoji': '📖', 'color': 0xFF00D4FF},
    {'name': 'History',          'emoji': '🏛️',  'color': 0xFFFF6B35},
    {'name': 'Political Science','emoji': '⚖️',  'color': 0xFF00E676},
    {'name': 'Geography',        'emoji': '🌍', 'color': 0xFFFFD700},
  ];

  final allCourses = <CourseModel>[
    // Bengali
    CourseModel(id: 'b1', title: 'Bengali Class 10 Full Course', subject: 'Bengali', userClass: 'Class 10', isPaid: false, description: 'Complete Bengali syllabus for Madhyamik. Grammar, prose, poetry and writing.', emoji: '🔤', lessons: 24, duration: '18 hrs'),
    CourseModel(id: 'b2', title: 'Bengali Class 11 Foundation', subject: 'Bengali', userClass: 'Class 11', isPaid: true,  description: 'HS Year 1 Bengali — advanced prose, poetry analysis and essay writing.', emoji: '🔤', lessons: 20, duration: '15 hrs'),
    CourseModel(id: 'b3', title: 'Bengali Class 12 Master Course', subject: 'Bengali', userClass: 'Class 12', isPaid: true,  description: 'Complete HS Bengali for board exam. All chapters covered with notes.', emoji: '🔤', lessons: 22, duration: '16 hrs'),

    // English
    CourseModel(id: 'e1', title: 'English Class 10 Complete', subject: 'English', userClass: 'Class 10', isPaid: false, description: 'Full Madhyamik English — grammar, prose, poetry and writing skills.', emoji: '📖', lessons: 28, duration: '20 hrs'),
    CourseModel(id: 'e2', title: 'English Class 11 Speaking & Writing', subject: 'English', userClass: 'Class 11', isPaid: false, description: 'Build strong English foundation for HS. Essay, letter and grammar.', emoji: '📖', lessons: 18, duration: '14 hrs'),
    CourseModel(id: 'e3', title: 'English Class 12 Board Prep', subject: 'English', userClass: 'Class 12', isPaid: true,  description: 'Intensive HS English board preparation with previous year solutions.', emoji: '📖', lessons: 25, duration: '19 hrs'),

    // History
    CourseModel(id: 'h1', title: 'History Class 10 Full Syllabus', subject: 'History', userClass: 'Class 10', isPaid: false, description: 'Madhyamik History — all chapters with maps, dates and key events.', emoji: '🏛️', lessons: 22, duration: '17 hrs'),
    CourseModel(id: 'h2', title: 'History Class 11 Modern India', subject: 'History', userClass: 'Class 11', isPaid: true,  description: 'HS Year 1 History focusing on modern India and world history.', emoji: '🏛️', lessons: 20, duration: '16 hrs'),
    CourseModel(id: 'h3', title: 'History Class 12 Advanced', subject: 'History', userClass: 'Class 12', isPaid: true,  description: 'Complete HS Year 2 History with detailed notes and MCQ practice.', emoji: '🏛️', lessons: 24, duration: '18 hrs'),

    // Political Science
    CourseModel(id: 'p1', title: 'Political Science Class 11', subject: 'Political Science', userClass: 'Class 11', isPaid: false, description: 'Introduction to Political Science — Indian Constitution, rights and politics.', emoji: '⚖️', lessons: 16, duration: '12 hrs'),
    CourseModel(id: 'p2', title: 'Political Science Class 12 Board', subject: 'Political Science', userClass: 'Class 12', isPaid: true,  description: 'HS Political Science board exam prep — all chapters with MCQs.', emoji: '⚖️', lessons: 20, duration: '15 hrs'),

    // Geography
    CourseModel(id: 'g1', title: 'Geography Class 10 Full Course', subject: 'Geography', userClass: 'Class 10', isPaid: false, description: 'Madhyamik Geography — maps, climate, resources and human geography.', emoji: '🌍', lessons: 20, duration: '15 hrs'),
    CourseModel(id: 'g2', title: 'Geography Class 11 Physical', subject: 'Geography', userClass: 'Class 11', isPaid: false, description: 'HS Year 1 Geography — physical geography and environment.', emoji: '🌍', lessons: 18, duration: '13 hrs'),
    CourseModel(id: 'g3', title: 'Geography Class 12 Human & Economic', subject: 'Geography', userClass: 'Class 12', isPaid: true,  description: 'HS Year 2 Geography — human, economic and regional geography.', emoji: '🌍', lessons: 22, duration: '17 hrs'),
  ].obs;

  List<CourseModel> get filteredCourses {
    return allCourses.where((c) {
      final tabMatch = selectedTab.value == 0
          ? true
          : selectedTab.value == 1
              ? !c.isPaid
              : c.isPaid;
      final subjectMatch = selectedSubject.value.isEmpty || c.subject == selectedSubject.value;
      final classMatch = selectedClass.value.isEmpty || c.userClass == selectedClass.value;
      return tabMatch && subjectMatch && classMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<HomeController>()) return;
    final homeCtrl = Get.find<HomeController>();
    selectedClass.value = homeCtrl.selectedClass.value;
    ever(homeCtrl.selectedClass, (String cls) {
      selectedClass.value = cls;
    });
  }

  void setTab(int index) => selectedTab.value = index;

  void toggleSubject(String subject) {
    selectedSubject.value = selectedSubject.value == subject ? '' : subject;
  }

  void toggleClass(String cls) {
    selectedClass.value = selectedClass.value == cls ? '' : cls;
  }

  void openCourse(CourseModel course) {
    if (course.isPaid) {
      Get.snackbar(
        '👑 Premium Course',
        '${course.title}\n\nFull access coming soon!',
        backgroundColor: const Color(0xFF1A1A35),
        colorText: const Color(0xFFFFD700),
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        '🎓 ${course.title}',
        'Course coming soon! Stay tuned.',
        backgroundColor: const Color(0xFF1A1A35),
        colorText: const Color(0xFF00E676),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
