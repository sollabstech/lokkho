// lib/app/modules/home/home_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/models.dart';
import '../../services/auth_service.dart';
import '../../../core/utils/helpers.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final currentTabIndex = 0.obs;
  final selectedSubject = ''.obs;
  final selectedClass = ''.obs;
  final isLoading = false.obs;

  UserModel? get currentUser => _authService.currentUser.value;

  // 5 real videos from Lokkho Education YouTube channel
  final videos = <VideoModel>[
    VideoModel(
      id: 'qLNNH2xfcQY',
      title: 'Class 12 3rd Semester Human Geography: Population and Population Distribution',
      subject: 'Geography',
      thumbnailUrl: 'https://img.youtube.com/vi/qLNNH2xfcQY/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=qLNNH2xfcQY',
      duration: '',
      views: 0,
      userClass: 'Class 12',
    ),
    VideoModel(
      id: 'rMojyB5W4rA',
      title: 'Best Scholarship After Madhyamik 2026 | Scholarship Money After Passing Madhyamik',
      subject: 'General',
      thumbnailUrl: 'https://img.youtube.com/vi/rMojyB5W4rA/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=rMojyB5W4rA',
      duration: '',
      views: 0,
      userClass: 'Class 10',
    ),
    VideoModel(
      id: 'MOjXE4LUVx0',
      title: 'Class 12 3rd Semester Political Science Syllabus First Class | West Bengal Board',
      subject: 'Political Science',
      thumbnailUrl: 'https://img.youtube.com/vi/MOjXE4LUVx0/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=MOjXE4LUVx0',
      duration: '',
      views: 0,
      userClass: 'Class 12',
    ),
    VideoModel(
      id: '37D5kuiFogI',
      title: 'Class 10 1st Unit Test History Last Minute Suggestion | Madhyamik History Suggestion 2026',
      subject: 'History',
      thumbnailUrl: 'https://img.youtube.com/vi/37D5kuiFogI/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=37D5kuiFogI',
      duration: '',
      views: 0,
      userClass: 'Class 10',
    ),
    VideoModel(
      id: 'T8Yehih38yY',
      title: 'Madhyamik 2026 English Writing Suggestion | 100% Common Writing Topics',
      subject: 'English',
      thumbnailUrl: 'https://img.youtube.com/vi/T8Yehih38yY/hqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=T8Yehih38yY',
      duration: '',
      views: 0,
      userClass: 'Class 10',
    ),
  ].obs;

  List<VideoModel> get filteredVideos {
    if (selectedClass.value.isEmpty) return videos;
    return videos.where((v) => v.userClass == selectedClass.value).toList();
  }

  void setSelectedClass(String cls) {
    selectedClass.value = cls;
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void selectSubject(String subject) {
    if (selectedSubject.value == subject) {
      selectedSubject.value = '';
    } else {
      selectedSubject.value = subject;
    }
  }

  Future<void> openVideo(VideoModel video) async {
    final youtubeAppUrl = Uri.parse('youtube://www.youtube.com/watch?v=${video.id}');
    final webUrl = Uri.parse('https://www.youtube.com/watch?v=${video.id}');
    try {
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[HOME] Failed to open video: $e');
      AppHelpers.showErrorSnackbar('Error', 'Could not open video.');
    }
  }

  String get greeting => AppHelpers.getGreeting();
  String get motivationalQuote => AppHelpers.getMotivationalQuote();
}
