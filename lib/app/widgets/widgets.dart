// lib/app/widgets/glass_card.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/helpers.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double blurSigma;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blurSigma = 10,
    this.gradientColors,
    this.onTap,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              padding: padding ?? const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  colors: gradientColors ??
                      [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: boxShadow ??
                    [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// lib/app/widgets/gradient_button.dart

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final List<Color>? gradientColors;
  final Widget? icon;
  final double borderRadius;
  final bool isLoading;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 56,
    this.gradientColors,
    this.icon,
    this.borderRadius = 16,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradientColors ??
                    [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: (widget.gradientColors?.first ?? AppColors.primary)
                      .withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: widget.isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// Coin Badge Widget
class CoinBadge extends StatelessWidget {
  final int coins;
  final bool compact;

  const CoinBadge({Key? key, required this.coins, this.compact = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🪙',
            style: TextStyle(fontSize: compact ? 12 : 16),
          ),
          const SizedBox(width: 4),
          Text(
            coins >= 1000
                ? '${(coins / 1000).toStringAsFixed(1)}K'
                : coins.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// Subject Chip Widget
class SubjectChip extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const SubjectChip({
    Key? key,
    required this.label,
    required this.emoji,
    required this.color,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : color.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Streak Flame Widget
class StreakFlame extends StatefulWidget {
  final int streakCount;
  final double size;

  const StreakFlame({Key? key, required this.streakCount, this.size = 1.0})
      : super(key: key);

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flickerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _flickerAnimation = Tween<double>(begin: 0.85, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _flickerAnimation,
          builder: (context, child) => Transform.scale(
            scale: _flickerAnimation.value * widget.size,
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.fireGradient.createShader(bounds),
              child: Text(
                '🔥',
                style:
                    TextStyle(fontSize: 24 * widget.size),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.streakCount}',
          style: TextStyle(
            color: AppColors.accentOrange,
            fontSize: 18 * widget.size,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// Score Gauge Widget
class ScoreGauge extends StatefulWidget {
  final double score;
  final double maxScore;
  final double size;

  const ScoreGauge({
    Key? key,
    required this.score,
    required this.maxScore,
    this.size = 150,
  }) : super(key: key);

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.score / widget.maxScore)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.score / widget.maxScore * 100;
    final color = AppHelpers.getScoreColor(percentage);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 12,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(percentage * _animation.value).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontSize: widget.size * 0.22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Score',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: widget.size * 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Shimmer Loading Widget
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerCard({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.darkCard,
      ),
    );
  }
}
