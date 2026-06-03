// lib/app/modules/class_select/class_select_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'class_select_controller.dart';

class ClassSelectView extends GetView<ClassSelectController> {
  const ClassSelectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Header
              const Text('👋 Welcome Back!', style: TextStyle(color: Color(0xFFB0B0C8), fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                'Select Your\nClass',
                style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, height: 1.1),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose your class to get personalised\ncontent, tests and study materials.',
                style: TextStyle(color: Color(0xFF8080A0), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 48),
              // Class cards
              ...controller.classes.map((cls) => _ClassCard(
                    cls: cls,
                    onTap: () => controller.selectClass(cls['class'] as String),
                  )),
              const Spacer(),
              // Footer
              Center(
                child: Text(
                  'Lokkho Education',
                  style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final Map<String, dynamic> cls;
  final VoidCallback onTap;

  const _ClassCard({required this.cls, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(cls['color'] as int);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.35), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(cls['emoji'] as String, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cls['class'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  cls['label'] as String,
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
