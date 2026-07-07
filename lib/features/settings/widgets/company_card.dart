import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informasi Perusahaan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(
                  Icons.business,
                  color: Colors.blue,
                ),
              ),
              title: Text("Perusahaan"),
              subtitle: Text("PT Great Giant Pineapple"),
            ),

            const Divider(),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.factory_outlined,
                  color: Colors.green,
                ),
              ),
              title: Text("Plant"),
              subtitle: Text("LOB Production"),
            ),

            const Divider(),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(0xFFFFF3E0),
                child: Icon(
                  Icons.apartment_outlined,
                  color: Colors.orange,
                ),
              ),
              title: Text("Departemen"),
              subtitle: Text("Maintenance Engineering"),
            ),

            const Divider(),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(0xFFF3E5F5),
                child: Icon(
                  Icons.location_on_outlined,
                  color: Colors.purple,
                ),
              ),
              title: Text("Lokasi"),
              subtitle: Text("Terbanggi Besar, Lampung"),
            ),

            const Divider(),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE0F7FA),
                child: Icon(
                  Icons.settings_applications,
                  color: Colors.cyan,
                ),
              ),
              title: Text("Aplikasi"),
              subtitle: Text("LOB Production Monitoring System"),
            ),

            const Divider(),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(0xFFFFF8E1),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.amber,
                ),
              ),
              title: Text("Versi"),
              subtitle: Text("Version 1.0.0"),
            ),
          ],
        ),
      ),
    );
  }
}