import 'package:flutter/material.dart';

class ApprovalSearch extends StatelessWidget {
  const ApprovalSearch({
    super.key,
    required this.controller,
    this.hintText = "Cari kode batch atau operator...",
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    tooltip: "Hapus pencarian",
                    icon: const Icon(Icons.close),
                    onPressed: controller.clear,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            isDense: true,
          ),
        );
      },
    );
  }
}