import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

/// Provider diteruskan eksplisit karena dialog berada di luar pohon halaman.
Future<void> showEditCompanyDialog(BuildContext context) {
  final provider = context.read<SettingsProvider>();

  return showDialog(
    context: context,
    builder: (_) => ChangeNotifierProvider.value(
      value: provider,
      child: const EditCompanyDialog(),
    ),
  );
}

class EditCompanyDialog extends StatefulWidget {
  const EditCompanyDialog({super.key});

  @override
  State<EditCompanyDialog> createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyController;
  late final TextEditingController _factoryController;
  late final TextEditingController _departmentController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final company = context.read<SettingsProvider>().company;

    _companyController = TextEditingController(text: company.companyName ?? '');
    _factoryController = TextEditingController(text: company.factoryName ?? '');
    _departmentController = TextEditingController(text: company.department ?? '');
    _addressController = TextEditingController(text: company.address ?? '');
    _phoneController = TextEditingController(text: company.phone ?? '');
    _emailController = TextEditingController(text: company.email ?? '');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _factoryController.dispose();
    _departmentController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  String? _valueOrNull(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SettingsProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final success = await provider.saveCompany(
      companyName: _companyController.text.trim(),
      factoryName: _valueOrNull(_factoryController),
      department: _valueOrNull(_departmentController),
      address: _valueOrNull(_addressController),
      phone: _valueOrNull(_phoneController),
      email: _valueOrNull(_emailController),
    );

    if (!mounted) return;

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Informasi perusahaan berhasil disimpan.')),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.actionError ?? 'Gagal menyimpan informasi perusahaan.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.select<SettingsProvider, bool>((p) => p.saving);

    return AlertDialog(
      title: const Text('Edit Informasi Perusahaan'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _companyController,
                  decoration: _decoration('Perusahaan', Icons.business),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama perusahaan wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _factoryController,
                  decoration: _decoration('Plant', Icons.factory_outlined),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departmentController,
                  decoration: _decoration('Departemen', Icons.apartment_outlined),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: _decoration('Lokasi', Icons.location_on_outlined),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration('Telepon', Icons.phone_outlined),
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration('Email', Icons.email_outlined),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
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