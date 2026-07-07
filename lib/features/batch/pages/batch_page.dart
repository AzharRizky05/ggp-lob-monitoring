import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/batch_header.dart';
import '../widgets/batch_search.dart';
import '../widgets/batch_table.dart';

class BatchPage extends StatefulWidget {
  const BatchPage({super.key});

  @override
  State<BatchPage> createState() => _BatchPageState();
}

class _BatchPageState extends State<BatchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BatchProvider>().loadBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isOperator = auth.userProfile?.roleName == 'Operator Produksi';
    final operatorId = auth.userProfile?.id;

    return AppLayout(
      title: 'Batch Produksi',
      child: Consumer<BatchProvider>(
        builder: (context, provider, _) {
          // Filter batches for operator - only show their batches
          final batches = isOperator && operatorId != null
              ? provider.batches
                  .where((batch) => batch.operatorId == operatorId)
                  .toList()
              : provider.batches;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BatchHeader(isOperator: isOperator),
                const SizedBox(height: 24),
                const BatchSearch(),
                const SizedBox(height: 24),
                BatchTable(
                  batches: batches,
                  loading: provider.loading,
                  isOperator: isOperator,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}