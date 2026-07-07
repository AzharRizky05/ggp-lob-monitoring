class MaintenanceModel {
  final String id;
  final String scheduleCode;
  final String assetName;
  final DateTime scheduleDate;
  final String personInCharge;
  final String status;
  final DateTime createdAt;

  const MaintenanceModel({
    required this.id,
    required this.scheduleCode,
    required this.assetName,
    required this.scheduleDate,
    required this.personInCharge,
    required this.status,
    required this.createdAt,
  });

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      id: map['id'],
      scheduleCode: map['schedule_code'],
      assetName: map['asset_name'],
      scheduleDate: DateTime.parse(map['schedule_date']),
      personInCharge: map['person_in_charge'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule_code': scheduleCode,
      'asset_name': assetName,
      'schedule_date': scheduleDate.toIso8601String(),
      'person_in_charge': personInCharge,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}