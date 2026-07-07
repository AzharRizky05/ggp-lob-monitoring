class BatchWorkflow {
  BatchWorkflow._();

  /// Workflow produksi LOB
  static const List<String> workflow = [
    'Draft',
    'Preparation',
    'Mixing',
    'Fermentation',
    'Filtering',
    'Packaging',
    'QC Pending',
  ];

  /// Status setelah Operator
  static const String qcPassed = 'QC Passed';
  static const String approved = 'Approved';
  static const String completed = 'Completed';
  static const String rejected = 'Rejected';

  /// ==========================================================
  /// Operator hanya boleh sampai QC Pending
  /// ==========================================================
  static String nextStatus(String currentStatus) {
    final index = workflow.indexOf(currentStatus);

    if (index == -1) {
      return workflow.first;
    }

    if (index >= workflow.length - 1) {
      return workflow.last;
    }

    return workflow[index + 1];
  }

  /// ==========================================================
  /// Status sebelumnya
  /// ==========================================================
  static String previousStatus(String currentStatus) {
    final index = workflow.indexOf(currentStatus);

    if (index <= 0) {
      return workflow.first;
    }

    return workflow[index - 1];
  }

  /// ==========================================================
  /// Tahap QC
  /// ==========================================================
  static bool isQcStage(String status) {
    return status == 'QC Pending' ||
        status == 'QC Passed';
  }

  /// ==========================================================
  /// Tahap Approval Supervisor
  /// ==========================================================
  static bool isApprovalStage(String status) {
    return status == approved;
  }

  /// ==========================================================
  /// Produksi selesai
  /// ==========================================================
  static bool isCompleted(String status) {
    return status == completed;
  }

  /// ==========================================================
  /// Batch ditolak
  /// ==========================================================
  static bool isRejected(String status) {
    return status == rejected;
  }
}