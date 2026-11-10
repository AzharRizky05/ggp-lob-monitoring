import 'package:flutter/material.dart';

import '../../batch/widgets/batch_status_chip.dart';
import '../models/monitoring_model.dart';

class MonitoringDetailDialog extends StatelessWidget {
  const MonitoringDetailDialog({super.key, required this.monitoring});

  final MonitoringModel monitoring;

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

  String _formatTime(DateTime date) {
    final local = date.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final m = monitoring;

    return AlertDialog(
      title: const Text("Detail Monitoring Produksi"),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tile(Icons.qr_code, "Kode Batch", m.batchCode),
              _tile(
                Icons.person_outline,
                "Operator",
                m.operatorName.isEmpty ? "-" : m.operatorName,
              ),
              _chipTile(
                Icons.layers_outlined,
                "Tahap Produksi (saat dicatat)",
                m.stage.isEmpty
                    ? const Text("-")
                    : BatchStatusChip(status: m.stage),
              ),
              _chipTile(
                Icons.flag_outlined,
                "Status Batch Saat Ini",
                BatchStatusChip(status: m.status),
              ),
              _tile(
                Icons.schedule_outlined,
                "Waktu Pencatatan",
                _formatTime(m.recordedAt),
              ),
              _tile(
                Icons.thermostat_outlined,
                "Temperature",
                "${m.temperature.toStringAsFixed(1)} °C",
              ),
              _tile(Icons.science_outlined, "pH", m.ph.toStringAsFixed(1)),
              _tile(Icons.opacity_outlined, "Brix", m.brix.toStringAsFixed(1)),
              _tile(
                Icons.water_drop_outlined,
                "Volume",
                "${m.volume.toStringAsFixed(0)} Liter",
              ),
              _tile(
                Icons.timer_outlined,
                "Mixing Time",
                "${m.mixingTime} Menit",
              ),
              _tile(
                Icons.hourglass_bottom,
                "Fermentation Time",
                "${m.fermentationTime} Jam",
              ),
              _tile(
                Icons.speed_outlined,
                "Flow Rate",
                m.flowRate.toStringAsFixed(1),
              ),
              _tile(
                Icons.note_alt_outlined,
                "Remarks",
                m.remarks.trim().isEmpty ? "-" : m.remarks,
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