import 'package:flutter/material.dart';

class ApprovalStatusChip extends StatelessWidget {
  final String status;

  const ApprovalStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case "Waiting Approval":
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        icon = Icons.hourglass_bottom;
        break;

      case "QC Passed":
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Icons.verified;
        break;

      case "Approved":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;

      case "Completed":
        backgroundColor = Colors.teal.shade100;
        textColor = Colors.teal.shade800;
        icon = Icons.task_alt;
        break;

      case "Rejected":
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