import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';

class ReportSummaryCards extends StatelessWidget {
  const ReportSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    final summary = provider.summary;
    final loading = provider.loading;

    String text(String value) => loading ? "--" : value;

    final passRate = summary.qcPassRate;

    final items = [
      _CardData(
        title: "Total Batch",
        value: text(summary.total.toString()),
        icon: Icons.inventory_2_outlined,
        color: Colors.blue,
      ),
      _CardData(
        title: "Batch Selesai",
        value: text(summary.completed.toString()),
        icon: Icons.check_circle_outline,
        color: Colors.green,
      ),
      _CardData(
        title: "Batch Ditolak",
        value: text(summary.rejected.toString()),
        icon: Icons.cancel_outlined,
        color: Colors.red,
      ),
      _CardData(
        title: "QC Pass Rate",
        value: text(
          passRate == null ? "-" : "${(passRate * 100).toStringAsFixed(0)}%",
        ),
        icon: Icons.verified_outlined,
        color: Colors.orange,
      ),
      _CardData(
        title: "Volume Selesai",
        value: text(formatVolumeLiter(summary.totalVolume)),
        icon: Icons.water_drop_outlined,
        color: Colors.purple,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100
            ? 5
            : width >= 800
                ? 3
                : width >= 520
                    ? 2
                    : 1;
        const spacing = 20.0;
        final cardWidth = ((width - spacing * (columns - 1)) / columns).floorToDouble();

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map(
                (item) => SizedBox(
                  width: cardWidth,
                  child: _SummaryCard(data: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _CardData {
  const _CardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _CardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: data.color.withValues(alpha: 0.12),
              child: Icon(data.icon, color: data.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}