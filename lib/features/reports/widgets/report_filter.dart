import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/report_model.dart';
import '../providers/report_provider.dart';

class ReportFilter extends StatelessWidget {
  const ReportFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<int>(
            initialValue: provider.year,
            decoration: const InputDecoration(
              labelText: "Tahun",
              border: OutlineInputBorder(),
            ),
            items: provider.years
                .map(
                  (year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) provider.setYear(value);
            },
          ),
        ),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<int>(
            initialValue: provider.month,
            decoration: const InputDecoration(
              labelText: "Bulan",
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int>(
                value: 0,
                child: Text("Semua Bulan"),
              ),
              for (int i = 0; i < 12; i++)
                DropdownMenuItem<int>(
                  value: i + 1,
                  child: Text(reportMonthNames[i]),
                ),
            ],
            onChanged: (value) {
              if (value != null) provider.setMonth(value);
            },
          ),
        ),
        SizedBox(
          width: 240,
          child: DropdownButtonFormField<String>(
            initialValue: provider.statusLabel,
            decoration: const InputDecoration(
              labelText: "Status Batch",
              border: OutlineInputBorder(),
            ),
            items: ReportStatusOption.options
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option.label,
                    child: Text(option.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) provider.setStatusLabel(value);
            },
          ),
        ),
      ],
    );
  }
}