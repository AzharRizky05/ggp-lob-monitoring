import 'package:flutter/material.dart';

/// Timeline visual alur produksi:
/// Dibuat -> Produksi -> Menunggu QC -> QC -> Approval -> Selesai
/// Menyorot tahap gagal (QC Failed / Rejected) dengan warna merah.
class BatchTimeline extends StatelessWidget {
  final String status;

  const BatchTimeline({super.key, required this.status});

  static const List<String> _labels = [
    'Dibuat',
    'Produksi',
    'Menunggu QC',
    'Quality Control',
    'Approval',
    'Selesai',
  ];

  static const List<IconData> _icons = [
    Icons.edit_note,
    Icons.precision_manufacturing_outlined,
    Icons.hourglass_top,
    Icons.science_outlined,
    Icons.fact_check_outlined,
    Icons.task_alt,
  ];

  int get _currentIndex {
    switch (status) {
      case 'Draft':
        return 0;

      // Tahap produksi (Monitoring) - semua sub-status masuk stage "Produksi"
      case 'Preparation':
      case 'Mixing':
      case 'Fermentation':
      case 'Filtering':
      case 'Packaging':
        return 1;

      case 'QC Pending':
        return 2;

      case 'QC Passed':
      case 'QC Failed':
        return 3;

      case 'Waiting Approval':
      case 'Approved':
      case 'Rejected':
        return 4;

      case 'Completed':
        return 5;

      default:
        return 0;
    }
  }

  bool get _isFailedAtCurrentStage =>
      status == 'QC Failed' || status == 'Rejected';

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          children: List.generate(_labels.length, (index) {
            final isDone = index < current;
            final isCurrent = index == current;
            final isFailedStep = isCurrent && _isFailedAtCurrentStage;

            Color color;
            if (isFailedStep) {
              color = Colors.red;
            } else if (isDone || isCurrent) {
              color = Colors.green;
            } else {
              color = Colors.grey.shade300;
            }

            return SizedBox(
              width: 110,
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
                        radius: 16,
                        backgroundColor: color,
                        child: Icon(
                          isFailedStep ? Icons.close : _icons[index],
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: index == _labels.length - 1
                            ? const SizedBox()
                            : Container(
                                height: 2,
                                color:
                                    isDone ? Colors.green : Colors.grey.shade300,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _labels[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isFailedStep ? Colors.red : Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}