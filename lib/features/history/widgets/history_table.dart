import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import 'history_detail_dialog.dart';
import 'history_status_chip.dart';

class HistoryTable extends StatelessWidget {
  const HistoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const _StateCard(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return _StateCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Gagal memuat riwayat produksi."),
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

        final histories = provider.histories;

        if (histories.isEmpty) {
          return const _StateCard(
            child: Text("Belum ada riwayat produksi yang selesai."),
          );
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 56,
              dataRowMinHeight: 64,
              dataRowMaxHeight: 72,
              columns: const [
                DataColumn(label: Text("Kode Batch")),
                DataColumn(label: Text("Operator")),
                DataColumn(label: Text("Tgl Produksi")),
                DataColumn(label: Text("Volume Akhir")),
                DataColumn(label: Text("Hasil QC")),
                DataColumn(label: Text("Disetujui Oleh")),
                DataColumn(label: Text("Tgl Selesai")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: histories.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.batchCode,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataCell(Text(item.operatorName)),
                    DataCell(Text(item.productionDateLabel)),
                    DataCell(Text(item.finalVolumeLabel)),
                    DataCell(HistoryStatusChip(status: item.qcResult)),
                    DataCell(Text(item.approvedByName)),
                    DataCell(Text(item.completedAtLabel)),
                    DataCell(
                      IconButton(
                        tooltip: "Lihat Detail",
                        icon: const Icon(Icons.visibility_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => HistoryDetailDialog(history: item),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _StateCard extends StatelessWidget {
  final Widget child;

  const _StateCard({required this.child});

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