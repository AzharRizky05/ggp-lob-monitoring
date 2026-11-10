import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../models/profile_view_data.dart';
import '../providers/profile_provider.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_information_card.dart';
import '../widgets/profile_security_card.dart';
import '../widgets/profile_summary_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = context.read<AuthProvider>().userProfile?.id;
      if (userId != null) {
        context.read<ProfileProvider>().loadJoinedDate(userId);
      }
    });
  }

  void _openEditDialog(ProfileViewData data) {
    final provider = context.read<ProfileProvider>();

    // Dialog berada di luar pohon widget halaman ini,
    // jadi ProfileProvider diteruskan secara eksplisit.
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: EditProfileDialog(profile: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().userProfile;
    final joinedAt = context.select<ProfileProvider, DateTime?>((p) => p.joinedAt);

    if (profile == null) {
      return const AppLayout(
        title: 'Profile',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final data = ProfileViewData.from(profile, profile.createdAt ?? joinedAt);

    return AppLayout(
      title: 'Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: AppSpacing.xxl),
            ProfileSummaryCard(
              profile: data,
              onEditProfile: () => _openEditDialog(data),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildContentSection(data),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(ProfileViewData data) {
    final infoCard = ProfileInformationCard(
      profile: data,
      onEditProfile: () => _openEditDialog(data),
    );
    const securityCard = ProfileSecurityCard();

    if (!ResponsiveBuilder.isMobile(context)) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: infoCard),
            const SizedBox(width: AppSpacing.xxl),
            const Expanded(child: securityCard),
          ],
        ),
      );
    }

    return Column(
      children: [
        infoCard,
        const SizedBox(height: AppSpacing.xxl),
        securityCard,
      ],
    );
  }
}