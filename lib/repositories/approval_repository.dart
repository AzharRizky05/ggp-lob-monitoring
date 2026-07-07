import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/approval/models/approval_model.dart';

class ApprovalRepository {
  ApprovalRepository();

  final SupabaseClient _client = SupabaseService.client;

  Future<List<ApprovalModel>> getApprovalList() async {
    final batches = await _client
        .from('production_batches')
        .select()
        .eq('status', 'QC Passed')
        .order(
          'production_date',
          ascending: false,
        );

    final List<ApprovalModel> approvals = [];
    for (final item in batches as List) {
      final batch = Map<String, dynamic>.from(item);

      final user = await _client
          .from('users')
          .select('full_name')
          .eq('id', batch['operator_id'])
          .maybeSingle();

      final qc = await _client
          .from('quality_controls')
          .select('id, ph, result, notes, inspection_date')
          .eq('batch_id', batch['id'])
          .maybeSingle();

      approvals.add(
        ApprovalModel.fromMap({
          ...batch,
          'users': user,
          'quality_controls': qc,
        }),
      );
    }

    debugPrint("========== TOTAL APPROVAL ==========");
    debugPrint(approvals.length.toString());

    for (final item in approvals) {
      debugPrint(
        "${item.batchCode} | ${item.status} | ${item.operatorName} | ${item.qcResult}",
      );
    }

    return approvals;
  }

  Future<ApprovalModel?> getApprovalByBatch(
    String batchId,
  ) async {
    final batch = await _client
        .from('production_batches')
        .select()
        .eq('id', batchId)
        .maybeSingle();

    if (batch == null) {
      return null;
    }

    final user = await _client
        .from('users')
        .select('full_name')
        .eq('id', batch['operator_id'])
        .maybeSingle();

    final qc = await _client
        .from('quality_controls')
        .select('id, ph, result, notes, inspection_date')
        .eq('batch_id', batchId)
        .maybeSingle();

    return ApprovalModel.fromMap({
      ...Map<String, dynamic>.from(batch),
      'users': user,
      'quality_controls': qc,
    });
  }

  Future<void> approveBatch(
    String batchId,
  ) async {
    await _client
        .from('production_batches')
        .update({
          'status': 'Approved',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', batchId);
  }

  Future<void> rejectBatch(
    String batchId,
  ) async {
    await _client
        .from('production_batches')
        .update({
          'status': 'Rejected',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', batchId);
  }

  Future<void> completeBatch(
    String batchId,
  ) async {
    await _client
        .from('production_batches')
        .update({
          'status': 'Completed',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', batchId);
  }
}