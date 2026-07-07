import 'package:flutter/material.dart';

class AppContent extends StatelessWidget {
  final Widget child;

  const AppContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: const Color(0xffF7F9FC),
      child: child,
    );
  }
}