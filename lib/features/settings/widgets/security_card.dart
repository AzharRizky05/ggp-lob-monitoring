import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

class SecurityCard extends StatelessWidget {
  const SecurityCard({super.key});

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Keluar dari aplikasi?"),
        content: const Text("Anda perlu login kembali untuk mengakses sistem."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Keluar"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await auth.logout();
    router.go(RouteName.login);
  }

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
              "Keamanan Akun",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.lock_outline, color: Colors.blue),
              ),
              title: const Text("Ubah Password"),
              subtitle: const Text(
                "Perbarui password akun Anda secara berkala.",
              ),
              trailing: OutlinedButton(
                onPressed: () => context.go(RouteName.profile),
                child: const Text("Ubah"),
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(Icons.logout, color: Colors.red),
              ),
              title: const Text("Logout"),
              subtitle: const Text("Keluar dari aplikasi ini."),
              trailing: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}