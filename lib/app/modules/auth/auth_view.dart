// lib/app/modules/auth/auth_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A1A), Color(0xFF1A0A3A), Color(0xFF0A0A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Floating orbs
            ..._buildOrbs(),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo section
                  _buildLogo(),
                  const Spacer(flex: 3),
                  // Login card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildLoginCard(context),
                  ),
                  const Spacer(flex: 1),
                  // Terms
                  _buildTermsText(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrbs() {
    return [
      Positioned(
        top: 100,
        left: -60,
        child: _FloatingOrb(
          color: AppColors.primary.withOpacity(0.25),
          size: 200,
          delay: Duration.zero,
        ),
      ),
      Positioned(
        top: 300,
        right: -40,
        child: _FloatingOrb(
          color: AppColors.secondary.withOpacity(0.2),
          size: 160,
          delay: const Duration(seconds: 1),
        ),
      ),
      Positioned(
        bottom: 200,
        left: 40,
        child: _FloatingOrb(
          color: AppColors.accent.withOpacity(0.1),
          size: 120,
          delay: const Duration(milliseconds: 500),
        ),
      ),
    ];
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'ল',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: const Text(
            'LOKKHO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Focus. Target. Achieve.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 28,
      gradientColors: [
        Colors.white.withOpacity(0.08),
        Colors.white.withOpacity(0.03),
      ],
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.15),
          blurRadius: 40,
          spreadRadius: 2,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back! 👋',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to continue your learning journey',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 32),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: '50K+', label: 'Students'),
              Container(width: 1, height: 40, color: Colors.white12),
              _StatItem(value: '10K+', label: 'Tests'),
              Container(width: 1, height: 40, color: Colors.white12),
              _StatItem(value: '500+', label: 'Videos'),
            ],
          ),
          const SizedBox(height: 32),
          // Google Sign In Button
          Obx(() => _GoogleSignInButton(
                isLoading: controller.isLoading.value,
                onPressed: controller.signInWithGoogle,
              )),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'By signing in, you agree to our Terms of Service and Privacy Policy',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FloatingOrb extends StatefulWidget {
  final Color color;
  final double size;
  final Duration delay;

  const _FloatingOrb({
    Key? key,
    required this.color,
    required this.size,
    required this.delay,
  }) : super(key: key);

  @override
  State<_FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<_FloatingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _animation.value),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({Key? key, required this.value, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _GoogleSignInButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) => GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(_glowAnimation.value * 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google G logo colors
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'G',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4285F4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
