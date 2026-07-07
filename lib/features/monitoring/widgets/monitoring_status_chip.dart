import 'package:flutter/material.dart';

class MonitoringStatusChip extends StatelessWidget {
  final String status;

  const MonitoringStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case "Preparation":
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;

      case "Mixing":
        backgroundColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade800;
        break;

      case "Fermentation":
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        break;

      case "Filtering":
        backgroundColor = Colors.cyan.shade100;
        textColor = Colors.cyan.shade900;
        break;

      case "Packaging":
        backgroundColor = Colors.teal.shade100;
        textColor = Colors.teal.shade900;
        break;

      case "QC Pending":
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade900;
        break;

      case "Approved":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        break;

      case "Completed":
        backgroundColor = Colors.green.shade200;
        textColor = Colors.green.shade900;
        break;

      case "Rejected":
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
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