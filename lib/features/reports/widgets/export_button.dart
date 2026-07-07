import 'package:flutter/material.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Fitur Export PDF akan tersedia setelah integrasi database.",
                ),
              ),
            );
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Export PDF"),
        ),

        const SizedBox(width: 16),

        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Fitur Export Excel akan tersedia setelah integrasi database.",
                ),
              ),
            );
          },
          icon: const Icon(Icons.table_view),
          label: const Text("Export Excel"),
        ),
      ],
    );
  }
}