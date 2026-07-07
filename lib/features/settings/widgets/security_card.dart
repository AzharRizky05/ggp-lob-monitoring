import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SecurityCard extends StatelessWidget {
  const SecurityCard({super.key});

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
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.blue,
                ),
              ),
              title: const Text("Ubah Password"),
              subtitle: const Text(
                "Perbarui password akun Anda secara berkala.",
              ),
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text("Ubah"),
              ),
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: Colors.green,
                ),
              ),
              title: const Text("Two-Factor Authentication"),
              subtitle: const Text(
                "Aktifkan keamanan login tambahan.",
              ),
              trailing: Switch(
                value: false,
                onChanged: (_) {},
              ),
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFF3E0),
                child: Icon(
                  Icons.history,
                  color: Colors.orange,
                ),
              ),
              title: const Text("Riwayat Login"),
              subtitle: const Text(
                "Login terakhir: Hari ini, 08:15 WIB",
              ),
              trailing: TextButton(
                onPressed: () {},
                child: const Text("Lihat"),
              ),
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF3E5F5),
                child: Icon(
                  Icons.devices_outlined,
                  color: Colors.purple,
                ),
              ),
              title: const Text("Perangkat Aktif"),
              subtitle: const Text(
                "Windows • Chrome Browser",
              ),
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text("Kelola"),
              ),
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
              title: const Text("Logout"),
              subtitle: const Text(
                "Keluar dari aplikasi ini.",
              ),
              trailing: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {},
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