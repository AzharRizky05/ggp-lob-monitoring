class BatchModel {
  final String id;

  final String batchNumber;

  final DateTime productionDate;

  final String shift;

  final String tank;

  final String operatorId;

  final String operatorName;

  final double targetVolume;

  final double actualVolume;

  final String status;

  final String notes;

  final DateTime createdAt;

  final DateTime updatedAt;

  const BatchModel({
    required this.id,
    required this.batchNumber,
    required this.productionDate,
    required this.shift,
    required this.tank,
    required this.operatorId,
    required this.operatorName,
    required this.targetVolume,
    required this.actualVolume,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BatchModel.fromMap(Map<String, dynamic> map) {
    return BatchModel(
      id: map['id']?.toString() ?? '',

      // 1. Perubahan batch_number menjadi batch_code
      batchNumber: map['batch_code']?.toString() ?? '',

      productionDate: map['production_date'] != null
          ? DateTime.parse(map['production_date'].toString())
          : DateTime.now(),

      shift: map['shift']?.toString() ?? '',

      tank: map['tank']?.toString() ?? '',

      operatorId: map['operator_id']?.toString() ?? '',

      operatorName: map['operator_name']?.toString() ?? '',

      targetVolume:
          (map['target_volume'] as num?)?.toDouble() ?? 0,

      // 1. Perubahan actual_volume menjadi current_volume
      actualVolume:
          (map['current_volume'] as num?)?.toDouble() ?? 0,

      status: map['status']?.toString() ?? 'Draft',

      notes: map['notes']?.toString() ?? '',

      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : DateTime.now(),

      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 2. Perubahan key map menjadi batch_code
      'batch_code': batchNumber,
      'production_date': productionDate.toIso8601String(),
      'shift': shift,
      'tank': tank,
      'operator_id': operatorId,
      'target_volume': targetVolume,
      // 2. Perubahan key map menjadi current_volume
      'current_volume': actualVolume,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Alias agar UI lama tetap berjalan
  String get batchCode => batchNumber;

  BatchModel copyWith({
    String? id,
    String? batchNumber,
    DateTime? productionDate,
    String? shift,
    String? tank,
    String? operatorId,
    String? operatorName,
    double? targetVolume,
    double? actualVolume,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BatchModel(
      id: id ?? this.id,
      batchNumber: batchNumber ?? this.batchNumber,
      productionDate: productionDate ?? this.productionDate,
      shift: shift ?? this.shift,
      tank: tank ?? this.tank,
      operatorId: operatorId ?? this.operatorId,
      operatorName: operatorName ?? this.operatorName,
      targetVolume: targetVolume ?? this.targetVolume,
      actualVolume: actualVolume ?? this.actualVolume,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}