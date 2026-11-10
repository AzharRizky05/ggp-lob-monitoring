import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../providers/report_provider.dart';
import '../widgets/approval_chart.dart';
import '../widgets/report_filter.dart';
import '../widgets/report_header.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportProvider(),
      child: const _ReportView(),
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView();

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: "Laporan",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportHeader(),
            SizedBox(height: 24),
            ReportFilter(),
            SizedBox(height: 24),
            ReportSummaryCards(),
            SizedBox(height: 24),
            ApprovalChart(),
            SizedBox(height: 24),
            ReportTable(),
          ],
        ),
      ),
    );
  }
}