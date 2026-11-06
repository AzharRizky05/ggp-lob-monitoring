import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_name.dart';
import '../../../core/theme/app_colors.dart';

class ApprovalPendingCard extends StatelessWidget {
  const ApprovalPendingCard({
    super.key,
    this.pendingCount = 0,
    this.loading = false,
  });

  final int pendingCount;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final accent = hasPending ? Colors.orange : Colors.green;

    final String message;
    if (loading) {
      message = "Memuat data approval...";
    } else if (hasPending) {
      message = "$pendingCount batch menunggu keputusan Supervisor.";
    } else {
      message = "Tidak ada batch yang menunggu approval.";
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.approval_rounded,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Text(
                  "Approval Supervisor",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accent.withValues(alpha: 0.15),
                  child: Icon(
                    hasPending
                        ? Icons.pending_actions_outlined
                        : Icons.check_circle_outline,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => context.go(RouteName.approval),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Buka Approval"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}