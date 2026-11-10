import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().userProfile;

    if (profile == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final name = profile.fullName.trim();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final statusColor = profile.isActive ? Colors.green : Colors.red;

    final info = Row(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: AppColors.primary,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                profile.email,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.blue,
                      size: 18,
                    ),
                    label: Text(profile.roleName),
                  ),
                  Chip(
                    avatar: Icon(
                      profile.isActive ? Icons.check_circle : Icons.cancel,
                      color: statusColor,
                      size: 18,
                    ),
                    label: Text(profile.isActive ? 'Aktif' : 'Nonaktif'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final button = FilledButton.icon(
      onPressed: () => context.go(RouteName.profile),
      icon: const Icon(Icons.edit_outlined),
      label: const Text("Kelola Profil"),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  info,
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: button),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: info),
                const SizedBox(width: 16),
                button,
              ],
            );
          },
        ),
      ),
    );
  }
}