import 'package:flutter/material.dart';

import '../models/batch_model.dart';
import 'batch_status_chip.dart';

class BatchDetailDialog extends StatelessWidget {
  const BatchDetailDialog({super.key, required this.batch});

  final BatchModel batch;

  String _two(int value) => value.toString().padLeft(2, '0');

  String _formatDate(DateTime date) =>
      '${_two(date.day)}/${_two(date.month)}/${date.year}';

  String _formatDateTime(DateTime date) {
    final local = date.toLocal();
    return '${_formatDate(local)} ${_two(local.hour)}:${_two(local.minute)}';
  }

  String _liters(double value) {
    final text = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$text L';
  }

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
    final target = batch.targetVolume;
    final progress = target > 0 ? (batch.actualVolume / target).clamp(0.0, 1.0) : 0.0;
    final notes = batch.notes.trim();

    return AlertDialog(
      title: const Text("Detail Batch Produksi"),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tile(Icons.qr_code, "Kode Batch", batch.batchCode),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: const Text("Status"),
                subtitle: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: BatchStatusChip(status: batch.status),
                  ),
                ),
              ),
              _tile(
                Icons.calendar_today_outlined,
                "Tanggal Produksi",
                _formatDate(batch.productionDate),
              ),
              _tile(
                Icons.precision_manufacturing_outlined,
                "Shift / Tangki",
                "${batch.shift} • ${batch.tank}",
              ),
              _tile(
                Icons.person_outline,
                "Operator",
                batch.operatorName.isEmpty ? "-" : batch.operatorName,
              ),
              _tile(Icons.flag_circle_outlined, "Target Volume", _liters(target)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.water_drop_outlined),
                title: const Text("Volume Saat Ini"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_liters(batch.actualVolume)} dari ${_liters(target)} "
                      "(${(progress * 100).toStringAsFixed(0)}%)",
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              _tile(
                Icons.note_alt_outlined,
                "Catatan",
                notes.isEmpty ? "-" : notes,
              ),
              _tile(
                Icons.add_circle_outline,
                "Dibuat",
                _formatDateTime(batch.createdAt),
              ),
              _tile(
                Icons.update,
                "Terakhir Diperbarui",
                _formatDateTime(batch.updatedAt),
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