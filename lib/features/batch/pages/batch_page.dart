import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../models/batch_model.dart';
import '../widgets/batch_header.dart';
import '../widgets/batch_search.dart';
import '../widgets/batch_table.dart';

class BatchPage extends StatefulWidget {
  const BatchPage({super.key});

  @override
  State<BatchPage> createState() => _BatchPageState();
}

class _BatchPageState extends State<BatchPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = "Semua";

  @override
  void initState() {
    super.initState();

    // Setiap ketikan di kolom cari menyaring ulang daftar.
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BatchProvider>().loadBatches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasFilter =>
      _selectedStatus != "Semua" || _searchController.text.trim().isNotEmpty;

  List<BatchModel> _applyFilter(List<BatchModel> items) {
    final query = _searchController.text.trim().toLowerCase();

    return items.where((batch) {
      if (_selectedStatus != "Semua" && batch.status != _selectedStatus) {
        return false;
      }
      if (query.isEmpty) return true;

      return batch.batchCode.toLowerCase().contains(query) ||
          batch.operatorName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.userProfile?.roleName.toLowerCase() ?? '';
    final isOperator = role.contains('operator');
    final isAdmin = role.contains('admin');
    final operatorId = auth.userProfile?.id;

    return AppLayout(
      title: 'Batch Produksi',
      child: Consumer<BatchProvider>(
        builder: (context, provider, _) {
          // Operator hanya melihat batch miliknya sendiri.
          final ownBatches = isOperator && operatorId != null
              ? provider.batches
                  .where((batch) => batch.operatorId == operatorId)
                  .toList()
              : provider.batches;

          final batches = _applyFilter(ownBatches);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BatchHeader(isOperator: isOperator),
                const SizedBox(height: 24),
                BatchSearch(
                  controller: _searchController,
                  selectedStatus: _selectedStatus,
                  onStatusChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? "Semua";
                    });
                  },
                ),
                const SizedBox(height: 24),
                BatchTable(
                  batches: batches,
                  loading: provider.loading,
                  isOperator: isOperator,
                  canManage: isOperator || isAdmin,
                  emptyMessage: _hasFilter && ownBatches.isNotEmpty
                      ? "Tidak ada batch yang sesuai pencarian."
                      : "No production batch available",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}