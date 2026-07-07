import 'package:flutter/material.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/company_card.dart';
import '../widgets/notification.dart';
import '../widgets/profile_card.dart';
import '../widgets/security_card.dart';
import '../widgets/settings_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Pengaturan",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SettingsHeader(),

            SizedBox(height: 24),

            ProfileCard(),

            SizedBox(height: 24),

            CompanyCard(),

            SizedBox(height: 24),

            SecurityCard(),

            SizedBox(height: 24),

            NotificationCard(),
          ],
        ),
      ),
    );
  }
}