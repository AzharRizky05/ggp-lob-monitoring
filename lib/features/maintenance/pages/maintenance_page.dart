import 'package:flutter/material.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/maintenance_header.dart';
import '../widgets/maintenance_search.dart';
import '../widgets/maintenance_table.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: "Pemeliharaan",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaintenanceHeader(),

            SizedBox(height: 24),

            MaintenanceSearch(),

            SizedBox(height: 24),

            MaintenanceTable(),
          ],
        ),
      ),
    );
  }
}