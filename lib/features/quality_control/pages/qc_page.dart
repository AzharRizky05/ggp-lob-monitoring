import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../providers/qc_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../models/qc_model.dart';
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

    // Setiap ketikan di kolom cari menyaring ulang daftar.
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });

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

  bool get _hasFilter =>
      _selectedResult != "Semua" || _searchController.text.trim().isNotEmpty;

  List<QcModel> _applyFilter(List<QcModel> items) {
    final query = _searchController.text.trim().toLowerCase();

    return items.where((item) {
      if (_selectedResult != "Semua" &&
          item.result.toLowerCase() != _selectedResult.toLowerCase()) {
        return false;
      }
      if (query.isEmpty) return true;

      return item.batchCode.toLowerCase().contains(query) ||
          item.qcName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final role = auth.userProfile?.roleName.toLowerCase() ?? "";

    final isQc = role.contains("quality") || role.contains("qc");

    return AppLayout(
      title: "Quality Control",
      child: RefreshIndicator(
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
                builder: (context, provider, child) {
                  final filtered = _applyFilter(provider.qualityControls);

                  return QcTable(
                    qualityControls: filtered,
                    loading: provider.loading,
                    isQc: isQc,
                    emptyMessage:
                        _hasFilter && provider.qualityControls.isNotEmpty
                            ? "Tidak ada data QC yang sesuai pencarian."
                            : "Belum ada data Quality Control",
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