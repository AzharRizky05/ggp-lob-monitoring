import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../repositories/batch_repository.dart';
import '../models/batch_model.dart';

class AddBatchDialog extends StatefulWidget {
  final BatchModel? batch;

  const AddBatchDialog({
    super.key,
    this.batch,
  });

  @override
  State<AddBatchDialog> createState() => _AddBatchDialogState();
}

class _AddBatchDialogState extends State<AddBatchDialog> {
  static const List<String> _shifts = ["Pagi", "Siang", "Malam"];
  static const List<String> _tanks = ["Tank A", "Tank B", "Tank C", "Tank D"];

  final _formKey = GlobalKey<FormState>();
  final BatchRepository _repository = BatchRepository();

  final _batchNumberController = TextEditingController();
  final _targetVolumeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _productionDate = DateTime.now();

  String _selectedShift = "Pagi";
  String _selectedTank = "Tank A";

  /// Status awal untuk batch baru. Saat edit, status asli batch dipertahankan.
  final String _initialStatus = "Preparation";

  bool _saving = false;

  bool get isEdit => widget.batch != null;

  Future<void> _generateBatchCode() async {
    if (isEdit) return;

    final code = await _repository.generateBatchCode();

    if (!mounted) return;

    _batchNumberController.text = code;
  }

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final batch = widget.batch!;

      _batchNumberController.text = batch.batchNumber;
      _targetVolumeController.text = batch.targetVolume == batch.targetVolume.roundToDouble()
          ? batch.targetVolume.toStringAsFixed(0)
          : batch.targetVolume.toString();
      _notesController.text = batch.notes;

      _productionDate = batch.productionDate;
      _selectedShift = batch.shift;
      _selectedTank = batch.tank;
    } else {
      _generateBatchCode();
    }
  }

  @override
  void dispose() {
    _batchNumberController.dispose();
    _targetVolumeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double? _parseVolume(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Pilihan dropdown. Nilai yang sudah tersimpan tetap ikut ditampilkan
  /// walau di luar daftar standar, supaya dialog tidak error.
  List<DropdownMenuItem<String>> _items(List<String> base, String current) {
    final values = [...base];
    if (!values.contains(current)) values.add(current);

    return values
        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
        .toList();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _productionDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _productionDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final batchProvider = context.read<BatchProvider>();

    final profile = authProvider.userProfile;

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User tidak ditemukan."),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    final existing = widget.batch;

    final batch = BatchModel(
      id: existing?.id ?? const Uuid().v4(),
      batchNumber: _batchNumberController.text.trim(),
      productionDate: _productionDate,
      shift: _selectedShift,
      tank: _selectedTank,
      // Saat edit, kepemilikan, status, dan volume batch tidak boleh berubah.
      operatorId: existing?.operatorId ?? profile.id,
      operatorName: existing?.operatorName ?? profile.fullName,
      targetVolume: _parseVolume(_targetVolumeController.text)!,
      actualVolume: existing?.actualVolume ?? 0,
      status: existing?.status ?? _initialStatus,
      notes: _notesController.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = isEdit
        ? await batchProvider.updateBatch(batch)
        : await batchProvider.createBatch(batch);

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    if (success) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? "Batch berhasil diperbarui." : "Batch berhasil dibuat.",
          ),
        ),
      );
    } else {
      final error = batchProvider.errorMessage?.replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? "Gagal menyimpan batch."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEdit ? "Edit Batch Produksi" : "Tambah Batch Produksi",
      ),
      content: SizedBox(
        width: 550,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _batchNumberController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Nomor Batch",
                    hintText: "Generate otomatis...",
                    prefixIcon: Icon(Icons.qr_code),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Batch Code belum tergenerate";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Tanggal Produksi",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(_formatDate(_productionDate)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedShift,
                  decoration: const InputDecoration(
                    labelText: "Shift",
                    border: OutlineInputBorder(),
                  ),
                  items: _items(_shifts, _selectedShift),
                  onChanged: (value) {
                    setState(() {
                      _selectedShift = value ?? _selectedShift;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedTank,
                  decoration: const InputDecoration(
                    labelText: "Tangki Produksi",
                    border: OutlineInputBorder(),
                  ),
                  items: _items(_tanks, _selectedTank),
                  onChanged: (value) {
                    setState(() {
                      _selectedTank = value ?? _selectedTank;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetVolumeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Target Volume (Liter)",
                    border: OutlineInputBorder(),
                    suffixText: "L",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Target volume wajib diisi";
                    }
                    final number = _parseVolume(value);
                    if (number == null) {
                      return "Masukkan angka yang valid";
                    }
                    if (number <= 0) {
                      return "Target volume harus lebih dari 0";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Catatan",
                    hintText: "Tambahkan catatan produksi...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving
              ? null
              : () {
                  Navigator.pop(context);
                },
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
          label: Text(
            _saving ? "Menyimpan..." : "Simpan",
          ),
        ),
      ],
    );
  }
}