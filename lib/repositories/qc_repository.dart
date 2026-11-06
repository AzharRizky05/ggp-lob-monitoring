import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../core/services/supabase_service.dart';
import '../features/quality_control/models/qc_model.dart';

import '../core/workflows/qc_workflow.dart';

class QcRepository {
  QcRepository();

  final SupabaseClient _client = SupabaseService.client;

  Future<List<QcModel>> getQualityControls() async {
    final response = await _client
        .from('quality_controls')
        .select('''
          *,
          production_batches!quality_controls_batch_id_fkey(
            id,
            batch_code,
            status
          ),
          users!quality_controls_qc_user_fkey(
            full_name
          )
        ''')
        .order('inspection_date', ascending: false);

    return (response as List)
        .map((e) => QcModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<QcModel?> getQcById(String id) async {
    final response = await _client
        .from('quality_controls')
        .select('''
          *,
          production_batches!quality_controls_batch_id_fkey(
            id,
            batch_code,
            status
          ),
          users!quality_controls_qc_user_fkey(
            full_name
          )
        ''')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return QcModel.fromMap(Map<String, dynamic>.from(response));
  }

  Future<void> createQc(QcModel qc) async {
    debugPrint("========== INSERT QC ==========");
    debugPrint(qc.toMap().toString());

    try {
      await _client
          .from('quality_controls')
          .insert(qc.toMap());

      debugPrint("QC BERHASIL DISIMPAN");

      await _updateBatchStatus(qc);

      debugPrint("SEMUA PROSES BERHASIL");
    } catch (e, s) {
      debugPrint("========== QC ERROR ==========");
      debugPrint(e.toString());
      debugPrint(s.toString());

      rethrow;
    }
  }

  Future<void> updateQc(QcModel qc) async {
    debugPrint("========== UPDATE QC ==========");
    debugPrint(qc.toMap().toString());

    await _client
        .from('quality_controls')
        .update(qc.toMap())
        .eq('id', qc.id);

    await _updateBatchStatus(qc);
  }

  Future<void> _updateBatchStatus(QcModel qc) async {
    String nextStatus;

    switch (qc.result.toUpperCase()) {
      case "PASSED":
        nextStatus = QcWorkflow.pass();   // "Waiting Approval"
        break;
      case "FAILED":
        nextStatus = QcWorkflow.fail();   // "QC Failed"
        break;
      default:
        nextStatus = "QC Pending";
    }

    final result = await _client
        .from('production_batches')
        .update({
          'status': nextStatus,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', qc.batchId)
        .select();

    debugPrint(result.toString());
  }

  Future<void> deleteQc(String id) async {
    await _client.from('quality_controls').delete().eq('id', id);
  }
}