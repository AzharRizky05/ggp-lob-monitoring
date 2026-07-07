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
  final _formKey = GlobalKey<FormState>();
  final BatchRepository _repository = BatchRepository();

  final _batchNumberController = TextEditingController();
  final _targetVolumeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _productionDate = DateTime.now();

  String _selectedShift = "Pagi";
  String _selectedTank = "Tank A";
  final String _selectedStatus = "Preparation";

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
      _targetVolumeController.text = batch.targetVolume.toString();
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

    final batch = BatchModel(
      id: isEdit ? widget.batch!.id : const Uuid().v4(),
      batchNumber: _batchNumberController.text.trim(),
      productionDate: _productionDate,
      shift: _selectedShift,
      tank: _selectedTank,
      operatorId: profile.id,
      operatorName: profile.fullName,
      targetVolume: double.parse(_targetVolumeController.text),
      actualVolume: 0,
      status: _selectedStatus,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
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
        const SnackBar(
          content: Text("Batch berhasil dibuat."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            batchProvider.errorMessage ?? "Gagal menyimpan batch.",
          ),
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
                    child: Text(
                      "${_productionDate.day}/${_productionDate.month}/${_productionDate.year}",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedShift,
                  decoration: const InputDecoration(
                    labelText: "Shift",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Pagi", child: Text("Pagi")),
                    DropdownMenuItem(value: "Siang", child: Text("Siang")),
                    DropdownMenuItem(value: "Malam", child: Text("Malam")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedShift = value!;
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
                  items: const [
                    DropdownMenuItem(value: "Tank A", child: Text("Tank A")),
                    DropdownMenuItem(value: "Tank B", child: Text("Tank B")),
                    DropdownMenuItem(value: "Tank C", child: Text("Tank C")),
                    DropdownMenuItem(value: "Tank D", child: Text("Tank D")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTank = value!;
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
                    if (value == null || value.isEmpty) {
                      return "Target volume wajib diisi";
                    }
                    if (double.tryParse(value) == null) {
                      return "Masukkan angka yang valid";
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