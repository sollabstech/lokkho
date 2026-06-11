// lib/app/modules/study_materials/study_materials_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/constants.dart';
import 'study_materials_controller.dart';

class StudyMaterialsView extends GetView<StudyMaterialsController> {
  const StudyMaterialsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.deepGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildFilters(),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📖 Study Materials', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                Text('PDFs & Notes for all classes', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Obx(() => Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  _FilterPill(
                    label: controller.selectedSubject.value.isEmpty ? 'Subject' : controller.selectedSubject.value,
                    isActive: controller.selectedSubject.value.isNotEmpty,
                    onTap: () => _showSubjectSheet(),
                  ),
                  const SizedBox(width: 8),
                  _FilterPill(
                    label: controller.selectedClass.value.isEmpty ? 'Class' : controller.selectedClass.value,
                    isActive: controller.selectedClass.value.isNotEmpty,
                    onTap: () => _showClassSheet(),
                  ),
                  const SizedBox(width: 8),
                  _FilterPill(
                    label: controller.selectedMedium.value.isEmpty ? 'Medium' : controller.selectedMedium.value,
                    isActive: controller.selectedMedium.value.isNotEmpty,
                    onTap: () => _showMediumSheet(),
                  ),
                  if (controller.selectedSubject.value.isNotEmpty ||
                      controller.selectedClass.value.isNotEmpty ||
                      controller.selectedMedium.value.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: controller.clearFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accentRed.withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.clear, color: AppColors.accentRed, size: 13),
                            SizedBox(width: 4),
                            Text('Clear', style: TextStyle(color: AppColors.accentRed, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: List.generate(4, (_) => ShimmerCard(width: double.infinity, height: 200)),
        );
      }
      if (controller.materials.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('📭', style: TextStyle(fontSize: 60)),
              SizedBox(height: 16),
              Text('No materials found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Try changing your filters', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: controller.materials.length,
        itemBuilder: (context, i) => _MaterialCard(
          material: controller.materials[i],
          isDownloading: controller.downloadingIds.contains(controller.materials[i].id),
          onDownload: () => controller.downloadMaterial(controller.materials[i]),
          onBookmark: () => controller.toggleBookmark(controller.materials[i]),
        ),
      );
    });
  }

  void _showSubjectSheet() {
    Get.bottomSheet(_FilterSheet(
      title: 'Select Subject',
      items: AppSubjects.subjects.map((s) => s['name'] as String).toList(),
      selected: controller.selectedSubject.value,
      onSelect: (v) => controller.applyFilter(subject: v == controller.selectedSubject.value ? '' : v),
    ));
  }

  void _showClassSheet() {
    Get.bottomSheet(_FilterSheet(
      title: 'Select Class',
      items: AppSubjects.classes,
      selected: controller.selectedClass.value,
      onSelect: (v) => controller.applyFilter(cls: v == controller.selectedClass.value ? '' : v),
    ));
  }

  void _showMediumSheet() {
    Get.bottomSheet(_FilterSheet(
      title: 'Select Medium',
      items: AppSubjects.mediums,
      selected: controller.selectedMedium.value,
      onSelect: (v) => controller.applyFilter(medium: v == controller.selectedMedium.value ? '' : v),
    ));
  }
}

class _MaterialCard extends StatelessWidget {
  final StudyMaterialModel material;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onBookmark;

  const _MaterialCard({
    Key? key,
    required this.material,
    required this.isDownloading,
    required this.onDownload,
    required this.onBookmark,
  }) : super(key: key);

  Color get _subjectColor {
    switch (material.subject) {
      case 'Bengali': return AppColors.primary;
      case 'English': return AppColors.accentGreen;
      case 'Political Science': return AppColors.secondary;
      case 'History': return AppColors.accentOrange;
      case 'Geography': return const Color(0xFFFFD700);
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      gradientColors: [_subjectColor.withOpacity(0.12), Colors.transparent],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _subjectColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  material.type == 'pdf' ? '📄' : '▶️',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              GestureDetector(
                onTap: onBookmark,
                child: Icon(
                  material.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: material.isBookmarked ? AppColors.accent : AppColors.textMuted,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            material.title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, height: 1.3),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Subject chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _subjectColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              material.subject,
              style: TextStyle(color: _subjectColor, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          // Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(material.downloads / 1000).toStringAsFixed(1)}K',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              Text(
                material.medium,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Download button
          GestureDetector(
            onTap: onDownload,
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                gradient: isDownloading ? null : AppColors.primaryGradient,
                color: isDownloading ? Colors.white12 : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: isDownloading
                  ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Download', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({Key? key, required this.label, required this.isActive, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.primaryGradient : null,
          color: isActive ? null : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.transparent : Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: isActive ? Colors.white : AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selected;
  final Function(String) onSelect;

  const _FilterSheet({Key? key, required this.title, required this.items, required this.selected, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              final isSelected = item == selected;
              return GestureDetector(
                onTap: () { onSelect(item); Get.back(); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? Colors.transparent : Colors.white12),
                  ),
                  child: Text(item, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
