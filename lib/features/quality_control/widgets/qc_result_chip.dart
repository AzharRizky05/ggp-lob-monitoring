import 'package:flutter/material.dart';

class QcResultChip extends StatelessWidget {
  final String hasilUji;

  const QcResultChip({
    super.key,
    required this.hasilUji,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (hasilUji) {
      case "Sesuai Standar":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.verified;
        break;

      case "Di Bawah Standar":
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.warning_amber_rounded;
        break;

      case "Belum Diuji":
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.schedule;
        break;

      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 6),
          Text(
            hasilUji,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}