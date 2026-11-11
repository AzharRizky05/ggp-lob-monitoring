import '../core/services/api_client.dart';
import '../features/batch/models/batch_model.dart';

/// Repository Production Batch.
/// Seluruh data diambil lewat endpoint: /rest/v1/production_batches
class BatchRepository {
  BatchRepository();

  final ApiClient _api = ApiClient.instance;

  static const String _table = '/production_batches';

  /// Kolom batch + nama operator (relasi ke tabel users)
  static const String _select =
      '*,users!production_batches_operator_id_fkey(full_name)';

  BatchModel _toModel(dynamic item) {
    final map = Map<String, dynamic>.from(item as Map);
    final user = map['users'] != null
        ? Map<String, dynamic>.from(map['users'] as Map)
        : <String, dynamic>{};
    map['operator_name'] = user['full_name'] ?? '';
    return BatchModel.fromMap(map);
  }

  /// GET /production_batches?select=...&order=created_at.desc
  Future<List<BatchModel>> getBatches() async {
    final response = await _api.get(
      _table,
      query: {'select': _select, 'order': 'created_at.desc'},
    );

    return (response as List).map(_toModel).toList();
  }

  /// GET /production_batches?id=eq.{id}
  Future<BatchModel?> getBatchById(String id) async {
    final response = await _api.get(
      _table,
      query: {'select': _select, 'id': 'eq.$id', 'limit': 1},
    );

    final list = response as List;
    if (list.isEmpty) return null;

    return _toModel(list.first);
  }

  /// GET /production_batches?select=batch_code&batch_code=like.LOB-{tahun}-*
  Future<String> generateBatchCode() async {
    final year = DateTime.now().year;

    final response = await _api.get(
      _table,
      query: {'select': 'batch_code', 'batch_code': 'like.LOB-$year-*'},
    );

    final list = response as List;
    if (list.isEmpty) {
      return 'LOB-$year-001';
    }

    int maxNumber = 0;

    for (final item in list) {
      final code = item['batch_code']?.toString() ?? '';
      final parts = code.split('-');

      if (parts.length == 3) {
        final number = int.tryParse(parts[2]) ?? 0;
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    final nextNumber = (maxNumber + 1).toString().padLeft(3, '0');

    return 'LOB-$year-$nextNumber';
  }

  /// Workflow status produksi
  String getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'Draft':
        return 'Preparation';

      case 'Preparation':
        return 'Mixing';

      case 'Mixing':
        return 'Fermentation';

      case 'Fermentation':
        return 'Filtering';

      case 'Filtering':
        return 'Packaging';

      case 'Packaging':
        return 'QC Pending';

      // Tahap QC & Approval tidak diubah oleh Monitoring
      case 'QC Pending':
      case 'QC Passed':
      case 'QC Failed':
      case 'Waiting Approval':
      case 'Approved':
      case 'Completed':
      case 'Rejected':
      default:
        return currentStatus;
    }
  }

  /// POST /production_batches
  Future<void> createBatch(BatchModel batch) async {
    await _api.post(_table, data: {
      'id': batch.id,
      'batch_code': batch.batchNumber,
      'production_date': batch.productionDate.toIso8601String(),
      'shift': batch.shift,
      'tank': batch.tank,
      'operator_id': batch.operatorId,
      'target_volume': batch.targetVolume,
      'current_volume': batch.actualVolume,
      'status': batch.status,
      'notes': batch.notes,
    });
  }

  /// PATCH /production_batches?id=eq.{id}
  Future<void> updateBatch(BatchModel batch) async {
    final updated = await _api.patch(
      _table,
      query: {'id': 'eq.${batch.id}', 'select': 'id'},
      data: {
        'batch_code': batch.batchNumber,
        'production_date': batch.productionDate.toIso8601String(),
        'shift': batch.shift,
        'tank': batch.tank,
        'operator_id': batch.operatorId,
        'target_volume': batch.targetVolume,
        'current_volume': batch.actualVolume,
        'status': batch.status,
        'notes': batch.notes,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
    );

    // Kalau RLS memblokir, endpoint tidak error tapi tidak ada baris yang berubah.
    if (updated.isEmpty) {
      throw Exception(
        'Perubahan tidak tersimpan. Periksa izin (RLS) pada tabel production_batches.',
      );
    }
  }

  /// DELETE /production_batches?id=eq.{id}
  Future<void> deleteBatch(String id) async {
    try {
      final deleted = await _api.delete(
        _table,
        query: {'id': 'eq.$id', 'select': 'id'},
      );

      if (deleted.isEmpty) {
        throw Exception(
          'Batch tidak terhapus. Periksa izin (RLS) pada tabel production_batches.',
        );
      }
    } on ApiException catch (e) {
      // 23503 = masih direferensikan tabel lain (monitoring, QC, approval).
      if (e.code == '23503') {
        throw Exception(
          'Batch tidak dapat dihapus karena sudah memiliki data monitoring, QC, atau approval.',
        );
      }
      throw Exception(e.message);
    }
  }
}