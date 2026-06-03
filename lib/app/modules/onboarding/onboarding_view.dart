// lib/app/modules/onboarding/onboarding_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import '../../widgets/widgets.dart';

import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.slides.length,
            itemBuilder: (context, index) {
              final slide = controller.slides[index];
              return _OnboardingSlide(slide: slide, index: index);
            },
          ),
          // Skip button
          Positioned(
            top: 56,
            right: 24,
            child: GestureDetector(
              onTap: controller.skip,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Obx(() => Column(
                  children: [
                    // Page dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.slides.length,
                        (i) => _PageDot(isActive: i == controller.currentPage.value),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // CTA Button
                    GradientButton(
                      text: controller.currentPage.value ==
                              controller.slides.length - 1
                          ? 'Get Started 🚀'
                          : 'Next',
                      onPressed: controller.nextPage,
                      gradientColors: List<Color>.from(
                        controller.slides[controller.currentPage.value]
                            ['gradient'] as List,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatefulWidget {
  final Map<String, dynamic> slide;
  final int index;

  const _OnboardingSlide({Key? key, required this.slide, required this.index})
      : super(key: key);

  @override
  State<_OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<_OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _emojiAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _emojiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = List<Color>.from(widget.slide['gradient'] as List);
    final accentColor = widget.slide['accentColor'] as Color;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBg, colors.first.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Illustration card
              ScaleTransition(
                scale: _emojiAnimation,
                child: GlassCard(
                  height: 280,
                  gradientColors: [
                    colors.first.withOpacity(0.2),
                    colors.last.withOpacity(0.05),
                  ],
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.slide['emoji'] as String,
                          style: const TextStyle(fontSize: 100),
                        ),
                        const SizedBox(height: 16),
                        _AnimatedPulse(color: accentColor),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Text content
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: colors,
                        ).createShader(bounds),
                        child: Text(
                          widget.slide['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.slide['subtitle'] as String,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedPulse extends StatefulWidget {
  final Color color;

  const _AnimatedPulse({Key? key, required this.color}) : super(key: key);

  @override
  State<_AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<_AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        width: 60,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            colors: [
              widget.color.withOpacity(0.3 + 0.7 * _controller.value),
              widget.color,
            ],
          ),
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: isActive ? AppColors.primaryGradient : null,
        color: isActive ? null : Colors.white.withOpacity(0.3),
      ),
    );
  }
}
