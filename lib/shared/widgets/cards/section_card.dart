import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card dengan background hijau muda (tint dari AppColors.primary),
/// dipakai di modul Profile agar visualnya konsisten dengan style
/// yang dipakai pada modul Settings (background tint, rounded, tanpa border).
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: child,
    );
  }
}