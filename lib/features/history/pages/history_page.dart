import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../providers/history_provider.dart';
import '../widgets/history_header.dart';
import '../widgets/history_search.dart';
import '../widgets/history_table.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryProvider(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Production History",
      child: RefreshIndicator(
        onRefresh: () => context.read<HistoryProvider>().loadData(),
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HistoryHeader(),
              SizedBox(height: 24),
              HistorySearch(),
              SizedBox(height: 24),
              HistoryTable(),
            ],
          ),
        ),
      ),
    );
  }
}