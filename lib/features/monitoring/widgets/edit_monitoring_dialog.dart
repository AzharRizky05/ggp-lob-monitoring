import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/monitoring_provider.dart';
import '../models/monitoring_model.dart';

class EditMonitoringDialog extends StatefulWidget {
  const EditMonitoringDialog({super.key, required this.monitoring});

  final MonitoringModel monitoring;

  @override
  State<EditMonitoringDialog> createState() => _EditMonitoringDialogState();
}

class _EditMonitoringDialogState extends State<EditMonitoringDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _temperatureController;
  late final TextEditingController _phController;
  late final TextEditingController _brixController;
  late final TextEditingController _volumeController;
  late final TextEditingController _mixingTimeController;
  late final TextEditingController _fermentationTimeController;
  late final TextEditingController _flowRateController;
  late final TextEditingController _remarksController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.monitoring;

    _temperatureController = TextEditingController(text: m.temperature.toString());
    _phController = TextEditingController(text: m.ph.toString());
    _brixController = TextEditingController(text: m.brix.toString());
    _volumeController = TextEditingController(text: m.volume.toString());
    _mixingTimeController = TextEditingController(text: m.mixingTime.toString());
    _fermentationTimeController =
        TextEditingController(text: m.fermentationTime.toString());
    _flowRateController = TextEditingController(text: m.flowRate.toString());
    _remarksController = TextEditingController(text: m.remarks);
  }

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

  String? _validateInteger(String? value) {
    if (value == null || value.trim().isEmpty) return "Harus diisi";
    final number = int.tryParse(value.trim());
    if (number == null) return "Harus berupa bilangan bulat";
    if (number < 0) return "Tidak boleh negatif";
    return null;
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool decimal = true,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: maxLines > 1
          ? TextInputType.multiline
          : TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MonitoringProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final m = widget.monitoring;

    setState(() => _saving = true);

    final updated = MonitoringModel(
      id: m.id,
      batchId: m.batchId,
      recordedAt: m.recordedAt,
      temperature: _parseDouble(_temperatureController.text)!,
      ph: _parseDouble(_phController.text)!,
      brix: _parseDouble(_brixController.text)!,
      volume: _parseDouble(_volumeController.text)!,
      mixingTime: int.parse(_mixingTimeController.text.trim()),
      fermentationTime: int.parse(_fermentationTimeController.text.trim()),
      flowRate: _parseDouble(_flowRateController.text)!,
      remarks: _remarksController.text.trim(),
      createdBy: m.createdBy,
      batchCode: m.batchCode,
      operatorName: m.operatorName,
      status: m.status,
    );

    final success = await provider.updateMonitoring(updated);

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Data monitoring berhasil diperbarui.")),
      );
    } else {
      final error = provider.errorMessage?.replaceFirst('Exception: ', '');
      messenger.showSnackBar(
        SnackBar(content: Text(error ?? "Gagal memperbarui monitoring.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Monitoring • ${widget.monitoring.batchCode}"),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(
                  controller: _temperatureController,
                  label: "Temperature (°C)",
                  validator: _validateDecimal,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _phController,
                  label: "pH",
                  validator: (value) => _validateDecimal(value, max: 14),
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _brixController,
                  label: "Brix",
                  validator: _validateDecimal,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _volumeController,
                  label: "Volume (Liter)",
                  validator: _validateDecimal,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _mixingTimeController,
                  label: "Mixing Time (Menit)",
                  validator: _validateInteger,
                  decimal: false,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _fermentationTimeController,
                  label: "Fermentation Time (Jam)",
                  validator: _validateInteger,
                  decimal: false,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _flowRateController,
                  label: "Flow Rate",
                  validator: _validateDecimal,
                ),
                const SizedBox(height: 16),
                _field(
                  controller: _remarksController,
                  label: "Remarks",
                  maxLines: 3,
                ),
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