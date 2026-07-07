import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import 'approval_pending_card.dart';
import 'recent_activity.dart';

class DashboardBottomSection extends StatelessWidget {
  const DashboardBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const Column(
        children: [
          RecentActivity(),
          SizedBox(height: 20),
          ApprovalPendingCard(),
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: RecentActivity(),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: ApprovalPendingCard(),
        ),
      ],
    );
  }
}