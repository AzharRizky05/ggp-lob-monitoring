import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../providers/settings_provider.dart';
import '../widgets/company_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/security_card.dart';
import '../widgets/settings_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: "Pengaturan",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsHeader(),
            SizedBox(height: 24),
            ProfileCard(),
            SizedBox(height: 24),
            CompanyCard(),
            SizedBox(height: 24),
            SecurityCard(),
          ],
        ),
      ),
    );
  }
}