class HistoryService {
  const HistoryService();

  Future<List<dynamic>> getHistories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}