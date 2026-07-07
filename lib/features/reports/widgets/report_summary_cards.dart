import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ReportSummaryCards extends StatelessWidget {
  const ReportSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.7,
      children: const [
        _SummaryCard(
          title: "Total Batch",
          value: "125",
          icon: Icons.inventory_2_outlined,
          color: Colors.blue,
        ),
        _SummaryCard(
          title: "Batch Selesai",
          value: "110",
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        _SummaryCard(
          title: "Batch Berjalan",
          value: "10",
          icon: Icons.autorenew_outlined,
          color: Colors.orange,
        ),
        _SummaryCard(
          title: "Pending Approval",
          value: "5",
          icon: Icons.fact_check_outlined,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

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
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
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