import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/history/models/history_model.dart';

class HistoryRepository {
  HistoryRepository();

  final SupabaseClient _client = SupabaseService.client;

  Future<List<HistoryModel>> getHistories() async {
    final rows = await _client
        .from('production_history')
        .select()
        .order('completed_at', ascending: false);

    final histories = (rows as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (histories.isEmpty) return [];

    // 1. Data batch (kode, tanggal, shift, tank, target, operator)
    final batchIds = histories
        .map((h) => h['batch_id'])
        .where((id) => id != null)
        .toSet()
        .toList();

    final Map<String, Map<String, dynamic>> batchById = {};
    if (batchIds.isNotEmpty) {
      final batchRows = await _client
          .from('production_batches')
          .select(
            'id, batch_code, production_date, shift, tank, target_volume, operator_id',
          )
          .inFilter('id', batchIds);

      for (final row in batchRows as List) {
        final batch = Map<String, dynamic>.from(row);
        batchById[batch['id'].toString()] = batch;
      }
    }

    // 2. Nama operator dan supervisor
    final userIds = <String>{
      for (final h in histories)
        if (h['approved_by'] != null) h['approved_by'].toString(),
      for (final b in batchById.values)
        if (b['operator_id'] != null) b['operator_id'].toString(),
    };

    final Map<String, String> userNames = {};
    if (userIds.isNotEmpty) {
      final userRows = await _client
          .from('users')
          .select('id, full_name')
          .inFilter('id', userIds.toList());

      for (final row in userRows as List) {
        userNames[row['id'].toString()] = (row['full_name'] ?? '-').toString();
      }
    }

    // 3. Gabungkan
    return histories.map((h) {
      final batch =
          batchById[h['batch_id']?.toString()] ?? <String, dynamic>{};

      return HistoryModel.fromMap({
        ...h,
        'batch_code': batch['batch_code'],
        'production_date': batch['production_date'],
        'shift': batch['shift'],
        'tank': batch['tank'],
        'target_volume': batch['target_volume'],
        'operator_name': userNames[batch['operator_id']?.toString()],
        'approved_by_name': userNames[h['approved_by']?.toString()],
      });
    }).toList();
  }
}