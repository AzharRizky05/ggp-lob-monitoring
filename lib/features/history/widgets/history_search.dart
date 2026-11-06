import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';

class HistorySearch extends StatelessWidget {
  const HistorySearch({super.key});

  @override
  Widget build(BuildContext context) {
    final period = context.select<HistoryProvider, String>((p) => p.period);

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
          width: 240,
          child: DropdownButtonFormField<String>(
            initialValue: period,
            decoration: InputDecoration(
              labelText: "Periode Selesai",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
            items: HistoryProvider.periods
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<HistoryProvider>().setPeriod(value);
              }
            },
          ),
        ),
      ],
    );
  }
}