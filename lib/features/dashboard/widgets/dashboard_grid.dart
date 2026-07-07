import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../models/dashboard_data.dart';
import 'summary_card.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    super.key,
    this.summary,
    this.loading = false,
  });

  final DashboardSummary? summary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    int crossAxisCount;

    if (Responsive.isDesktop(context)) {
      crossAxisCount = 4;
    } else if (Responsive.isTablet(context)) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    final total = summary?.totalBatches ?? 0;
    final active = summary?.activeBatches ?? 0;
    final completed = summary?.completedBatches ?? 0;
    final pending = summary?.pendingApprovals ?? 0;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: Responsive.isDesktop(context) ? 1.45 : 1.25,
      children: [
        SummaryCard(
          title: "Production Batches",
          value: loading ? "--" : total.toString(),
          subtitle: loading
              ? "Loading..."
              : "$total batch production recorded",
          icon: Icons.inventory_2_outlined,
          color: Colors.blue,
        ),

        SummaryCard(
          title: "Active Production",
          value: loading ? "--" : active.toString(),
          subtitle: loading
              ? "Loading..."
              : "$active batch currently running",
          icon: Icons.precision_manufacturing_outlined,
          color: Colors.orange,
        ),

        SummaryCard(
          title: "Completed Batches",
          value: loading ? "--" : completed.toString(),
          subtitle: loading
              ? "Loading..."
              : "$completed batch completed",
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),

        SummaryCard(
          title: "Pending Approval",
          value: loading ? "--" : pending.toString(),
          subtitle: loading
              ? "Loading..."
              : "$pending awaiting supervisor approval",
          icon: Icons.pending_actions_outlined,
          color: Colors.red,
        ),
      ],
    );
  }
}