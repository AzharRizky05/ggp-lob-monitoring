class ApprovalWorkflow {
  ApprovalWorkflow._();

  /// Status batch yang menunggu keputusan Supervisor.
  static const String waitingStatus = 'Waiting Approval';

  /// Nilai kolom approvals.approval_status
  static const String approvedDecision = 'Approved';
  static const String rejectedDecision = 'Rejected';

  /// Status batch setelah keputusan. Approve = produksi selesai.
  static String approve() => 'Completed';
  static String reject() => 'Rejected';
}