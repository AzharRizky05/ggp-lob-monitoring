import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/reports/models/report_model.dart';

class ReportRepository {
  ReportRepository();

  final SupabaseClient _client = SupabaseService.client;

  /// Seluruh batch dengan tanggal produksi pada [year], lengkap dengan
  /// hasil QC, volume akhir, dan nama supervisor.
  Future<List<ReportRow>> getBatchesByYear(int year) async {
    final response = await _client
        .from('production_batches')
        .select('''
          id, batch_code, production_date, shift, tank,
          current_volume, status, operator_id,
          users!production_batches_operator_id_fkey(full_name)
        ''')
        .gte('production_date', '$year-01-01')
        .lte('production_date', '$year-12-31')
        .order('production_date', ascending: false);

    final batches = (response as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (batches.isEmpty) return [];

    final qcByBatch = await _loadIndexed('quality_controls', 'batch_id, result');
    final approvalByBatch = await _loadIndexed(
      'approvals',
      'batch_id, supervisor_id, approval_status',
    );
    final historyByBatch = await _loadIndexed(
      'production_history',
      'batch_id, final_volume, approved_by',
    );
    final userNames = await _loadIndexed('users', 'id, full_name', key: 'id');

    return batches.map((batch) {
      final id = batch['id'].toString();

      // Nama operator: dari relasi, cadangannya dari tabel users.
      final user = batch['users'];
      String operatorName = user is Map ? (user['full_name'] ?? '').toString() : '';
      if (operatorName.isEmpty) {
        operatorName =
            (userNames[batch['operator_id']?.toString()]?['full_name'] ?? '-')
                .toString();
      }

      final history = historyByBatch[id];
      final approval = approvalByBatch[id];

      final supervisorId = history?['approved_by'] ?? approval?['supervisor_id'];
      final supervisorName = supervisorId == null
          ? '-'
          : (userNames[supervisorId.toString()]?['full_name'] ?? '-').toString();

      // Volume akhir dari production_history, cadangannya volume batch.
      final historyVolume = (history?['final_volume'] as num?)?.toDouble();
      final batchVolume = (batch['current_volume'] as num?)?.toDouble() ?? 0;
      final volume =
          (historyVolume != null && historyVolume > 0) ? historyVolume : batchVolume;

      return ReportRow(
        batchId: id,
        batchCode: (batch['batch_code'] ?? '-').toString(),
        operatorName: operatorName,
        productionDate:
            DateTime.tryParse((batch['production_date'] ?? '').toString()),
        shift: (batch['shift'] ?? '-').toString(),
        tank: (batch['tank'] ?? '-').toString(),
        volume: volume,
        qcResult: (qcByBatch[id]?['result'] ?? '-').toString(),
        status: (batch['status'] ?? '').toString(),
        supervisorName: supervisorName,
      );
    }).toList();
  }

  /// Memuat satu tabel dan mengindeksnya berdasarkan kolom [key].
  /// Kalau gagal, laporan tetap tampil (hanya kolom terkait yang kosong).
  Future<Map<String, Map<String, dynamic>>> _loadIndexed(
    String table,
    String columns, {
    String key = 'batch_id',
  }) async {
    try {
      final response = await _client.from(table).select(columns);
      return {
        for (final row in response as List)
          (row as Map)[key].toString(): Map<String, dynamic>.from(row),
      };
    } catch (e) {
      debugPrint('ReportRepository._loadIndexed($table): $e');
      return {};
    }
  }
}