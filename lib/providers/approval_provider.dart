import 'package:flutter/material.dart';

import '../features/approval/models/approval_history_model.dart';
import '../features/approval/models/approval_model.dart';
import '../repositories/approval_repository.dart';

class ApprovalProvider extends ChangeNotifier {
  ApprovalProvider() {
    loadApprovals();
  }

  final ApprovalRepository _repository = ApprovalRepository();

  bool _loading = false;
  String? _errorMessage;
  List<ApprovalModel> _approvals = [];

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<ApprovalModel> get approvals => List.unmodifiable(_approvals);

  bool _historyLoading = false;
  String? _historyErrorMessage;
  List<ApprovalHistoryModel> _histories = [];
  String _historyStatusFilter = 'Semua';

  bool get historyLoading => _historyLoading;
  String? get historyErrorMessage => _historyErrorMessage;
  List<ApprovalHistoryModel> get histories => List.unmodifiable(_histories);
  String get historyStatusFilter => _historyStatusFilter;

  Future<void> loadApprovals() async {
    _setLoading(true);
    try {
      _errorMessage = null;
      _approvals = await _repository.getApprovalList();
    } catch (e) {
      _approvals = [];
      _errorMessage = e.toString();
      debugPrint("ApprovalProvider.loadApprovals: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadApprovalHistory({String? status}) async {
    _historyLoading = true;
    if (status != null) _historyStatusFilter = status;
    notifyListeners();

    try {
      _historyErrorMessage = null;
      _histories = await _repository.getApprovalHistoryList(
        statusFilter: _historyStatusFilter,
      );
    } catch (e) {
      _histories = [];
      _historyErrorMessage = e.toString();
      debugPrint("ApprovalProvider.loadApprovalHistory: $e");
    } finally {
      _historyLoading = false;
      notifyListeners();
    }
  }

  Future<bool> approveBatch({
    required String batchId,
    required String supervisorId,
    String comments = '',
  }) {
    return _executeAction(() async {
      await _repository.approveBatch(
        batchId: batchId,
        supervisorId: supervisorId,
        comments: comments,
      );
    });
  }

  Future<bool> rejectBatch({
    required String batchId,
    required String supervisorId,
    String comments = '',
  }) {
    return _executeAction(() async {
      await _repository.rejectBatch(
        batchId: batchId,
        supervisorId: supervisorId,
        comments: comments,
      );
    });
  }

  Future<void> refresh() async => loadApprovals();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _executeAction(Future<void> Function() action) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      await action();

      _approvals = await _repository.getApprovalList();
      if (_histories.isNotEmpty || _historyStatusFilter != 'Semua') {
        _histories = await _repository.getApprovalHistoryList(
          statusFilter: _historyStatusFilter,
        );
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("ApprovalProvider: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}