import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../providers/monitoring_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/monitoring_header.dart';
import '../widgets/monitoring_search.dart';
import '../widgets/monitoring_table.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = "Semua";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final batchProvider = context.read<BatchProvider>();
      final monitoringProvider = context.read<MonitoringProvider>();

      await batchProvider.loadBatches();
      await monitoringProvider.loadMonitoring();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final role = auth.userProfile?.roleName.toLowerCase() ?? "";

    final isOperator = role.contains("operator");
    final isSupervisor = role.contains("supervisor");
    final isQc = role.contains("quality") || role.contains("qc");

    return AppLayout(
      title: "Production Monitoring",
      child: RefreshIndicator(
        onRefresh: () async {
          if (!mounted) return;

          final batchProvider = context.read<BatchProvider>();
          final monitoringProvider = context.read<MonitoringProvider>();

          await batchProvider.loadBatches();
          await monitoringProvider.refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              MonitoringHeader(
                isOperator: isOperator,
              ),

              const SizedBox(height: 24),

              /// SEARCH + FILTER
              MonitoringSearch(
                controller: _searchController,
                selectedStatus: _selectedStatus,
                onStatusChanged: (value) {
                  setState(() {
                    _selectedStatus = value ?? "Semua";
                  });
                },
              ),

              const SizedBox(height: 24),

              /// TABLE
              Consumer<MonitoringProvider>(
                builder: (context, provider, child) {
                  return MonitoringTable(
                    monitoring: provider.monitoring,
                    loading: provider.loading,
                    isOperator: isOperator,
                  );
                },
              ),

              const SizedBox(height: 24),

              if (isSupervisor)
                const Text(
                  "Supervisor dapat melakukan monitoring seluruh batch produksi dan memastikan proses berjalan sesuai target.",
                ),

              if (isQc)
                const Text(
                  "Quality Control melakukan verifikasi hasil produksi sebelum batch diteruskan ke Approval.",
                ),
            ],
          ),
        ),
      ),
    );
  }
}