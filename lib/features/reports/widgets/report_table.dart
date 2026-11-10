import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../batch/widgets/batch_status_chip.dart';
import '../../history/widgets/history_status_chip.dart';
import '../providers/report_provider.dart';

class ReportTable extends StatelessWidget {
  const ReportTable({super.key});

  static const int _maxRows = 50;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const _StateCard(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return _StateCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Gagal memuat laporan."),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: provider.loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        final rows = provider.rows;

        if (rows.isEmpty) {
          return const _StateCard(
            child: Text("Tidak ada batch pada filter yang dipilih."),
          );
        }

        final shown = rows.take(_maxRows).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rincian Batch (${rows.length})",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 56,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 64,
                  columns: const [
                    DataColumn(label: Text("Kode Batch")),
                    DataColumn(label: Text("Operator")),
                    DataColumn(label: Text("Tgl Produksi")),
                    DataColumn(label: Text("Volume")),
                    DataColumn(label: Text("Hasil QC")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Diputuskan Oleh")),
                  ],
                  rows: shown.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            row.batchCode,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(Text(row.operatorName)),
                        DataCell(Text(row.productionDateLabel)),
                        DataCell(Text(row.volumeLabel)),
                        DataCell(
                          row.qcResult == '-'
                              ? const Text('-')
                              : HistoryStatusChip(status: row.qcResult),
                        ),
                        DataCell(BatchStatusChip(status: row.status)),
                        DataCell(Text(row.supervisorName)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            if (rows.length > _maxRows)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Menampilkan $_maxRows dari ${rows.length} batch. Seluruh data tetap ikut saat export.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(child: child),
      ),
    );
  }
}