import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/batch/models/batch_model.dart';

class BatchRepository {
  BatchRepository();

  final SupabaseClient _client = SupabaseService.client;

  Future<List<BatchModel>> getBatches() async {
    final response = await _client
        .from('production_batches')
        .select('''
          *,
          users!production_batches_operator_id_fkey(
            full_name
          )
        ''')
        .order('created_at', ascending: false);

    return (response as List).map((e) {
      final map = Map<String, dynamic>.from(e);
      final user = map['users'] != null ? Map<String, dynamic>.from(map['users']) : {};
      map['operator_name'] = user['full_name'] ?? '';
      return BatchModel.fromMap(map);
    }).toList();
  }

  Future<BatchModel?> getBatchById(String id) async {
    final response = await _client
        .from('production_batches')
        .select('''
          *,
          users!production_batches_operator_id_fkey(
            full_name
          )
        ''')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    final map = Map<String, dynamic>.from(response);
    final user = map['users'] != null ? Map<String, dynamic>.from(map['users']) : {};
    map['operator_name'] = user['full_name'] ?? '';

    return BatchModel.fromMap(map);
  }

  Future<String> generateBatchCode() async {
    final year = DateTime.now().year;

    final response = await _client
        .from('production_batches')
        .select('batch_code')
        .like('batch_code', 'LOB-$year-%');

    if ((response as List).isEmpty) {
      return 'LOB-$year-001';
    }

    int maxNumber = 0;

    for (final item in response) {
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

  Future<void> createBatch(BatchModel batch) async {
    await _client.from('production_batches').insert({
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

  Future<void> updateBatch(BatchModel batch) async {
    await _client
        .from('production_batches')
        .update({
          'batch_code': batch.batchNumber,
          'production_date': batch.productionDate.toIso8601String(),
          'shift': batch.shift,
          'tank': batch.tank,
          'operator_id': batch.operatorId,
          'target_volume': batch.targetVolume,
          'current_volume': batch.actualVolume,
          'status': batch.status,
          'notes': batch.notes,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', batch.id);
  }

  Future<void> deleteBatch(String id) async {
    await _client
        .from('production_batches')
        .delete()
        .eq('id', id);
  }
}