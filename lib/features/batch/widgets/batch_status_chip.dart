import 'package:flutter/material.dart';

class BatchStatusChip extends StatelessWidget {
  final String status;

  const BatchStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case "Persiapan Bahan":
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;

      case "Pencampuran":
        backgroundColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade800;
        break;

      case "Fermentasi":
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;

      case "Quality Control":
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        break;

      case "Pengemasan":
        backgroundColor = Colors.teal.shade100;
        textColor = Colors.teal.shade800;
        break;

      case "Selesai":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;

      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}