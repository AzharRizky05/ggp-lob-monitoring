import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../models/company_settings.dart';
import '../providers/settings_provider.dart';
import 'edit_company_dialog.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({super.key});

  static const String _appName = 'LOB Production Monitoring System';
  static const String _appVersion = 'Version 1.0.0';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final role = context.watch<AuthProvider>().userProfile?.roleName.toLowerCase() ?? '';
    final isAdmin = role.contains('admin');

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
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Informasi Perusahaan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (isAdmin)
                  OutlinedButton.icon(
                    onPressed: provider.loading
                        ? null
                        : () => showEditCompanyDialog(context),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text("Edit"),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (provider.loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.errorMessage != null)
              _ErrorView(
                message: provider.errorMessage!,
                onRetry: provider.loadCompany,
              )
            else
              _buildRows(provider.company),
          ],
        ),
      ),
    );
  }

  Widget _buildRows(CompanySettings company) {
    final tiles = [
      _InfoTile(
        icon: Icons.business,
        background: const Color(0xFFE3F2FD),
        color: Colors.blue,
        title: "Perusahaan",
        value: CompanySettings.display(company.companyName),
      ),
      _InfoTile(
        icon: Icons.factory_outlined,
        background: const Color(0xFFE8F5E9),
        color: Colors.green,
        title: "Plant",
        value: CompanySettings.display(company.factoryName),
      ),
      _InfoTile(
        icon: Icons.apartment_outlined,
        background: const Color(0xFFFFF3E0),
        color: Colors.orange,
        title: "Departemen",
        value: CompanySettings.display(company.department),
      ),
      _InfoTile(
        icon: Icons.location_on_outlined,
        background: const Color(0xFFF3E5F5),
        color: Colors.purple,
        title: "Lokasi",
        value: CompanySettings.display(company.address),
      ),
      _InfoTile(
        icon: Icons.phone_outlined,
        background: const Color(0xFFE0F2F1),
        color: Colors.teal,
        title: "Telepon",
        value: CompanySettings.display(company.phone),
      ),
      _InfoTile(
        icon: Icons.email_outlined,
        background: const Color(0xFFFCE4EC),
        color: Colors.pink,
        title: "Email",
        value: CompanySettings.display(company.email),
      ),
      const _InfoTile(
        icon: Icons.settings_applications,
        background: Color(0xFFE0F7FA),
        color: Colors.cyan,
        title: "Aplikasi",
        value: _appName,
      ),
      const _InfoTile(
        icon: Icons.info_outline,
        background: Color(0xFFFFF8E1),
        color: Colors.amber,
        title: "Versi",
        value: _appVersion,
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          tiles[i],
          if (i < tiles.length - 1) const Divider(),
        ],
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.background,
    required this.color,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color background;
  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: background,
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Gagal memuat informasi perusahaan."),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }
}