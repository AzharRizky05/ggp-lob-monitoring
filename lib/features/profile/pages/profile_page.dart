import 'package:flutter/material.dart';

import '../../../shared/widgets/layout/app_layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Profile',
      child: Center(
        child: Text(
          'Profile Page\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}