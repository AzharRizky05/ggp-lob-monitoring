import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../models/report_model.dart';

class ReportService {
  const ReportService._();

  /// Membuat isi file CSV yang bisa langsung dibuka di Excel.
  static String buildCsv(List<ReportRow> rows) {
    final buffer = StringBuffer();

    buffer.write('\uFEFF'); // BOM agar Excel membaca huruf UTF-8 dengan benar
    buffer.write('sep=;\r\n'); // memaksa Excel memakai titik koma sebagai pemisah

    buffer.write(_line(const [
      'Kode Batch',
      'Operator',
      'Tanggal Produksi',
      'Shift',
      'Tank',
      'Volume (L)',
      'Hasil QC',
      'Status',
      'Diputuskan Oleh',
    ]));

    for (final row in rows) {
      buffer.write(_line([
        row.batchCode,
        row.operatorName,
        row.productionDateLabel,
        row.shift,
        row.tank,
        _number(row.volume),
        row.qcResult,
        row.status,
        row.supervisorName,
      ]));
    }

    return buffer.toString();
  }

  /// Memicu unduhan file di browser.
  static void downloadCsv({required String fileName, required String content}) {
    final blob = web.Blob(
      [content.toJS].toJS,
      web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
    );
    final url = web.URL.createObjectURL(blob);

    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName;
    anchor.click();

    web.URL.revokeObjectURL(url);
  }

  static String _line(List<String> cells) => '${cells.map(_cell).join(';')}\r\n';

  static String _cell(String value) => '"${value.replaceAll('"', '""')}"';

  static String _number(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }
}