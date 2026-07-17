import 'package:flutter/material.dart';

import '../features/approval/models/approval_model.dart';
import '../features/approval/models/approval_history_model.dart';
import '../features/approval/models/production_history_model.dart';
import '../repositories/approval_repository.dart';

class ApprovalProvider extends ChangeNotifier {
  ApprovalProvider() {
    loadApprovals();
  }

  final ApprovalRepository _repository = ApprovalRepository();

  bool _loading = false;
  bool _historyLoading = false;
  bool _processing = false;
  String? _errorMessage;

  String _historyStatusFilter = 'Semua';

  List<ApprovalModel> _approvals = [];
  List<ApprovalHistoryModel> _histories = [];
  List<ProductionHistoryModel> _productionHistory = [];

  bool get loading => _loading;

  bool get historyLoading => _historyLoading;

  bool get processing => _processing;

  String? get errorMessage => _errorMessage;

  String get historyStatusFilter => _historyStatusFilter;

  List<ApprovalModel> get approvals => _approvals;

  List<ApprovalHistoryModel> get histories => _histories;

  List<ProductionHistoryModel> get productionHistory => _productionHistory;

  /// Batch QC Passed (butuh Approve/Reject) + Approved (butuh Complete)
  Future<void> loadApprovals() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _approvals = await _repository.getPendingApprovals();
    } catch (e) {
      _errorMessage = e.toString();
      _approvals = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadApprovalHistory({String status = 'Semua'}) async {
    _historyLoading = true;
    _errorMessage = null;
    _historyStatusFilter = status;
    notifyListeners();

    try {
      _histories = await _repository.getApprovalHistory(status: status);
    } catch (e) {
      _errorMessage = e.toString();
      _histories = [];
    }

    _historyLoading = false;
    notifyListeners();
  }

  Future<void> loadProductionHistory() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _productionHistory = await _repository.getProductionHistory();
    } catch (e) {
      _errorMessage = e.toString();
      _productionHistory = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> approveBatch({
    required String batchId,
    required String supervisorId,
    String? notes,
  }) async {
    try {
      _processing = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.approveBatch(
        batchId: batchId,
        supervisorId: supervisorId,
        notes: notes,
      );

      _approvals = await _repository.getPendingApprovals();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _processing = false;
      notifyListeners();
    }
  }

  Future<bool> rejectBatch({
    required String batchId,
    required String supervisorId,
    String? notes,
  }) async {
    try {
      _processing = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.rejectBatch(
        batchId: batchId,
        supervisorId: supervisorId,
        notes: notes,
      );

      _approvals = await _repository.getPendingApprovals();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _processing = false;
      notifyListeners();
    }
  }

  Future<bool> completeBatch({
    required String batchId,
    required String supervisorId,
    String? remarks,
  }) async {
    try {
      _processing = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.completeBatch(
        batchId: batchId,
        supervisorId: supervisorId,
        remarks: remarks,
      );

      _approvals = await _repository.getPendingApprovals();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _processing = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadApprovals();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}