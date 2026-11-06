import 'package:flutter/material.dart';

import '../../approval/widgets/batch_timeline.dart';
import '../models/history_model.dart';

class HistoryDetailDialog extends StatelessWidget {
  final HistoryModel history;

  const HistoryDetailDialog({super.key, required this.history});

  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Detail Riwayat Produksi"),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BatchTimeline(status: 'Completed'),
              const SizedBox(height: 20),
              _tile(Icons.qr_code, "Kode Batch", history.batchCode),
              _tile(Icons.person_outline, "Operator", history.operatorName),
              _tile(
                Icons.calendar_today_outlined,
                "Tanggal Produksi",
                history.productionDateLabel,
              ),
              _tile(
                Icons.precision_manufacturing_outlined,
                "Shift / Tank",
                "${history.shift} • ${history.tank}",
              ),
              _tile(
                Icons.flag_outlined,
                "Target Volume",
                history.targetVolumeLabel,
              ),
              _tile(
                Icons.water_drop_outlined,
                "Volume Akhir",
                history.finalVolumeLabel,
              ),
              _tile(Icons.verified_outlined, "Hasil QC", history.qcResult),
              _tile(
                Icons.supervisor_account_outlined,
                "Disetujui Oleh",
                history.approvedByName,
              ),
              _tile(
                Icons.event_available_outlined,
                "Waktu Selesai",
                history.completedAtLabel,
              ),
              _tile(
                Icons.note_alt_outlined,
                "Catatan Supervisor",
                history.remarks.isEmpty ? "-" : history.remarks,
              ),
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