import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../database/database.dart';

class ShopServices {
  /// Print a thermal-style receipt for a saved bill.
  static Future<void> printReceipt({
    required Bill bill,
    required List<CartLine> items,
  }) async {
    final doc = pw.Document();
    final remaining = bill.totalAmount - bill.paidAmount;

    doc.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(80 * PdfPageFormat.mm, 200 * PdfPageFormat.mm,
            marginAll: 5 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('SHOP MANAGEMENT POS',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Center(child: pw.Text('Official Receipt', style: const pw.TextStyle(fontSize: 10))),
              pw.SizedBox(height: 8),
              pw.Text('Bill #: ${bill.id}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Customer: ${bill.customerName}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Date: ${bill.createdAt.toString().split(".")[0]}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Payment: ${bill.paymentType}', style: const pw.TextStyle(fontSize: 10)),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                      flex: 3,
                      child: pw.Text('Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text('Qty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
                ],
              ),
              pw.SizedBox(height: 4),
              ...items.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(flex: 3, child: pw.Text(item.productName, style: const pw.TextStyle(fontSize: 9))),
                      pw.Expanded(flex: 1, child: pw.Text('${item.quantity}', style: const pw.TextStyle(fontSize: 9))),
                      pw.Expanded(flex: 2, child: pw.Text(item.lineTotal.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 9))),
                    ],
                  ),
                );
              }),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Amount:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text('Rs. ${bill.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Paid:', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('Rs. ${bill.paidAmount.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              if (remaining > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Remaining (Udhaar):', style: const pw.TextStyle(fontSize: 9, color: PdfColors.red)),
                    pw.Text('Rs. ${remaining.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.red)),
                  ],
                ),
              pw.SizedBox(height: 10),
              pw.Center(child: pw.Text('Thank you for your business!', style: const pw.TextStyle(fontSize: 9))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  /// Back up the whole database to a JSON file the shop owner picks.
  static Future<void> backupDatabase(BuildContext context) async {
    try {
      final products = await db.select(db.products).get();
      final bills = await db.select(db.bills).get();
      final lines = await db.select(db.billLines).get();

      final backupData = {
        'version': 3,
        'timestamp': DateTime.now().toIso8601String(),
        'products': products.map((p) => p.toJson()).toList(),
        'bills': bills.map((b) => b.toJson()).toList(),
        'billLines': lines.map((l) => l.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save shop database backup',
        fileName: 'shop_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        bytes: utf8.encode(jsonString),
      );

      if (outputPath != null) {
        final file = File(outputPath);
        if (!await file.exists()) {
          await file.writeAsString(jsonString);
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Database backup saved successfully!'),
                backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Restore the database from a previously exported JSON backup.
  /// This replaces all current data, so the caller should confirm with
  /// the user before calling this.
  static Future<void> restoreDatabase(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      await db.transaction(() async {
        await db.delete(db.billLines).go();
        await db.delete(db.bills).go();
        await db.delete(db.products).go();

        for (final p in (data['products'] as List? ?? [])) {
          await db.into(db.products).insert(
                ProductsCompanion.insert(
                  id: drift.Value(p['id']),
                  name: p['name'],
                  category: drift.Value(p['category']),
                  barcode: drift.Value(p['barcode']),
                  purchasePrice: (p['purchasePrice'] as num).toDouble(),
                  salePrice: (p['salePrice'] as num).toDouble(),
                  stockQty: p['stockQty'],
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }

        for (final b in (data['bills'] as List? ?? [])) {
          await db.into(db.bills).insert(
                BillsCompanion.insert(
                  id: drift.Value(b['id']),
                  customerName: b['customerName'],
                  totalAmount: drift.Value((b['totalAmount'] as num).toDouble()),
                  paidAmount: drift.Value((b['paidAmount'] as num).toDouble()),
                  remainingAmount: drift.Value((b['remainingAmount'] as num).toDouble()),
                  paymentMethod: drift.Value(b['paymentMethod']),
                  paymentType: drift.Value(b['paymentType']),
                  isCleared: drift.Value(b['isCleared']),
                  createdAt: drift.Value(DateTime.parse(b['createdAt'])),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }

        for (final l in (data['billLines'] as List? ?? [])) {
          await db.into(db.billLines).insert(
                BillLinesCompanion.insert(
                  id: drift.Value(l['id']),
                  billId: l['billId'],
                  productId: l['productId'],
                  productName: drift.Value(l['productName']),
                  quantity: l['quantity'],
                  unitPrice: drift.Value((l['unitPrice'] as num).toDouble()),
                  lineTotal: (l['lineTotal'] as num).toDouble(),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Database restored successfully!'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

