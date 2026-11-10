import 'package:flutter/material.dart';

import '../../batch/widgets/batch_status_chip.dart';
import '../../history/widgets/history_status_chip.dart';
import '../models/qc_model.dart';

class QcDetailDialog extends StatelessWidget {
  const QcDetailDialog({super.key, required this.qc});

  final QcModel qc;

  String _text(String value) => value.trim().isEmpty ? "-" : value;

  String _formatDateTime(DateTime date) {
    final local = date.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _chipTile(IconData icon, String title, Widget chip) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: chip,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Detail Quality Control"),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tile(Icons.qr_code, "Kode Batch", _text(qc.batchCode)),
              _tile(Icons.person_outline, "Petugas QC", _text(qc.qcName)),
              _tile(
                Icons.calendar_today_outlined,
                "Tanggal Pemeriksaan",
                _formatDateTime(qc.inspectionDate),
              ),
              _tile(Icons.science_outlined, "pH", qc.ph.toStringAsFixed(1)),
              _tile(
                Icons.opacity_outlined,
                "Density",
                qc.density.toStringAsFixed(2),
              ),
              _tile(Icons.palette_outlined, "Color", _text(qc.color)),
              _tile(Icons.air_outlined, "Odor", _text(qc.odor)),
              _tile(
                Icons.grass_outlined,
                "Nutrient Content",
                _text(qc.nutrientContent),
              ),
              _tile(
                Icons.biotech_outlined,
                "Laboratory Result",
                _text(qc.laboratoryResult),
              ),
              _tile(Icons.scoreboard_outlined, "QC Score", "${qc.qcScore} / 100"),
              _chipTile(
                Icons.verified_outlined,
                "Hasil QC",
                HistoryStatusChip(status: qc.result),
              ),
              _chipTile(
                Icons.flag_outlined,
                "Status Batch",
                BatchStatusChip(status: qc.status),
              ),
              _tile(Icons.note_alt_outlined, "Catatan", _text(qc.notes)),
            ],
          ),
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