import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/cards/section_card.dart';
import '../models/profile_view_data.dart';

/// Card horizontal di bagian atas halaman Profile.
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  final ProfileViewData profile;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBuilder.isMobile(context);

    final avatarAndInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary,
          child: Text(
            profile.initial,
            style: AppTextStyles.heading2.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(profile.fullName, style: AppTextStyles.title),
              const SizedBox(height: 2),
              Text(profile.email, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  _RoleBadge(label: profile.role),
                  _StatusBadge(label: profile.statusLabel, active: profile.isActive),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final editButton = OutlineButton(
      text: 'Edit Profil',
      icon: Icons.edit_outlined,
      onPressed: onEditProfile,
    );

    return SectionCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatarAndInfo,
                const SizedBox(height: AppSpacing.lg),
                SizedBox(width: double.infinity, child: editButton),
              ],
            )
          : Row(
              children: [
                Expanded(child: avatarAndInfo),
                editButton,
              ],
            ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.admin_panel_settings, size: 16, color: AppColors.info),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}