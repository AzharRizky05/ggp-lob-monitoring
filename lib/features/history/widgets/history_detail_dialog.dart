import 'package:flutter/material.dart';

class HistoryDetailDialog extends StatelessWidget {
  const HistoryDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Detail Riwayat Pemeliharaan"),
      content: SizedBox(
        width: 550,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.inventory_2_outlined),
              title: Text("Kode Aset"),
              subtitle: Text("AST-001"),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.precision_manufacturing_outlined),
              title: Text("Nama Aset"),
              subtitle: Text("Mesin Produksi A"),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.build_circle_outlined),
              title: Text("Jenis Pemeliharaan"),
              subtitle: Text("Preventive Maintenance"),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person_outline),
              title: Text("Teknisi"),
              subtitle: Text("Budi Santoso"),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today_outlined),
              title: Text("Tanggal"),
              subtitle: Text("18 Mei 2026"),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.assignment_turned_in_outlined),
              title: Text("Hasil"),
              subtitle: Text("Pemeliharaan berhasil diselesaikan."),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.note_alt_outlined),
              title: Text("Catatan"),
              subtitle: Text(
                "Seluruh komponen telah diperiksa, dibersihkan, dan berfungsi dengan baik.",
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          label: const Text("Tutup"),
        ),
      ],
    );
  }
}