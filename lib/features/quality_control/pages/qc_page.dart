import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../providers/qc_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/qc_header.dart';
import '../widgets/qc_search.dart';
import '../widgets/qc_table.dart';

class QcPage extends StatefulWidget {
  const QcPage({super.key});

  @override
  State<QcPage> createState() => _QcPageState();
}

class _QcPageState extends State<QcPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedResult = "Semua";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<QcProvider>().loadQualityControls();
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

    final isQc = role.contains("quality") || role.contains("qc");

    return AppLayout(
      title: "Quality Control",
      child: RefreshIndicator(
        // Perbaikan: Mengembalikan Future langsung agar tidak ada akses context setelah await
        onRefresh: () {
          context.read<BatchProvider>().loadBatches();
          return context.read<QcProvider>().refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              QcHeader(
                isQc: isQc,
              ),

              const SizedBox(height: 24),

              /// SEARCH
              QcSearch(
                controller: _searchController,
                selectedResult: _selectedResult,
                onResultChanged: (value) {
                  setState(() {
                    _selectedResult = value ?? "Semua";
                  });
                },
              ),

              const SizedBox(height: 24),

              /// TABLE
              Consumer<QcProvider>(
                builder: (
                  context,
                  provider,
                  child,
                ) {
                  return QcTable(
                    qualityControls: provider.qualityControls,
                    loading: provider.loading,
                    isQc: isQc,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}