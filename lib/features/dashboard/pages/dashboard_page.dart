import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';

import '../widgets/approval_pending_card.dart';
import '../widgets/batch_status_chart.dart';
import '../widgets/dashboard_grid.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/operator_dashboard_content.dart';
import '../widgets/production_chart.dart';
import '../widgets/recent_activity.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final role =
        auth.userProfile?.roleName.toLowerCase() ?? "";

    return AppLayout(
      title: "Dashboard",
      child: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          final data = provider.data;

          /// ======================================================
          /// OPERATOR
          /// ======================================================
          if (role.contains("operator")) {
            return OperatorDashboardContent(
              data: data,
              loading: provider.loading,
            );
          }

          /// ======================================================
          /// QUALITY CONTROL
          /// ======================================================
          if (role.contains("quality") || role.contains("qc")) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),

                  const SizedBox(height: 30),

                  DashboardGrid(
                    summary: data?.summary,
                    loading: provider.loading,
                  ),

                  const SizedBox(height: 30),

                  RecentActivity(
                    items: data?.recentBatches ?? const [],
                    loading: provider.loading,
                  ),
                ],
              ),
            );
          }

          /// ======================================================
          /// SUPERVISOR
          /// ======================================================
          if (role.contains("supervisor")) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),

                  const SizedBox(height: 30),

                  DashboardGrid(
                    summary: data?.summary,
                    loading: provider.loading,
                  ),

                  const SizedBox(height: 30),

                  ProductionChart(
                    points:
                        data?.monthlyProduction ?? const [],
                    loading: provider.loading,
                  ),

                  const SizedBox(height: 30),

                  ApprovalPendingCard(
                    pendingCount:
                        data?.summary.pendingApprovals ?? 0,
                    loading: provider.loading,
                  ),

                  const SizedBox(height: 30),

                  RecentActivity(
                    items:
                        data?.recentBatches ?? const [],
                    loading: provider.loading,
                  ),
                ],
              ),
            );
          }

          /// ======================================================
          /// ADMINISTRATOR
          /// ======================================================
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHeader(),

                const SizedBox(height: 30),

                DashboardGrid(
                  summary: data?.summary,
                  loading: provider.loading,
                ),

                const SizedBox(height: 30),

                ProductionChart(
                  points:
                      data?.monthlyProduction ?? const [],
                  loading: provider.loading,
                ),

                const SizedBox(height: 30),

                BatchStatusChart(
                  summary: data?.summary,
                  loading: provider.loading,
                ),

                const SizedBox(height: 30),

                ApprovalPendingCard(
                  pendingCount:
                      data?.summary.pendingApprovals ?? 0,
                  loading: provider.loading,
                ),

                const SizedBox(height: 30),

                RecentActivity(
                  items:
                      data?.recentBatches ?? const [],
                  loading: provider.loading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}