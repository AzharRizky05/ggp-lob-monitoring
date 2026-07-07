import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/dashboard_data.dart';

double _maxY(List<MonthlyProductionPoint> points) {
  if (points.isEmpty) {
    return 35;
  }

  final maxValue = points
      .map((point) => point.value)
      .reduce((a, b) => a > b ? a : b);

  return maxValue + 5;
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
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: loading || points.isEmpty
                  ? const Center(
                      child: Text('Memuat data produksi...'),
                    )
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
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < points.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      points[value.toInt()].label,
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
          ],
        ),
      ),
    );
  }
}