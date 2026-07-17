import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/approval/models/approval_model.dart';
import '../features/approval/models/approval_history_model.dart';
import '../features/approval/models/production_history_model.dart';

class ApprovalRepository {
  ApprovalRepository();

  final SupabaseClient _client = SupabaseService.client;

  /// Batch dengan status QC Passed (belum diputuskan) ATAU Approved (menunggu Complete)
  Future<List<ApprovalModel>> getPendingApprovals() async {
    final response = await _client
        .from('production_batches')
        .select('''
          *,
          users!production_batches_operator_id_fkey(
            full_name
          ),
          quality_controls(*)
        ''')
        .inFilter('status', ['QC Passed', 'Approved'])
        .order('updated_at', ascending: false);

    return (response as List).map((e) {
      final map = Map<String, dynamic>.from(e);
      return ApprovalModel.fromMap(map);
    }).toList();
  }

  Future<ApprovalModel?> getPendingApprovalByBatchId(String batchId) async {
    final response = await _client
        .from('production_batches')
        .select('''
          *,
          users!production_batches_operator_id_fkey(
            full_name
          ),
          quality_controls(*)
        ''')
        .eq('id', batchId)
        .maybeSingle();

    if (response == null) return null;

    return ApprovalModel.fromMap(Map<String, dynamic>.from(response));
  }

  /// Riwayat keputusan Approve / Reject / Completed
  /// Status yang ditampilkan diambil dari status BATCH saat ini (bukan approval_status),
  /// supaya filter 'Completed' juga bisa jalan (approvals.approval_status tidak pernah
  /// berubah jadi 'Completed', yang berubah adalah production_batches.status).
  Future<List<ApprovalHistoryModel>> getApprovalHistory({
    String status = 'Semua',
  }) async {
    final response = await _client
        .from('approvals')
        .select('''
          *,
          production_batches!approvals_batch_id_fkey(
            batch_code,
            production_date,
            status,
            users!production_batches_operator_id_fkey(
              full_name
            )
          ),
          users!approvals_supervisor_id_fkey(
            full_name
          )
        ''')
        .neq('approval_status', 'Waiting')
        .order('approved_at', ascending: false);

    final all = (response as List).map((e) {
      final map = Map<String, dynamic>.from(e);

      final batch = map['production_batches'] != null
          ? Map<String, dynamic>.from(map['production_batches'])
          : <String, dynamic>{};

      final operator = batch['users'] != null
          ? Map<String, dynamic>.from(batch['users'])
          : <String, dynamic>{};

      final supervisor = map['users'] != null
          ? Map<String, dynamic>.from(map['users'])
          : <String, dynamic>{};

      final flat = {
        'id': map['id'],
        'batch_id': map['batch_id'],
        'batch_code': batch['batch_code'],
        'production_date': batch['production_date'],
        'operator_name': operator['full_name'],
        'supervisor_id': map['supervisor_id'],
        'supervisor_name': supervisor['full_name'],
        'status': batch['status'] ?? map['approval_status'],
        'notes': map['comments'],
        'approved_at': map['approved_at'],
      };

      return ApprovalHistoryModel.fromMap(flat);
    }).toList();

    if (status == 'Semua') return all;

    return all.where((item) => item.status == status).toList();
  }

  /// Arsip batch yang sudah Completed dari tabel production_history
  Future<List<ProductionHistoryModel>> getProductionHistory() async {
    final response = await _client
        .from('production_history')
        .select('''
          *,
          production_batches!production_history_batch_id_fkey(
            batch_code,
            production_date,
            shift,
            tank,
            users!production_batches_operator_id_fkey(
              full_name
            )
          ),
          users!production_history_approved_by_fkey(
            full_name
          )
        ''')
        .order('completed_at', ascending: false);

    return (response as List).map((e) {
      final map = Map<String, dynamic>.from(e);

      final batch = map['production_batches'] != null
          ? Map<String, dynamic>.from(map['production_batches'])
          : <String, dynamic>{};

      final operator = batch['users'] != null
          ? Map<String, dynamic>.from(batch['users'])
          : <String, dynamic>{};

      final approver = map['users'] != null
          ? Map<String, dynamic>.from(map['users'])
          : <String, dynamic>{};

      final flat = {
        ...map,
        'batch_code': batch['batch_code'],
        'production_date': batch['production_date'],
        'shift': batch['shift'],
        'tank': batch['tank'],
        'operator_name': operator['full_name'],
        'approver_name': approver['full_name'],
      };

      return ProductionHistoryModel.fromMap(flat);
    }).toList();
  }

  /// Supervisor menyetujui batch
  Future<void> approveBatch({
    required String batchId,
    required String supervisorId,
    String? notes,
  }) async {
    final now = DateTime.now().toIso8601String();

    await _client.from('approvals').upsert({
      'batch_id': batchId,
      'supervisor_id': supervisorId,
      'approval_status': 'Approved',
      'comments': notes,
      'approved_at': now,
    }, onConflict: 'batch_id');

    await _client
        .from('production_batches')
        .update({
          'status': 'Approved',
          'updated_at': now,
        })
        .eq('id', batchId);
  }

  /// Supervisor menolak batch (notes opsional — bisa reject cepat lewat ikon,
  /// atau reject detail dengan catatan lewat dialog)
  Future<void> rejectBatch({
    required String batchId,
    required String supervisorId,
    String? notes,
  }) async {
    final now = DateTime.now().toIso8601String();

    await _client.from('approvals').upsert({
      'batch_id': batchId,
      'supervisor_id': supervisorId,
      'approval_status': 'Rejected',
      'comments': notes,
      'approved_at': now,
    }, onConflict: 'batch_id');

    await _client
        .from('production_batches')
        .update({
          'status': 'Rejected',
          'updated_at': now,
        })
        .eq('id', batchId);
  }

  /// Supervisor menyelesaikan batch (Approved -> Completed).
  /// final_volume & qc_result diambil otomatis dari data batch & QC yang sudah ada,
  /// supervisor tidak perlu input ulang manual.
  Future<void> completeBatch({
    required String batchId,
    required String supervisorId,
    String? remarks,
  }) async {
    final now = DateTime.now().toIso8601String();

    final batch = await _client
        .from('production_batches')
        .select('current_volume')
        .eq('id', batchId)
        .single();

    final qc = await _client
        .from('quality_controls')
        .select('result')
        .eq('batch_id', batchId)
        .maybeSingle();

    final finalVolume = (batch['current_volume'] as num?)?.toDouble() ?? 0.0;
    final qcResult = qc?['result']?.toString() ?? '-';

    await _client
        .from('production_batches')
        .update({
          'status': 'Completed',
          'updated_at': now,
        })
        .eq('id', batchId);

    await _client.from('production_history').insert({
      'batch_id': batchId,
      'completed_at': now,
      'approved_by': supervisorId,
      'final_volume': finalVolume,
      'qc_result': qcResult,
      'remarks': remarks,
    });
  }
}