class OperatorWorkflow {
  OperatorWorkflow._();

  static const List<String> workflow = [
    'Draft',
    'Preparation',
    'Mixing',
    'Fermentation',
    'Filtering',
    'Packaging',
    'QC Pending',
  ];

  static String nextStatus(String currentStatus) {
    final index = workflow.indexOf(currentStatus);

    if (index == -1) return workflow.first;

    if (index == workflow.length - 1) {
      return workflow.last;
    }

    return workflow[index + 1];
  }

  static bool canCreateMonitoring(String status) {
    return workflow.contains(status) &&
        status != 'QC Pending';
  }
}