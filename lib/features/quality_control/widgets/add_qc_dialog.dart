import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../providers/qc_provider.dart';

import '../models/qc_model.dart';

class AddQcDialog extends StatefulWidget {
  const AddQcDialog({super.key});

  @override
  State<AddQcDialog> createState() => _AddQcDialogState();
}

class _AddQcDialogState extends State<AddQcDialog> {
  final _formKey = GlobalKey<FormState>();

  final _phController = TextEditingController();
  final _densityController = TextEditingController();
  final _colorController = TextEditingController();
  final _odorController = TextEditingController();
  final _nutrientController = TextEditingController();
  final _labController = TextEditingController();
  final _scoreController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedBatchId;
  String? _selectedResult = "Passed";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final batchProvider = context.read<BatchProvider>();
      if (batchProvider.batches.isEmpty) {
        await batchProvider.loadBatches();
      }
      if (!mounted) return;

      final availableBatch = batchProvider.batches.where((e) {
        return e.status.trim().toLowerCase() == "qc pending";
      }).toList();

      if (availableBatch.isNotEmpty) {
        setState(() {
          _selectedBatchId = availableBatch.first.id;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final batchProvider = context.watch<BatchProvider>();
    final availableBatch = batchProvider.batches.where((e) {
      return e.status.trim().toLowerCase() == "qc pending";
    }).toList();

    return AlertDialog(
      title: const Text("Input Hasil Quality Control"),
      content: SizedBox(
        width: 650,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(_selectedBatchId),
                  initialValue: _selectedBatchId,
                  decoration: const InputDecoration(labelText: "Batch Produksi", border: OutlineInputBorder()),
                  items: availableBatch.map((batch) => DropdownMenuItem(value: batch.id, child: Text(batch.batchCode))).toList(),
                  onChanged: (value) => setState(() => _selectedBatchId = value),
                  validator: (value) => value == null ? "Pilih batch" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: auth.userProfile?.fullName ?? "",
                  enabled: false,
                  decoration: const InputDecoration(labelText: "Petugas QC", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextFormField(controller: _phController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "pH", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _densityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Density", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _colorController, decoration: const InputDecoration(labelText: "Color", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _odorController, decoration: const InputDecoration(labelText: "Odor", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _nutrientController, maxLines: 2, decoration: const InputDecoration(labelText: "Nutrient Content", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _labController, maxLines: 2, decoration: const InputDecoration(labelText: "Laboratory Result", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextFormField(controller: _scoreController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "QC Score", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey(_selectedResult),
                  initialValue: _selectedResult,
                  decoration: const InputDecoration(labelText: "QC Result", border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: "Passed", child: Text("Passed")),
                    DropdownMenuItem(value: "Failed", child: Text("Failed")),
                  ],
                  onChanged: (value) => setState(() => _selectedResult = value),
                ),
                const SizedBox(height: 16),
                TextFormField(controller: _notesController, maxLines: 3, decoration: const InputDecoration(labelText: "Notes", border: OutlineInputBorder())),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
        Consumer<QcProvider>(
          builder: (context, provider, _) {
            return FilledButton.icon(
              icon: const Icon(Icons.save),
              label: provider.loading
                  ? const Text("Menyimpan...")
                  : const Text("Simpan"),
              onPressed: provider.loading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate() || _selectedBatchId == null || _selectedResult == null) return;

                      final auth = context.read<AuthProvider>();
                      final selectedBatch = availableBatch.firstWhere((e) => e.id == _selectedBatchId);

                      final qc = QcModel(
                        id: const Uuid().v4(),
                        batchId: selectedBatch.id,
                        qcUser: auth.userProfile!.id,
                        inspectionDate: DateTime.now(),
                        ph: double.tryParse(_phController.text) ?? 0,
                        density: double.tryParse(_densityController.text) ?? 0,
                        color: _colorController.text,
                        odor: _odorController.text,
                        nutrientContent: _nutrientController.text,
                        laboratoryResult: _labController.text,
                        qcScore: int.tryParse(_scoreController.text) ?? 0,
                        result: _selectedResult!,
                        notes: _notesController.text,
                      );

                      final success = await provider.createQc(qc);
                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data QC berhasil disimpan.")));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage ?? "Gagal menyimpan data.")));
                      }
                    },
            );
          },
        ),
      ],
    );
  }
}