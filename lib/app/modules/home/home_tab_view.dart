// lib/app/modules/home/home_tab_view.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/models.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';

class HomeTabView extends GetView<HomeController> {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.deepGradient),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildDailyChallenge()),
            SliverToBoxAdapter(child: _buildStreakAndQuote()),
            SliverToBoxAdapter(child: _buildSubjectSlider()),
            SliverToBoxAdapter(child: _buildQuickActions()),
            SliverToBoxAdapter(child: _buildTrendingVideosTitle()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _buildVideoCard(controller.videos[i]),
                childCount: controller.videos.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Obx(() {
        final user = controller.currentUser;
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.greeting,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.name.split(' ').first ?? 'Student',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            // Notification bell
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Coin badge
            Obx(() => CoinBadge(coins: controller.currentUser?.coins ?? 0)),
          ],
        );
      }),
    );
  }

  Widget _buildDailyChallenge() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: GlassCard(
        gradientColors: [
          AppColors.primary.withOpacity(0.3),
          AppColors.secondary.withOpacity(0.1),
        ],
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('⚡', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Challenge',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    'Mathematics – Algebra',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      const Text(
                        '+50 coins • 10 questions',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/test'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakAndQuote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Streak card
          Obx(() => Expanded(
                flex: 1,
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  gradientColors: [
                    AppColors.accentOrange.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  child: Column(
                    children: [
                      StreakFlame(
                        streakCount: controller.currentUser?.streak ?? 0,
                        size: 0.9,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Day Streak',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(width: 12),
          // Quote card
          Expanded(
            flex: 2,
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.motivationalQuote.length > 80
                          ? '${controller.motivationalQuote.substring(0, 80)}...'
                          : controller.motivationalQuote,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Text(
            'Browse by Subject',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Obx(() {
            final selected = controller.selectedSubject.value;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: AppSubjects.subjects.length,
              itemBuilder: (context, i) {
                final subject = AppSubjects.subjects[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SubjectChip(
                    label: subject['name'] as String,
                    emoji: subject['icon'] as String,
                    color: subject['color'] as Color,
                    isSelected: selected == subject['name'],
                    onTap: () =>
                        controller.selectSubject(subject['name'] as String),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              icon: '📖',
              label: 'Study\nMaterials',
              gradient: [
                AppColors.primary.withOpacity(0.3),
                AppColors.primary.withOpacity(0.1),
              ],
              onTap: () => Get.toNamed(Routes.studyMaterials),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionCard(
              icon: '🏆',
              label: 'Leader\nboard',
              gradient: [
                AppColors.accent.withOpacity(0.3),
                AppColors.accent.withOpacity(0.1),
              ],
              onTap: () => Get.toNamed(Routes.leaderboard),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionCard(
              icon: '📝',
              label: 'Mock\nTests',
              gradient: [
                AppColors.secondary.withOpacity(0.3),
                AppColors.secondary.withOpacity(0.1),
              ],
              onTap: () => Get.find<HomeController>().changeTab(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingVideosTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '▶️ Lokkho Videos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse('https://www.youtube.com/@LokkhoEducation');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF0000).withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.play_circle_filled, color: Color(0xFFFF0000), size: 14),
                  SizedBox(width: 4),
                  Text('View All', style: TextStyle(color: Color(0xFFFF0000), fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(VideoModel video) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 20,
        onTap: () => controller.openVideo(video),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: AppColors.darkCard,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: AppColors.darkCard,
                      child: const Center(
                        child: Icon(Icons.play_circle_outline, color: Colors.white54, size: 48),
                      ),
                    ),
                  ),
                  // Dark gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // YouTube play button
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                          SizedBox(width: 4),
                          Text('Watch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  // YouTube logo badge top-right
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('YouTube', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
            // Info row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _SubjectTag(subject: video.subject),
                      const SizedBox(width: 8),
                      Text(video.userClass, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
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

class _QuickActionCard extends StatelessWidget {
  final String icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectTag extends StatelessWidget {
  final String subject;

  const _SubjectTag({Key? key, required this.subject}) : super(key: key);

  Color get _color {
    switch (subject) {
      case 'Mathematics':
        return AppColors.primary;
      case 'Science':
        return AppColors.secondary;
      case 'English':
        return AppColors.accentGreen;
      case 'Social Science':
        return AppColors.accentOrange;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        subject,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
