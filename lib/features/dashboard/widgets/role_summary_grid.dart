import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import 'summary_card.dart';

class DashboardCardItem {
  const DashboardCardItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final int value;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class RoleSummaryGrid extends StatelessWidget {
  const RoleSummaryGrid({
    super.key,
    required this.items,
    this.loading = false,
  });

  final List<DashboardCardItem> items;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount;

    if (Responsive.isDesktop(context)) {
      crossAxisCount = 4;
    } else if (Responsive.isTablet(context)) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: Responsive.isDesktop(context) ? 1.45 : 1.25,
      children: items
          .map(
            (item) => SummaryCard(
              title: item.title,
              value: loading ? "--" : item.value.toString(),
              subtitle: loading ? "Loading..." : item.subtitle,
              icon: item.icon,
              color: item.color,
            ),
          )
          .toList(),
    );
  }
}