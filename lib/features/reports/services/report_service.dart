class ReportService {
  const ReportService();

  Future<void> loadReport() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}