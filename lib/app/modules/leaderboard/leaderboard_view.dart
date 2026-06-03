// lib/app/modules/leaderboard/leaderboard_view.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.deepGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏆 Leaderboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              Text('Compete & rise to the top', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: controller.tabs.asMap().entries.map((e) {
                final isActive = controller.currentTab.value == e.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.switchTab(e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isActive ? AppColors.primaryGradient : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isActive
                            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12)]
                            : [],
                      ),
                      child: Text(
                        e.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isActive ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      }
      if (controller.leaderboardData.isEmpty) {
        return const Center(child: Text('No data yet', style: TextStyle(color: Colors.white)));
      }
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildPodium()),
          SliverToBoxAdapter(child: _buildSpotlightCards()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: const Text('Rankings', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildRankRow(controller.rest[i], i + 4),
              childCount: controller.rest.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      );
    });
  }

  Widget _buildPodium() {
    final top3 = controller.top3;
    if (top3.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (top3.length > 1) Expanded(child: _PodiumItem(user: top3[1], rank: 2, height: 120)),
          const SizedBox(width: 8),
          Expanded(child: _PodiumItem(user: top3[0], rank: 1, height: 150)),
          const SizedBox(width: 8),
          if (top3.length > 2) Expanded(child: _PodiumItem(user: top3[2], rank: 3, height: 100)),
        ],
      ),
    );
  }

  Widget _buildSpotlightCards() {
    if (controller.leaderboardData.isEmpty) return const SizedBox();
    final top = controller.leaderboardData.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        gradientColors: [AppColors.accent.withOpacity(0.2), Colors.transparent],
        child: Row(
          children: [
            const Text('👑', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("This Month's Topper", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text(top.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Text('${top.score}', style: const TextStyle(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _buildRankRow(LeaderboardModel user, int rank) {
    final isMe = controller.isCurrentUser(user.uid);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withOpacity(0.15) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isMe ? AppColors.primary.withOpacity(0.4) : Colors.white12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#$rank',
              style: TextStyle(
                color: isMe ? AppColors.primary : AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          _buildAvatar(user.photoUrl, 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMe ? '${user.name} (You)' : user.name,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textSecondary,
                fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text('${user.score}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(width: 8),
          const Text('pts', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
      child: ClipOval(
        child: url.isNotEmpty
            ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Center(child: Text('👤')))
            : const Center(child: Text('👤', style: TextStyle(fontSize: 16))),
      ),
    );
  }
}

class _PodiumItem extends StatefulWidget {
  final LeaderboardModel user;
  final int rank;
  final double height;

  const _PodiumItem({Key? key, required this.user, required this.rank, required this.height}) : super(key: key);

  @override
  State<_PodiumItem> createState() => _PodiumItemState();
}

class _PodiumItemState extends State<_PodiumItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    Future.delayed(Duration(milliseconds: 100 * widget.rank), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _crownColor {
    switch (widget.rank) {
      case 1: return AppColors.accent;
      case 2: return const Color(0xFFC0C0C0);
      default: return const Color(0xFFCD7F32);
    }
  }

  LinearGradient get _podiumGradient {
    switch (widget.rank) {
      case 1: return LinearGradient(colors: [AppColors.accent.withOpacity(0.3), AppColors.accent.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 2: return LinearGradient(colors: [const Color(0xFFC0C0C0).withOpacity(0.2), const Color(0xFFC0C0C0).withOpacity(0.05)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      default: return LinearGradient(colors: [const Color(0xFFCD7F32).withOpacity(0.2), const Color(0xFFCD7F32).withOpacity(0.05)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Column(
        children: [
          Text(widget.rank == 1 ? '👑' : widget.rank == 2 ? '🥈' : '🥉',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [_crownColor, _crownColor.withOpacity(0.6)]),
              boxShadow: [BoxShadow(color: _crownColor.withOpacity(0.4), blurRadius: 12)],
            ),
            child: ClipOval(
              child: widget.user.photoUrl.isNotEmpty
                  ? CachedNetworkImage(imageUrl: widget.user.photoUrl, fit: BoxFit.cover)
                  : const Center(child: Text('👤', style: TextStyle(fontSize: 22))),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.user.name.split(' ').first,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${widget.user.score}',
            style: TextStyle(color: _crownColor, fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              gradient: _podiumGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: _crownColor.withOpacity(0.3)),
            ),
          ),
        ],
      ),
    );
  }
}
