import 'package:flutter/material.dart';

/// Timeline ringkas alur batch:
/// Produksi -> QC Pending -> Hasil QC -> Menunggu Approval -> Hasil Approval -> Selesai
/// Lebar tiap tahap menyesuaikan ruang yang tersedia, jadi semua tahap selalu terlihat.
class BatchTimeline extends StatelessWidget {
  final String status;

  const BatchTimeline({super.key, required this.status});

  static const List<String> _labels = [
    'Produksi',
    'QC Pending',
    'Hasil QC',
    'Menunggu Approval',
    'Hasil Approval',
    'Selesai',
  ];

  static const List<IconData> _icons = [
    Icons.precision_manufacturing_outlined,
    Icons.hourglass_top,
    Icons.verified_outlined,
    Icons.hourglass_bottom,
    Icons.fact_check_outlined,
    Icons.task_alt,
  ];

  int get _currentIndex {
    switch (status) {
      case 'QC Pending':
        return 1;
      case 'QC Passed':
      case 'QC Failed':
        return 2;
      case 'Waiting Approval':
        return 3;
      case 'Rejected':
        return 4;
      case 'Approved':
      case 'Completed':
        return 5; // Approve = produksi selesai
      default:
        return 0; // Draft sampai Packaging = tahap produksi
    }
  }

  bool get _isFailedAtCurrentStage =>
      status == 'QC Failed' || status == 'Rejected';

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_labels.length, (index) {
        final isDone = index < current;
        final isCurrent = index == current;
        final isFailed = isCurrent && _isFailedAtCurrentStage;

        final Color color;
        if (isFailed) {
          color = Colors.red;
        } else if (isDone || isCurrent) {
          color = Colors.green;
        } else {
          color = Colors.grey.shade300;
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: index == 0
                        ? const SizedBox()
                        : Container(
                            height: 2,
                            color: (isDone || isCurrent)
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: color,
                    child: Icon(
                      isFailed ? Icons.close : _icons[index],
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: index == _labels.length - 1
                        ? const SizedBox()
                        : Container(
                            height: 2,
                            color: isDone ? Colors.green : Colors.grey.shade300,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isFailed ? Colors.red : Colors.black87,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}