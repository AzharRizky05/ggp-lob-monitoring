import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../models/dashboard_data.dart';
import '../widgets/admin_dashboard_content.dart';
import '../widgets/approval_pending_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/operator_dashboard_content.dart';
import '../widgets/production_chart.dart';
import '../widgets/recent_activity.dart';
import '../widgets/role_summary_grid.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;

    final profile = context.read<AuthProvider>().userProfile;
    final role = profile?.roleName.toLowerCase() ?? "";

    context.read<DashboardProvider>().loadDashboardData(
          operatorId: role.contains("operator") ? profile?.id : null,
        );
  }

  List<DashboardCardItem> _qcItems(DashboardSummary? s) => [
        DashboardCardItem(
          title: "Menunggu QC",
          value: s?.waitingQc ?? 0,
          subtitle: "batch menunggu pemeriksaan",
          icon: Icons.hourglass_top,
          color: Colors.orange,
        ),
        DashboardCardItem(
          title: "QC Passed",
          value: s?.qcPassed ?? 0,
          subtitle: "batch lolos pemeriksaan",
          icon: Icons.verified_outlined,
          color: Colors.green,
        ),
        DashboardCardItem(
          title: "QC Failed",
          value: s?.qcFailed ?? 0,
          subtitle: "batch tidak lolos pemeriksaan",
          icon: Icons.cancel_outlined,
          color: Colors.red,
        ),
        DashboardCardItem(
          title: "Total Batch",
          value: s?.totalBatches ?? 0,
          subtitle: "seluruh batch produksi",
          icon: Icons.inventory_2_outlined,
          color: Colors.blue,
        ),
      ];

  List<DashboardCardItem> _supervisorItems(DashboardSummary? s) => [
        DashboardCardItem(
          title: "Pending Approval",
          value: s?.pendingApprovals ?? 0,
          subtitle: "batch menunggu keputusan",
          icon: Icons.pending_actions_outlined,
          color: Colors.orange,
        ),
        DashboardCardItem(
          title: "Disetujui",
          value: s?.completedBatches ?? 0,
          subtitle: "batch disetujui dan selesai",
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        DashboardCardItem(
          title: "Ditolak",
          value: s?.rejectedBatches ?? 0,
          subtitle: "batch ditolak",
          icon: Icons.cancel_outlined,
          color: Colors.red,
        ),
        DashboardCardItem(
          title: "Total Batch",
          value: s?.totalBatches ?? 0,
          subtitle: "seluruh batch produksi",
          icon: Icons.inventory_2_outlined,
          color: Colors.blue,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.userProfile?.roleName.toLowerCase() ?? "";

    return AppLayout(
      title: "Dashboard",
      child: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          final data = provider.data;

          if (provider.errorMessage != null &&
              data == null &&
              !provider.loading) {
            return _DashboardError(
              message: provider.errorMessage!,
              onRetry: _load,
            );
          }

          /// OPERATOR
          if (role.contains("operator")) {
            return OperatorDashboardContent(
              data: data,
              loading: provider.loading,
            );
          }

          /// QUALITY CONTROL
          if (role.contains("quality") || role.contains("qc")) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 30),
                  RoleSummaryGrid(
                    items: _qcItems(data?.summary),
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

          /// SUPERVISOR
          if (role.contains("supervisor")) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 30),
                  RoleSummaryGrid(
                    items: _supervisorItems(data?.summary),
                    loading: provider.loading,
                  ),
                  const SizedBox(height: 30),
                  ProductionChart(
                    points: data?.monthlyProduction ?? const [],
                    loading: provider.loading,
                  ),
                  const SizedBox(height: 30),
                  ApprovalPendingCard(
                    pendingCount: data?.summary.pendingApprovals ?? 0,
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

          /// ADMINISTRATOR (default)
          return AdminDashboardContent(
            data: data,
            loading: provider.loading,
          );
        },
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text("Gagal memuat data dashboard."),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }
}