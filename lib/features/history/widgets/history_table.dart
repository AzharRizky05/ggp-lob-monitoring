import 'package:flutter/material.dart';

import '../models/history_model.dart';
import 'history_detail_dialog.dart';
import 'history_status_chip.dart';

class HistoryTable extends StatelessWidget {
  final bool isOperator;

  const HistoryTable({
    super.key,
    this.isOperator = false,
  });

  @override
  Widget build(BuildContext context) {
    final histories = [
      HistoryModel(
        id: "HIS001",
        kodeBatch: "LOB-2026-001",
        operator: "Budi Santoso",
        tanggalProduksi: DateTime.now(),
        tahapanTerakhir: "Pengemasan",
        hasilQc: "Lulus",
        status: "Selesai",
        catatan: "Batch berhasil diproduksi sesuai standar.",
      ),
      HistoryModel(
        id: "HIS002",
        kodeBatch: "LOB-2026-002",
        operator: "Andi Saputra",
        tanggalProduksi: DateTime.now(),
        tahapanTerakhir: "Quality Control",
        hasilQc: "Tidak Lulus",
        status: "Ditolak",
        catatan: "Nilai pH di luar batas spesifikasi.",
      ),
      HistoryModel(
        id: "HIS003",
        kodeBatch: "LOB-2026-003",
        operator: "Rudi Hartono",
        tanggalProduksi: DateTime.now(),
        tahapanTerakhir: "Fermentasi",
        hasilQc: "-",
        status: "Proses",
        catatan: "Fermentasi masih berlangsung.",
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 72,
          dataRowMaxHeight: 72,
          columns: const [
            DataColumn(label: Text("Kode Batch")),
            DataColumn(label: Text("Operator")),
            DataColumn(label: Text("Tahapan Terakhir")),
            DataColumn(label: Text("Hasil QC")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Tanggal Produksi")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: histories.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.kodeBatch)),
                DataCell(Text(item.operator)),
                DataCell(Text(item.tahapanTerakhir)),
                DataCell(Text(item.hasilQc)),
                DataCell(
                  HistoryStatusChip(
                    status: item.status,
                  ),
                ),
                DataCell(
                  Text(
                    "${item.tanggalProduksi.day}/${item.tanggalProduksi.month}/${item.tanggalProduksi.year}",
                  ),
                ),
                DataCell(
                  IconButton(
                    tooltip: "Lihat Detail",
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const HistoryDetailDialog(),
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
  }
}