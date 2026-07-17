import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Tombol outline hijau untuk aksi sekunder (mis. "Edit Profil").
/// Dibuat mengikuti pola PrimaryButton agar konsisten & reusable,
/// karena tombol ini dipakai di lebih dari satu tempat pada modul Profile.
class OutlineButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool fullWidth;

  const OutlineButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );

    return fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}