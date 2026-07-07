import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    isLoading = false;
    notifyListeners();
  }
}