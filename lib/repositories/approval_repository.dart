import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../core/workflows/approval_workflow.dart';
import '../features/approval/models/approval_history_model.dart';
import '../features/approval/models/approval_model.dart';
import '../features/approval/models/production_history_model.dart';

class ApprovalRepository {
  ApprovalRepository();

  final SupabaseClient _client = SupabaseService.client;

  /// Batch yang menunggu keputusan Supervisor.
  Future<List<ApprovalModel>> getApprovalList() async {
    final batches = await _client
        .from('production_batches')
        .select()
        .eq('status', ApprovalWorkflow.waitingStatus)
        .order('production_date', ascending: false);

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

    return approvals;
  }

  /// Riwayat keputusan Supervisor (Approved / Rejected) dari tabel `approvals`.
  Future<List<ApprovalHistoryModel>> getApprovalHistoryList({
    String? statusFilter,
  }) async {
    var query = _client.from('approvals').select();

    if (statusFilter != null && statusFilter != 'Semua') {
      query = query.eq('approval_status', statusFilter);
    } else {
      query = query.neq('approval_status', 'Waiting');
    }

    final rows = await query.order('approved_at', ascending: false);

    final List<ApprovalHistoryModel> histories = [];
    for (final item in rows as List) {
      final approval = Map<String, dynamic>.from(item);

      final batch = await _client
          .from('production_batches')
          .select('batch_code, production_date, operator_id')
          .eq('id', approval['batch_id'])
          .maybeSingle();

      String operatorName = '-';
      if (batch != null && batch['operator_id'] != null) {
        final operator = await _client
            .from('users')
            .select('full_name')
            .eq('id', batch['operator_id'])
            .maybeSingle();
        operatorName = (operator?['full_name'] ?? '-').toString();
      }

      String supervisorName = '-';
      if (approval['supervisor_id'] != null) {
        final supervisor = await _client
            .from('users')
            .select('full_name')
            .eq('id', approval['supervisor_id'])
            .maybeSingle();
        supervisorName = (supervisor?['full_name'] ?? '-').toString();
      }

      histories.add(
        ApprovalHistoryModel.fromMap({
          ...approval,
          'batch_code': batch?['batch_code'],
          'production_date': batch?['production_date'],
          'operator_name': operatorName,
          'supervisor_name': supervisorName,
        }),
      );
    }

    return histories;
  }

  /// Riwayat produksi selesai dari tabel `production_history`.
  Future<List<ProductionHistoryModel>> getProductionHistoryList() async {
    final rows = await _client
        .from('production_history')
        .select()
        .order('completed_at', ascending: false);

    final List<ProductionHistoryModel> result = [];
    for (final item in rows as List) {
      final history = Map<String, dynamic>.from(item);

      final batch = await _client
          .from('production_batches')
          .select('batch_code, operator_id')
          .eq('id', history['batch_id'])
          .maybeSingle();

      String operatorName = '-';
      if (batch != null && batch['operator_id'] != null) {
        final operator = await _client
            .from('users')
            .select('full_name')
            .eq('id', batch['operator_id'])
            .maybeSingle();
        operatorName = (operator?['full_name'] ?? '-').toString();
      }

      String approvedByName = '-';
      if (history['approved_by'] != null) {
        final approver = await _client
            .from('users')
            .select('full_name')
            .eq('id', history['approved_by'])
            .maybeSingle();
        approvedByName = (approver?['full_name'] ?? '-').toString();
      }

      result.add(
        ProductionHistoryModel.fromMap({
          ...history,
          'batch_code': batch?['batch_code'],
          'operator_name': operatorName,
          'approved_by_name': approvedByName,
        }),
      );
    }

    return result;
  }

  /// APPROVE = produksi selesai:
  /// catat keputusan, ubah batch jadi Completed, masuk Production History.
  Future<void> approveBatch({
    required String batchId,
    required String supervisorId,
    String comments = '',
  }) async {
    final batch = await _getBatchWaitingApproval(batchId);

    final qc = await _client
        .from('quality_controls')
        .select('result')
        .eq('batch_id', batchId)
        .maybeSingle();

    final now = DateTime.now().toIso8601String();

    // 1. Catat keputusan Supervisor
    await _client.from('approvals').upsert({
      'batch_id': batchId,
      'supervisor_id': supervisorId,
      'approval_status': ApprovalWorkflow.approvedDecision,
      'comments': comments,
      'approved_at': now,
    }, onConflict: 'batch_id');

    // 2. Batch selesai
    await _client.from('production_batches').update({
      'status': ApprovalWorkflow.approve(),
      'updated_at': now,
    }).eq('id', batchId);

    // 3. Masuk Production History (sekali saja per batch)
    final existing = await _client
        .from('production_history')
        .select('id')
        .eq('batch_id', batchId)
        .maybeSingle();

    if (existing == null) {
      await _client.from('production_history').insert({
        'batch_id': batchId,
        'completed_at': now,
        'approved_by': supervisorId,
        'final_volume': batch['current_volume'],
        'qc_result': qc?['result'],
        'remarks': comments,
      });
    }
  }

  /// REJECT: catat keputusan dan ubah batch jadi Rejected.
  Future<void> rejectBatch({
    required String batchId,
    required String supervisorId,
    String comments = '',
  }) async {
    await _getBatchWaitingApproval(batchId);

    final now = DateTime.now().toIso8601String();

    await _client.from('approvals').upsert({
      'batch_id': batchId,
      'supervisor_id': supervisorId,
      'approval_status': ApprovalWorkflow.rejectedDecision,
      'comments': comments,
      'approved_at': now,
    }, onConflict: 'batch_id');

    await _client.from('production_batches').update({
      'status': ApprovalWorkflow.reject(),
      'updated_at': now,
    }).eq('id', batchId);
  }

  /// Memastikan batch memang masih menunggu approval
  /// (mencegah batch yang sama diproses dua kali).
  Future<Map<String, dynamic>> _getBatchWaitingApproval(String batchId) async {
    final batch = await _client
        .from('production_batches')
        .select('status, current_volume')
        .eq('id', batchId)
        .maybeSingle();

    if (batch == null) {
      throw Exception('Batch tidak ditemukan.');
    }
    if (batch['status'] != ApprovalWorkflow.waitingStatus) {
      throw Exception('Batch ini sudah diproses sebelumnya.');
    }

    debugPrint('Approval batch $batchId, status: ${batch['status']}');
    return Map<String, dynamic>.from(batch);
  }
}