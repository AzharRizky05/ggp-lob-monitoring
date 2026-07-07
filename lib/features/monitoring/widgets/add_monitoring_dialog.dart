import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/workflows/operator_workflow.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/batch_provider.dart';
import '../../../providers/monitoring_provider.dart';

import '../../batch/models/batch_model.dart';
import '../models/monitoring_model.dart';

class AddMonitoringDialog extends StatefulWidget {
  const AddMonitoringDialog({super.key});

  @override
  State<AddMonitoringDialog> createState() => _AddMonitoringDialogState();
}

class _AddMonitoringDialogState extends State<AddMonitoringDialog> {
  final _formKey = GlobalKey<FormState>();

  BatchModel? _selectedBatch;

  final _temperatureController = TextEditingController();
  final _phController = TextEditingController();
  final _brixController = TextEditingController();
  final _volumeController = TextEditingController();
  final _mixingTimeController = TextEditingController();
  final _fermentationTimeController = TextEditingController();
  final _flowRateController = TextEditingController();
  final _remarksController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _temperatureController.dispose();
    _phController.dispose();
    _brixController.dispose();
    _volumeController.dispose();
    _mixingTimeController.dispose();
    _fermentationTimeController.dispose();
    _flowRateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedBatch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih batch terlebih dahulu."),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final monitoringProvider = context.read<MonitoringProvider>();
    final profile = auth.userProfile;

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

    final monitoring = MonitoringModel(
      id: const Uuid().v4(),
      batchId: _selectedBatch!.id,
      recordedAt: DateTime.now(),
      temperature: double.parse(_temperatureController.text),
      ph: double.parse(_phController.text),
      brix: double.parse(_brixController.text),
      volume: double.parse(_volumeController.text),
      mixingTime: int.parse(_mixingTimeController.text),
      fermentationTime: int.parse(_fermentationTimeController.text),
      flowRate: double.parse(_flowRateController.text),
      remarks: _remarksController.text.trim(),
      createdBy: profile.id,
    );

    final success = await monitoringProvider.createMonitoring(monitoring);

    if (!mounted) return;

    if (success) {
      /// ===============================
      /// REFRESH DATA BATCH
      /// ===============================
      final batchProvider = context.read<BatchProvider>();
      await batchProvider.loadBatches();

      if (!mounted) return;
    }

    setState(() {
      _saving = false;
    });

    if (success) {
      Navigator.pop(context);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Monitoring berhasil disimpan."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            monitoringProvider.errorMessage ?? "Gagal menyimpan monitoring.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final batches = context
        .watch<BatchProvider>()
        .batches
        .where(
          (e) => OperatorWorkflow.canCreateMonitoring(e.status),
        )
        .toList();

  debugPrint("========== BATCH MONITORING ==========");
  debugPrint("Jumlah Batch : ${batches.length}");

  for (final batch in batches) {
    debugPrint(
      "${batch.batchCode} | ${batch.status} | ${batch.operatorName}",
    );
  }

    debugPrint("=====================================");

    return AlertDialog(
      title: const Text("Tambah Monitoring Produksi"),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// PILIH BATCH
                DropdownButtonFormField<BatchModel>(
                  initialValue: _selectedBatch,
                  decoration: const InputDecoration(
                    labelText: "Batch Produksi",
                    border: OutlineInputBorder(),
                  ),
                  items: batches
                      .map(
                        (batch) => DropdownMenuItem(
                          value: batch,
                          child: Text(batch.batchCode),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBatch = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Pilih batch.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// TEMPERATURE
                TextFormField(
                  controller: _temperatureController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Temperature (°C)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (double.tryParse(value) == null) {
                      return "Angka tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// pH
                TextFormField(
                  controller: _phController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "pH",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (double.tryParse(value) == null) {
                      return "Angka tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// BRIX
                TextFormField(
                  controller: _brixController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Brix",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (double.tryParse(value) == null) {
                      return "Angka tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// VOLUME
                TextFormField(
                  controller: _volumeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Volume (Liter)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (double.tryParse(value) == null) {
                      return "Angka tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// MIXING TIME
                TextFormField(
                  controller: _mixingTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Mixing Time (Menit)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harus berupa angka";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// FERMENTATION TIME
                TextFormField(
                  controller: _fermentationTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Fermentation Time (Jam)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harus berupa angka";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// FLOW RATE
                TextFormField(
                  controller: _flowRateController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Flow Rate",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harus diisi";
                    }
                    if (double.tryParse(value) == null) {
                      return "Angka tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// REMARKS
                TextFormField(
                  controller: _remarksController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Remarks",
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