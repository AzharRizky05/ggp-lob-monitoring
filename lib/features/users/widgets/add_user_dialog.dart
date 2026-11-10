import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

/// Membuka dialog tambah (user == null) atau edit pengguna.
/// Provider diteruskan eksplisit karena dialog berada di luar pohon halaman.
Future<void> showUserDialog(BuildContext context, {UserModel? user}) {
  final provider = context.read<UserProvider>();

  return showDialog(
    context: context,
    builder: (_) => ChangeNotifierProvider.value(
      value: provider,
      child: AddUserDialog(user: user),
    ),
  );
}

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key, this.user});

  final UserModel? user;

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  int? _roleId;
  bool _isActive = true;
  bool _obscurePassword = true;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    final user = widget.user;

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _passwordController = TextEditingController();
    _phoneController = TextEditingController(text: user?.phone ?? '');

    _roleId = user?.roleId;
    _isActive = user?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon, {String? helper}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final phone = _phoneController.text.trim();
    final bool success;

    if (_isEdit) {
      success = await provider.updateUser(
        id: widget.user!.id,
        fullName: _nameController.text.trim(),
        phone: phone.isEmpty ? null : phone,
        roleId: _roleId!,
        isActive: _isActive,
      );
    } else {
      success = await provider.createUser(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: phone.isEmpty ? null : phone,
        roleId: _roleId!,
        isActive: _isActive,
      );
    }

    if (!mounted) return;

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isEdit ? 'Data pengguna diperbarui.' : 'Pengguna berhasil ditambahkan.',
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.actionError ?? 'Gagal menyimpan data pengguna.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final roles = provider.roles;
    final saving = provider.saving;

    final selfId = context.read<AuthProvider>().userProfile?.id;
    final isSelf = _isEdit && widget.user!.id == selfId;

    final selectedRole = roles.any((role) => role.id == _roleId) ? _roleId : null;

    return AlertDialog(
      title: Text(_isEdit ? 'Edit Pengguna' : 'Tambah Pengguna'),
      content: SizedBox(
        width: 520,
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
                  controller: _emailController,
                  enabled: !_isEdit,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration(
                    'Email',
                    Icons.email_outlined,
                    helper: _isEdit ? 'Email tidak dapat diubah' : null,
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Email wajib diisi';
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                if (!_isEdit) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _decoration(
                      'Password',
                      Icons.lock_outline,
                      helper: 'Minimal 6 karakter',
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                ],
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
                DropdownButtonFormField<int>(
                  initialValue: selectedRole,
                  decoration: _decoration(
                    'Role',
                    Icons.badge_outlined,
                    helper: isSelf ? 'Tidak dapat mengubah role akun sendiri' : null,
                  ),
                  items: roles
                      .map(
                        (role) => DropdownMenuItem<int>(
                          value: role.id,
                          child: Text(role.name),
                        ),
                      )
                      .toList(),
                  onChanged: isSelf ? null : (value) => setState(() => _roleId = value),
                  validator: (value) => value == null ? 'Pilih role' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<bool>(
                  initialValue: _isActive,
                  decoration: _decoration(
                    'Status',
                    Icons.toggle_on_outlined,
                    helper: isSelf ? 'Tidak dapat menonaktifkan akun sendiri' : null,
                  ),
                  items: const [
                    DropdownMenuItem<bool>(value: true, child: Text('Aktif')),
                    DropdownMenuItem<bool>(value: false, child: Text('Nonaktif')),
                  ],
                  onChanged: isSelf
                      ? null
                      : (value) => setState(() => _isActive = value ?? true),
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
              : const Icon(Icons.save_outlined),
          label: Text(saving ? 'Menyimpan...' : 'Simpan'),
        ),
      ],
    );
  }
}