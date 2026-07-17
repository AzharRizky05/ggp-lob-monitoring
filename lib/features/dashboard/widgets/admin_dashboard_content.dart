import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dashboard_data.dart';
import 'approval_pending_card.dart';
import 'batch_status_chart.dart';
import 'dashboard_grid.dart';
import 'dashboard_header.dart';
import 'production_chart.dart';
import 'recent_activity.dart';

class AdminDashboardContent extends StatelessWidget {
  final DashboardData? data;
  final bool loading;

  const AdminDashboardContent({
    super.key,
    this.data,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const DashboardHeader(),

          const SizedBox(height: 30),

          /// =========================
          /// RINGKASAN SISTEM
          /// =========================
          DashboardGrid(
            summary: data?.summary,
            loading: loading,
          ),

          const SizedBox(height: 30),

          /// =========================
          /// GRAFIK & AKTIVITAS
          /// =========================
          ProductionChart(
            points: data?.monthlyProduction ?? const [],
            loading: loading,
          ),

          const SizedBox(height: 30),

          BatchStatusChart(
            summary: data?.summary,
            loading: loading,
          ),

          const SizedBox(height: 30),

          ApprovalPendingCard(
            pendingCount: data?.summary.pendingApprovals ?? 0,
            loading: loading,
          ),

          const SizedBox(height: 30),

          RecentActivity(
            items: data?.recentBatches ?? const [],
            loading: loading,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}