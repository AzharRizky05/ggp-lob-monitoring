import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../layout/app_layout.dart';

class ComingSoonPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ComingSoonPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: title,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 90,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.construction),
              label: const Text("Sedang Dalam Pengembangan"),
            ),
          ],
        ),
      ),
    );
  }
}