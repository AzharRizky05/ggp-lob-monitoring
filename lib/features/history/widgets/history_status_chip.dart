import 'package:flutter/material.dart';

class HistoryStatusChip extends StatelessWidget {
  final String status;

  const HistoryStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case "Passed":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;

      case "Failed":
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel;
        break;

      case "Completed":
      case "Selesai":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.task_alt;
        break;

      case "Proses":
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.timelapse;
        break;

      case "Ditolak":
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel;
        break;

      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
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
            status,
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