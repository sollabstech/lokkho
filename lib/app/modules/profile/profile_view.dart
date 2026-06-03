// lib/app/modules/profile/profile_view.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.deepGradient),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHero()),
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverToBoxAdapter(child: _buildAchievements()),
            SliverToBoxAdapter(child: _buildSocialMedia()),
            SliverToBoxAdapter(child: _buildMenuSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    final user = controller.currentUser;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        gradientColors: [AppColors.primary.withOpacity(0.2), Colors.transparent],
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20)],
                  ),
                  child: ClipOval(
                    child: user?.photoUrl != null && user!.photoUrl.isNotEmpty
                        ? CachedNetworkImage(imageUrl: user.photoUrl, fit: BoxFit.cover)
                        : const Center(child: Text('👤', style: TextStyle(fontSize: 40))),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkBg, width: 2),
                  ),
                  child: Text(
                    'L${user?.level ?? 1}',
                    style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              user?.name ?? 'Student',
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(user?.email ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            // XP Progress
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Level ${user?.level ?? 1}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text('${user?.xp ?? 0} / ${controller.xpToNextLevel} XP',
                        style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: controller.xpProgress,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final user = controller.currentUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _StatBubble(value: '${user?.coins ?? 0}', label: 'Coins', icon: '🪙')),
          const SizedBox(width: 10),
          Expanded(child: _StatBubble(value: '#${user?.rank == 0 ? '--' : user?.rank}', label: 'Rank', icon: '🏆')),
          const SizedBox(width: 10),
          Expanded(child: _StatBubble(value: '${user?.streak ?? 0}', label: 'Streak', icon: '🔥')),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Achievements', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.achievements.length,
              itemBuilder: (context, i) {
                final a = controller.achievements[i];
                final unlocked = a['unlocked'] as bool;
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: unlocked ? AppColors.primary.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: unlocked ? AppColors.primary.withOpacity(0.4) : Colors.white12,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        a['icon'] as String,
                        style: TextStyle(fontSize: 28, color: unlocked ? null : const Color(0x66FFFFFF)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a['title'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: unlocked ? Colors.white : AppColors.textMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMedia() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Follow Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    emoji: '▶️',
                    label: 'YouTube',
                    color: const Color(0xFFFF0000),
                    onTap: controller.openYoutube,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SocialButton(
                    emoji: '💬',
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: controller.openWhatsappChannel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SocialButton(
                    emoji: '📸',
                    label: 'Instagram',
                    color: const Color(0xFFE1306C),
                    onTap: controller.openInstagram,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _MenuItem(icon: Icons.edit_outlined, label: 'Edit Profile', onTap: () {}),
            _Divider(),
            _MenuItem(icon: Icons.school_rounded, label: 'Change Class', onTap: controller.changeClass, color: AppColors.secondary),
            _Divider(),
            _MenuItem(icon: Icons.bookmark_outline, label: 'Saved Materials', onTap: () {}),
            _Divider(),
            _MenuItem(icon: Icons.favorite_outline, label: 'Favourite Subjects', onTap: () {}),
            _Divider(),
            _MenuItem(icon: Icons.bar_chart_rounded, label: 'Exam Statistics', onTap: () {}),
            _Divider(),
            Obx(() => _MenuItem(
                  icon: controller.isDarkMode.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  label: controller.isDarkMode.value ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  onTap: controller.toggleTheme,
                  trailing: Switch(
                    value: controller.isDarkMode.value,
                    onChanged: (_) => controller.toggleTheme(),
                    activeColor: AppColors.primary,
                  ),
                )),
            _Divider(),
            _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
            _Divider(),
            _MenuItem(icon: Icons.support_agent_outlined, label: 'Customer Support', onTap: controller.customerSupport),
            _Divider(),
            _MenuItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              onTap: controller.logout,
              color: AppColors.accentRed,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBubble extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatBubble({Key? key, required this.value, required this.label, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Widget? trailing;

  const _MenuItem({Key? key, required this.icon, required this.label, required this.onTap, this.color, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.white.withOpacity(0.06), indent: 20, endIndent: 20);
  }
}

class _SocialButton extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
