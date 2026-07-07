class QcModel {
  final String id;

  final String batchId;

  final String qcUser;

  final DateTime inspectionDate;

  final double ph;

  final double density;

  final String color;

  final String odor;

  final String nutrientContent;

  final String laboratoryResult;

  final int qcScore;

  final String result;

  final String notes;

  /// Data tambahan hasil JOIN
  final String batchCode;

  final String qcName;

  final String status;

  const QcModel({
    required this.id,
    required this.batchId,
    required this.qcUser,
    required this.inspectionDate,
    required this.ph,
    required this.density,
    required this.color,
    required this.odor,
    required this.nutrientContent,
    required this.laboratoryResult,
    required this.qcScore,
    required this.result,
    required this.notes,
    this.batchCode = '',
    this.qcName = '',
    this.status = '',
  });

  factory QcModel.fromMap(Map<String, dynamic> map) {
    final batch =
        map['production_batches'] != null
            ? Map<String, dynamic>.from(map['production_batches'])
            : {};

    final user =
        map['users'] != null
            ? Map<String, dynamic>.from(map['users'])
            : {};

    return QcModel(
      id: map['id'].toString(),

      batchId: map['batch_id'].toString(),

      qcUser: map['qc_user'].toString(),

      inspectionDate: DateTime.parse(
        map['inspection_date'],
      ),

      ph: (map['ph'] as num?)?.toDouble() ?? 0,

      density:
          (map['density'] as num?)?.toDouble() ?? 0,

      color: map['color'] ?? '',

      odor: map['odor'] ?? '',

      nutrientContent:
          map['nutrient_content'] ?? '',

      laboratoryResult:
          map['laboratory_result'] ?? '',

      qcScore: map['qc_score'] ?? 0,

      result: map['result'] ?? '',

      notes: map['notes'] ?? '',

      batchCode: batch['batch_code'] ?? '',

      status: batch['status'] ?? '',

      qcName: user['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batch_id': batchId,
      'qc_user': qcUser,
      'inspection_date':
          inspectionDate.toIso8601String(),
      'ph': ph,
      'density': density,
      'color': color,
      'odor': odor,
      'nutrient_content': nutrientContent,
      'laboratory_result': laboratoryResult,
      'qc_score': qcScore,
      'result': result,
      'notes': notes,
    };
  }

  QcModel copyWith({
    String? id,
    String? batchId,
    String? qcUser,
    DateTime? inspectionDate,
    double? ph,
    double? density,
    String? color,
    String? odor,
    String? nutrientContent,
    String? laboratoryResult,
    int? qcScore,
    String? result,
    String? notes,
    String? batchCode,
    String? qcName,
    String? status,
  }) {
    return QcModel(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      qcUser: qcUser ?? this.qcUser,
      inspectionDate:
          inspectionDate ?? this.inspectionDate,
      ph: ph ?? this.ph,
      density: density ?? this.density,
      color: color ?? this.color,
      odor: odor ?? this.odor,
      nutrientContent:
          nutrientContent ?? this.nutrientContent,
      laboratoryResult:
          laboratoryResult ?? this.laboratoryResult,
      qcScore: qcScore ?? this.qcScore,
      result: result ?? this.result,
      notes: notes ?? this.notes,
      batchCode: batchCode ?? this.batchCode,
      qcName: qcName ?? this.qcName,
      status: status ?? this.status,
    );
  }
}