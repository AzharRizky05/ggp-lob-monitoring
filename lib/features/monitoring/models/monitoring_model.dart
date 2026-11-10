class MonitoringModel {
  final String id;

  final String batchId;

  final DateTime recordedAt;

  final double temperature;

  final double ph;

  final double brix;

  final double volume;

  final int mixingTime;

  final int fermentationTime;

  final double flowRate;

  final String remarks;

  final String createdBy;

  /// Tahap produksi saat log ini dicatat (kolom production_logs.stage).
  /// Kosong untuk data lama yang dibuat sebelum kolom ini ada.
  final String stage;

  /// data tambahan hasil JOIN
  final String batchCode;

  final String operatorName;

  final String status;

  const MonitoringModel({
    required this.id,
    required this.batchId,
    required this.recordedAt,
    required this.temperature,
    required this.ph,
    required this.brix,
    required this.volume,
    required this.mixingTime,
    required this.fermentationTime,
    required this.flowRate,
    required this.remarks,
    required this.createdBy,
    this.stage = '',
    this.batchCode = '',
    this.operatorName = '',
    this.status = '',
  });

  factory MonitoringModel.fromMap(Map<String, dynamic> map) {
    final batch =
        map['production_batches'] != null
            ? Map<String, dynamic>.from(map['production_batches'])
            : {};

    final user =
        batch['users'] != null
            ? Map<String, dynamic>.from(batch['users'])
            : {};

    return MonitoringModel(
      id: map['id'].toString(),

      batchId: map['batch_id'].toString(),

      recordedAt: DateTime.parse(map['recorded_at']),

      temperature:
          (map['temperature'] as num?)?.toDouble() ?? 0,

      ph:
          (map['ph'] as num?)?.toDouble() ?? 0,

      brix:
          (map['brix'] as num?)?.toDouble() ?? 0,

      volume:
          (map['volume'] as num?)?.toDouble() ?? 0,

      mixingTime: map['mixing_time'] ?? 0,

      fermentationTime:
          map['fermentation_time'] ?? 0,

      flowRate:
          (map['flow_rate'] as num?)?.toDouble() ?? 0,

      remarks: map['remarks'] ?? '',

      createdBy: map['created_by'].toString(),

      stage: (map['stage'] ?? '').toString(),

      batchCode: batch['batch_code'] ?? '',

      status: batch['status'] ?? '',

      operatorName: user['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batch_id': batchId,
      'recorded_at': recordedAt.toUtc().toIso8601String(),
      'temperature': temperature,
      'ph': ph,
      'brix': brix,
      'volume': volume,
      'mixing_time': mixingTime,
      'fermentation_time': fermentationTime,
      'flow_rate': flowRate,
      'remarks': remarks,
      'created_by': createdBy,
      // Hanya dikirim kalau terisi, supaya edit tidak menimpa tahap yang sudah tercatat.
      if (stage.isNotEmpty) 'stage': stage,
    };
  }
}