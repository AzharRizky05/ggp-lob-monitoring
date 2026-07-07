import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/dashboard_data.dart';

class BatchStatusChart extends StatelessWidget {
  const BatchStatusChart({
    super.key,
    this.summary,
    this.loading = false,
  });

  final DashboardSummary? summary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status Batch Produksi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 260,
              child: loading || summary == null
                  ? const Center(
                      child: Text('Memuat data status batch...'),
                    )
                  : PieChart(
                      PieChartData(
                        centerSpaceRadius: 55,
                        sectionsSpace: 3,
                        sections: [
                          PieChartSectionData(
                            value: summary!.activeBatches.toDouble(),
                            color: Colors.green,
                            title: "Aktif\n${summary!.activeBatches}",
                            radius: 75,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          PieChartSectionData(
                            value: 0,
                            color: Colors.orange,
                            title: "QC\n0",
                            radius: 75,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          PieChartSectionData(
                            value: summary!.completedBatches.toDouble(),
                            color: Colors.blue,
                            title: "Selesai\n${summary!.completedBatches}",
                            radius: 75,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          PieChartSectionData(
                            value: 0,
                            color: Colors.red,
                            title: "Reject\n0",
                            radius: 75,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: const [
                _LegendItem(
                  color: Colors.green,
                  title: "Batch Aktif",
                ),
                _LegendItem(
                  color: Colors.orange,
                  title: "Menunggu QC",
                ),
                _LegendItem(
                  color: Colors.blue,
                  title: "Selesai",
                ),
                _LegendItem(
                  color: Colors.red,
                  title: "Reject",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String title;

  const _LegendItem({
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}