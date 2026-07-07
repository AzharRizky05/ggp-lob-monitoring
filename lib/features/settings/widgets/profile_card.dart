import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 42,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 24),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Administrator",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "admin@lob-monitoring.com",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Chip(
                        avatar: Icon(
                          Icons.admin_panel_settings,
                          color: Colors.blue,
                          size: 18,
                        ),
                        label: Text("Administrator"),
                      ),

                      SizedBox(width: 12),

                      Chip(
                        avatar: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                        label: Text("Aktif"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text("Edit Profil"),
            ),
          ],
        ),
      ),
    );
  }
}