import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/qc_provider.dart';
import '../models/qc_model.dart';

class EditQcDialog extends StatefulWidget {
  const EditQcDialog({super.key, required this.qc});

  final QcModel qc;

  @override
  State<EditQcDialog> createState() => _EditQcDialogState();
}

class _EditQcDialogState extends State<EditQcDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _phController;
  late final TextEditingController _densityController;
  late final TextEditingController _colorController;
  late final TextEditingController _odorController;
  late final TextEditingController _nutrientController;
  late final TextEditingController _labController;
  late final TextEditingController _scoreController;
  late final TextEditingController _notesController;

  late String _result;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final qc = widget.qc;

    _phController = TextEditingController(text: qc.ph.toString());
    _densityController = TextEditingController(text: qc.density.toString());
    _colorController = TextEditingController(text: qc.color);
    _odorController = TextEditingController(text: qc.odor);
    _nutrientController = TextEditingController(text: qc.nutrientContent);
    _labController = TextEditingController(text: qc.laboratoryResult);
    _scoreController = TextEditingController(text: qc.qcScore.toString());
    _notesController = TextEditingController(text: qc.notes);

    _result = const ['Passed', 'Failed'].contains(qc.result) ? qc.result : 'Passed';
  }

  @override
  void dispose() {
    _phController.dispose();
    _densityController.dispose();
    _colorController.dispose();
    _odorController.dispose();
    _nutrientController.dispose();
    _labController.dispose();
    _scoreController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double? _parseDouble(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  String? _validateDecimal(String? value, {double? max}) {
    if (value == null || value.trim().isEmpty) return "Harus diisi";
    final number = _parseDouble(value);
    if (number == null) return "Angka tidak valid";
    if (number < 0) return "Tidak boleh negatif";
    if (max != null && number > max) return "Maksimal $max";
    return null;
  }

  String? _validateScore(String? value) {
    if (value == null || value.trim().isEmpty) return "Harus diisi";
    final number = int.tryParse(value.trim());
    if (number == null) return "Harus berupa bilangan bulat";
    if (number < 0 || number > 100) return "Isi antara 0 sampai 100";
    return null;
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool numeric = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<QcProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _saving = true);

    final updated = widget.qc.copyWith(
      ph: _parseDouble(_phController.text)!,
      density: _parseDouble(_densityController.text)!,
      color: _colorController.text.trim(),
      odor: _odorController.text.trim(),
      nutrientContent: _nutrientController.text.trim(),
      laboratoryResult: _labController.text.trim(),
      qcScore: int.parse(_scoreController.text.trim()),
      result: _result,
      notes: _notesController.text.trim(),
    );

    final success = await provider.updateQc(updated);

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Hasil QC berhasil diperbarui.")),
      );
    } else {
      final error = provider.errorMessage?.replaceFirst('Exception: ', '');
      messenger.showSnackBar(
        SnackBar(content: Text(error ?? "Gagal memperbarui hasil QC.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Hasil QC • ${widget.qc.batchCode}"),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(
                  controller: _phController,
                  label: "pH",
                  numeric: true,
                  validator: (value) => _validateDecimal(value, max: 14),
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _densityController,
                  label: "Density",
                  numeric: true,
                  validator: _validateDecimal,
                ),
                const SizedBox(height: 16),
                _field(controller: _colorController, label: "Color"),
                const SizedBox(height: 16),
                _field(controller: _odorController, label: "Odor"),
                const SizedBox(height: 16),
                _field(
                  controller: _nutrientController,
                  label: "Nutrient Content",
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _labController,
                  label: "Laboratory Result",
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _scoreController,
                  label: "QC Score (0 - 100)",
                  validator: _validateScore,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _result,
                  decoration: const InputDecoration(
                    labelText: "QC Result",
                    border: OutlineInputBorder(),
                    helperText:
                        "Passed: batch dikirim ke Supervisor. Failed: batch ditandai QC Failed.",
                    helperMaxLines: 2,
                  ),
                  items: const [
                    DropdownMenuItem(value: "Passed", child: Text("Passed")),
                    DropdownMenuItem(value: "Failed", child: Text("Failed")),
                  ],
                  onChanged: (value) => setState(() => _result = value ?? _result),
                ),
                const SizedBox(height: 16),
                _field(controller: _notesController, label: "Notes", maxLines: 3),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save),
          label: Text(_saving ? "Menyimpan..." : "Simpan"),
        ),
      ],
    );
  }
}