import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final today =
        DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    final authProvider = context.watch<AuthProvider>();

    final user = authProvider.userProfile;

    final fullName = user?.fullName ?? "Guest";

    final role = user?.roleName ?? "-";

    final avatar =
        fullName.isNotEmpty ? fullName[0].toUpperCase() : "?";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 4),
                Text(
                  today,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: "Notifications",
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(
              avatar,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fullName,
                style: AppTextStyles.body,
              ),
              Text(
                role,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}