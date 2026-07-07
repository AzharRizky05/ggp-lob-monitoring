class ApprovalService {
  const ApprovalService();

  Future<List<dynamic>> getApprovals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}