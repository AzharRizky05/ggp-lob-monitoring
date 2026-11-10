import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../models/profile_view_data.dart';
import '../providers/profile_provider.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key, required this.profile});

  final ProfileViewData profile;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final provider = context.read<ProfileProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final userId = auth.userProfile?.id;
    if (userId == null) return;

    final phone = _phoneController.text.trim();

    final success = await provider.updateProfile(
      userId: userId,
      fullName: _nameController.text.trim(),
      phone: phone.isEmpty ? null : phone,
    );

    if (!mounted) return;

    if (success) {
      await auth.refreshProfile();
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui.')),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Gagal menyimpan profil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.select<ProfileProvider, bool>((p) => p.savingProfile);

    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _decoration('Nama Lengkap', Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration('Telepon (opsional)', Icons.phone_outlined),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;
                    if (!RegExp(r'^[0-9+\-\s]{6,20}$').hasMatch(text)) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.profile.email,
                  enabled: false,
                  decoration: _decoration('Email', Icons.mail_outline),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.profile.role,
                  enabled: false,
                  decoration: _decoration('Role', Icons.badge_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton.icon(
          onPressed: saving ? null : _save,
          icon: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save),
          label: Text(saving ? 'Menyimpan...' : 'Simpan'),
        ),
      ],
    );
  }
}