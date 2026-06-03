// lib/app/modules/earn_coins/earn_coins_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'earn_coins_controller.dart';

class EarnCoinsView extends GetView<EarnCoinsController> {
  const EarnCoinsView({Key? key}) : super(key: key);

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
            SliverToBoxAdapter(child: _buildWalletCard()),
            SliverToBoxAdapter(child: _buildEarnMethods()),
            SliverToBoxAdapter(child: _buildCoinPackages()),
            SliverToBoxAdapter(child: _buildHistory()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🪙 Coins', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
          Text('Earn coins, unlock rewards', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Balance', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
              ],
            ),
            const Spacer(),
            Obx(() => Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.totalCoins}',
                      style: const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnMethods() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ways to Earn', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              Obx(() => _EarnCard(
                icon: '📺',
                title: 'Watch Ad',
                coins: '+10',
                color: AppColors.primary,
                subtitle: controller.isAdLoading.value
                    ? 'Loading ad...'
                    : controller.isWatchingAd.value
                        ? 'Showing...'
                        : 'Tap to watch',
                onTap: controller.watchAd,
                isLoading: controller.isWatchingAd,
              )),
              _EarnCard(
                icon: '🌅',
                title: 'Daily Login',
                coins: '+5',
                color: AppColors.accentGreen,
                subtitle: 'Once per day',
                onTap: controller.claimDailyLogin,
              ),
              _EarnCard(
                icon: '▶️',
                title: 'Watch Video',
                coins: '+2',
                color: AppColors.secondary,
                subtitle: 'Per video',
                onTap: () {},
              ),
              _EarnCard(
                icon: '👥',
                title: 'Refer Friend',
                coins: '+50',
                color: AppColors.accentOrange,
                subtitle: 'Per referral',
                onTap: controller.referFriend,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Buy Coins', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Instantly top up your wallet', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _CoinPackage(coins: 100, price: '₹29', isPopular: false, onTap: () => controller.buyCoins(100, 29))),
              const SizedBox(width: 10),
              Expanded(child: _CoinPackage(coins: 500, price: '₹99', isPopular: true, onTap: () => controller.buyCoins(500, 99))),
              const SizedBox(width: 10),
              Expanded(child: _CoinPackage(coins: 1000, price: '₹179', isPopular: false, onTap: () => controller.buyCoins(1000, 179))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Activity', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingHistory.value) {
              return Column(
                children: List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ShimmerCard(width: double.infinity, height: 64),
                )),
              );
            }
            if (controller.coinHistory.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No activity yet.\nStart earning coins!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                ),
              );
            }
            return Column(
              children: controller.coinHistory.take(10).map((h) => _HistoryItem(history: h)).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _EarnCard extends StatelessWidget {
  final String icon;
  final String title;
  final String coins;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;
  final RxBool? isLoading;

  const _EarnCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.coins,
    required this.color,
    required this.subtitle,
    required this.onTap,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(coins, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinPackage extends StatelessWidget {
  final int coins;
  final String price;
  final bool isPopular;
  final VoidCallback onTap;

  const _CoinPackage({Key? key, required this.coins, required this.price, required this.isPopular, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isPopular ? AppColors.goldGradient : null,
          color: isPopular ? null : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isPopular ? Colors.transparent : Colors.white12),
          boxShadow: isPopular ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 16)] : [],
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                child: const Text('BEST', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            Text(
              '🪙',
              style: TextStyle(fontSize: isPopular ? 28 : 24),
            ),
            const SizedBox(height: 4),
            Text(
              '$coins',
              style: TextStyle(
                color: isPopular ? Colors.black : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                color: isPopular ? Colors.black54 : AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final history;

  const _HistoryItem({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = history.amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isPositive ? AppColors.accentGreen : AppColors.accentRed).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? Icons.add : Icons.remove,
              color: isPositive ? AppColors.accentGreen : AppColors.accentRed,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              history.description,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${history.amount}',
            style: TextStyle(
              color: isPositive ? AppColors.accentGreen : AppColors.accentRed,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
