class HistoryModel {
  final String id;
  final String batchId;
  final String batchCode;
  final String operatorName;
  final DateTime? productionDate;
  final String shift;
  final String tank;
  final double targetVolume;
  final double finalVolume;
  final String qcResult;
  final String approvedByName;
  final DateTime? completedAt;
  final String remarks;

  const HistoryModel({
    required this.id,
    required this.batchId,
    required this.batchCode,
    required this.operatorName,
    required this.productionDate,
    required this.shift,
    required this.tank,
    required this.targetVolume,
    required this.finalVolume,
    required this.qcResult,
    required this.approvedByName,
    required this.completedAt,
    required this.remarks,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: (map['id'] ?? '').toString(),
      batchId: (map['batch_id'] ?? '').toString(),
      batchCode: (map['batch_code'] ?? '-').toString(),
      operatorName: (map['operator_name'] ?? '-').toString(),
      productionDate:
          DateTime.tryParse((map['production_date'] ?? '').toString()),
      shift: (map['shift'] ?? '-').toString(),
      tank: (map['tank'] ?? '-').toString(),
      targetVolume: (map['target_volume'] as num?)?.toDouble() ?? 0,
      finalVolume: (map['final_volume'] as num?)?.toDouble() ?? 0,
      qcResult: (map['qc_result'] ?? '-').toString(),
      approvedByName: (map['approved_by_name'] ?? '-').toString(),
      completedAt: DateTime.tryParse((map['completed_at'] ?? '').toString())
          ?.toLocal(),
      remarks: (map['remarks'] ?? '').toString(),
    );
  }

  String get productionDateLabel => _formatDate(productionDate);
  String get completedAtLabel => _formatDateTime(completedAt);
  String get finalVolumeLabel => _formatVolume(finalVolume);
  String get targetVolumeLabel => _formatVolume(targetVolume);

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${_two(date.day)}/${_two(date.month)}/${date.year}';
  }

  static String _formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return '${_formatDate(date)} ${_two(date.hour)}:${_two(date.minute)}';
  }

  static String _formatVolume(double value) {
    final text = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$text L';
  }
}