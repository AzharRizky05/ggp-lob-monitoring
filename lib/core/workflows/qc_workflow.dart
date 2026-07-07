class QcWorkflow {
  QcWorkflow._();

  static String pass() {
    return "Waiting Approval";
  }

  static String fail() {
    return "QC Failed";
  }
}