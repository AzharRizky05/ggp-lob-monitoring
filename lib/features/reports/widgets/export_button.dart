import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/report_provider.dart';
import '../services/report_service.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  void _export(BuildContext context) {
    final provider = context.read<ReportProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final rows = provider.rows;

    if (rows.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak ada data untuk diexport.')),
      );
      return;
    }

    ReportService.downloadCsv(
      fileName: provider.exportFileName,
      content: ReportService.buildCsv(rows),
    );

    messenger.showSnackBar(
      SnackBar(content: Text('Laporan berhasil diexport (${rows.length} batch).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.select<ReportProvider, bool>((p) => p.loading);

    return FilledButton.icon(
      onPressed: loading ? null : () => _export(context),
      icon: const Icon(Icons.download_outlined),
      label: const Text('Export Excel (CSV)'),
    );
  }
}