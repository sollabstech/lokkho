// lib/app/widgets/animated_bottom_nav.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.darkSurface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, -4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded,          label: 'Home',    isActive: currentIndex == 0, onTap: () => onTap(0)),
                _NavItem(icon: Icons.quiz_rounded,          label: 'Test',    isActive: currentIndex == 1, onTap: () => onTap(1)),
                _NavItem(icon: Icons.menu_book_rounded,     label: 'Courses', isActive: currentIndex == 2, onTap: () => onTap(2), activeColor: AppColors.secondary),
                _NavItem(icon: Icons.monetization_on_rounded, label: 'Coins', isActive: currentIndex == 3, onTap: () => onTap(3), activeColor: AppColors.accent),
                _NavItem(icon: Icons.person_rounded,        label: 'Profile', isActive: currentIndex == 4, onTap: () => onTap(4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
  }) : super(key: key);

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _labelAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _labelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.isActive) _controller.forward();
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? AppColors.primary;
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: widget.isActive
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [activeColor.withOpacity(0.3), activeColor.withOpacity(0.1)]),
                            boxShadow: [BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 10)],
                          )
                        : null,
                    child: Icon(widget.icon, color: widget.isActive ? activeColor : AppColors.textMuted, size: 22),
                  ),
                ),
                SizeTransition(
                  sizeFactor: _labelAnimation,
                  child: Text(
                    widget.label,
                    style: TextStyle(color: activeColor, fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
