import 'package:flutter/material.dart';

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

  List<ApprovalModel> get approvals =>
      List.unmodifiable(_approvals);

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

  Future<bool> approveBatch(String batchId) async {
    return _executeAction(() async {
      await _repository.approveBatch(batchId);
    });
  }

  Future<bool> rejectBatch(String batchId) async {
    return _executeAction(() async {
      await _repository.rejectBatch(batchId);
    });
  }

  Future<bool> completeBatch(String batchId) async {
    return _executeAction(() async {
      await _repository.completeBatch(batchId);
    });
  }

  Future<void> refresh() async {
    await loadApprovals();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _executeAction(
    Future<void> Function() action,
  ) async {
    _setLoading(true);

    try {
      _errorMessage = null;

      await action();

      _approvals = await _repository.getApprovalList();

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