import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../core/workflows/operator_workflow.dart';
import '../features/monitoring/models/monitoring_model.dart';

class MonitoringRepository {
  MonitoringRepository();

  final SupabaseClient _client = SupabaseService.client;

  Future<List<MonitoringModel>> getMonitoring() async {
    final response = await _client
        .from('production_logs')
        .select('''
          *,
          production_batches!production_logs_batch_id_fkey(
            id,
            batch_code,
            status,
            operator_id,
            users!production_batches_operator_id_fkey(
              full_name
            )
          )
        ''')
        .order('recorded_at', ascending: false);

    return (response as List)
        .map((e) => MonitoringModel.fromMap(
              Map<String, dynamic>.from(e),
            ))
        .toList();
  }

  Future<MonitoringModel?> getMonitoringById(
    String id,
  ) async {
    final response = await _client
        .from('production_logs')
        .select('''
          *,
          production_batches!production_logs_batch_id_fkey(
            id,
            batch_code,
            status,
            operator_id,
            users!production_batches_operator_id_fkey(
              full_name
            )
          )
        ''')
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return MonitoringModel.fromMap(
      Map<String, dynamic>.from(response),
    );
  }

  Future<void> createMonitoring(
    MonitoringModel monitoring,
  ) async {
    //
    // 1. ambil status batch sekarang = tahap produksi yang sedang dicatat
    //
    final batch = await _client
        .from('production_batches')
        .select('status')
        .eq('id', monitoring.batchId)
        .single();

    final currentStatus = batch['status'].toString();

    //
    // 2. simpan monitoring beserta tahapnya
    //
    await _client.from('production_logs').insert({
      ...monitoring.toMap(),
      'stage': currentStatus,
    });

    //
    // 3. hitung status berikutnya
    //
    final nextStatus = OperatorWorkflow.nextStatus(
      currentStatus,
    );

    //
    // 4. update status batch + volume terakhir
    //
    await _client.from('production_batches').update({
      'status': nextStatus,
      'current_volume': monitoring.volume,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq(
      'id',
      monitoring.batchId,
    );
  }

  Future<void> updateMonitoring(
    MonitoringModel monitoring,
  ) async {
    final updated = await _client
        .from('production_logs')
        .update(
          monitoring.toMap(),
        )
        .eq('id', monitoring.id)
        .select('id');

    // Kalau RLS memblokir, Supabase tidak error tapi tidak ada baris yang berubah.
    if (updated.isEmpty) {
      throw Exception(
        'Perubahan tidak tersimpan. Periksa izin (RLS) pada tabel production_logs.',
      );
    }
  }

  Future<void> deleteMonitoring(
    String id,
  ) async {
    await _client.from('production_logs').delete().eq('id', id);
  }
}