import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../database/database.dart';

Future<void> printReceipt({
  required int billId,
  required List<BillLine> items,
  required double total,
  required String paymentType,
  String customerName = 'Walk-in Customer',
  DateTime? date,
}) async {
  final doc = pw.Document();
  final slipDate = date ?? DateTime.now();
  final formattedDate =
      "${slipDate.year}-${slipDate.month.toString().padLeft(2, '0')}-${slipDate.day.toString().padLeft(2, '0')} ${slipDate.hour.toString().padLeft(2, '0')}:${slipDate.minute.toString().padLeft(2, '0')}";

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(               child: pw.Text('Lateef Book Depo',                   style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),             ),             pw.Center(               child: pw.Text('SHOP RECEIPT',                   style: pw.TextStyle(fontSize: 12)),             ),
            pw.Divider(),
            pw.Text('Bill #: $billId'),
            pw.Text('Date & Time: $formattedDate'),
            pw.Text('Customer: $customerName'),
            pw.Text('Payment: ${paymentType.toUpperCase()}'),
            pw.Divider(),
            ...items.map(
              (item) => pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(child: pw.Text(item.productName)),
                  pw.Text('${item.quantity} x ${item.unitPrice.toStringAsFixed(0)}'),
                  pw.SizedBox(width: 8),
                  pw.Text((item.quantity * item.unitPrice).toStringAsFixed(0)),
                ],
              ),
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(total.toStringAsFixed(2),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Center(child: pw.Text('Thank you for your visit!')),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => doc.save(),
  );
}

