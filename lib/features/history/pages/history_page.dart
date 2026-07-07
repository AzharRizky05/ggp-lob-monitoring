import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/history_header.dart';
import '../widgets/history_search.dart';
import '../widgets/history_table.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isOperator = auth.userProfile?.roleName == 'Operator Produksi';

    return AppLayout(
      title: "Riwayat Pemeliharaan",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryHeader(isOperator: isOperator),

            const SizedBox(height: 24),

            const HistorySearch(),

            const SizedBox(height: 24),

            HistoryTable(isOperator: isOperator),
          ],
        ),
      ),
    );
  }
}