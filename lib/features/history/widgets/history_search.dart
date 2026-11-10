import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';

class HistorySearch extends StatelessWidget {
  const HistorySearch({super.key});

  String _format(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickRange(BuildContext context, HistoryProvider provider) async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: provider.range,
      helpText: 'Pilih rentang tanggal selesai',
      saveText: 'Terapkan',
    );

    if (picked != null) provider.setRange(picked);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final range = provider.range;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: context.read<HistoryProvider>().setSearchQuery,
            decoration: InputDecoration(
              hintText: "Cari kode batch, operator, atau supervisor...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 300,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _pickRange(context, provider),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Tanggal Selesai",
                prefixIcon: const Icon(Icons.date_range_outlined),
                suffixIcon: range == null
                    ? null
                    : IconButton(
                        tooltip: "Hapus filter tanggal",
                        icon: const Icon(Icons.close),
                        onPressed: provider.clearRange,
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                isDense: true,
              ),
              child: Text(
                range == null
                    ? "Semua tanggal"
                    : "${_format(range.start)} – ${_format(range.end)}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}