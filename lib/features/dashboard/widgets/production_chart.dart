import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/dashboard_data.dart';

double _maxY(List<MonthlyProductionPoint> points) {
  if (points.isEmpty) return 100;

  final maxValue = points
      .map((point) => point.value)
      .reduce((a, b) => a > b ? a : b);

  if (maxValue <= 0) return 100;
  return maxValue * 1.2;
}

class ProductionChart extends StatelessWidget {
  const ProductionChart({
    super.key,
    this.points = const [],
    this.loading = false,
  });

  final List<MonthlyProductionPoint> points;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final hasVolume = points.any((point) => point.value > 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Produksi Bulanan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Total volume batch selesai (liter) per bulan produksi, 6 bulan terakhir",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: loading
                  ? const Center(child: Text('Memuat data produksi...'))
                  : points.isEmpty
                      ? const Center(child: Text('Belum ada data produksi.'))
                      : LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: _maxY(points),
                            gridData: const FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 56,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < points.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          points[index].label,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                preventCurveOverShooting: true,
                                color: AppColors.primary,
                                barWidth: 4,
                                spots: points.asMap().entries.map((entry) {
                                  return FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.value,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
            ),
            if (!loading && points.isNotEmpty && !hasVolume)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Belum ada batch selesai dengan volume tercatat pada periode ini.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}