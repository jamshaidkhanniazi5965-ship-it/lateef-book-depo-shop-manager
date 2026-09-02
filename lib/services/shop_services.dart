import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../database/database.dart';
import '../main.dart';

class ShopServices {
  /// Print a thermal-style receipt for a saved bill.
  static Future<void> printReceipt({
    required Bill bill,
    required List<BillItem> items,
    required List<Product> allProducts,
  }) async {
    final doc = pw.Document();
    final productMap = {for (final p in allProducts) p.id: p};
    final customerName = await db.getCustomerName(bill.customerId);
    final remaining = bill.total - bill.amountPaid;

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
              pw.Text('Customer: $customerName', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Date: ${bill.date.toString().split(".")[0]}',
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
                final name = productMap[item.productId]?.name ?? 'Unknown product';
                final lineTotal = item.unitPrice * item.quantity;
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(flex: 3, child: pw.Text(name, style: const pw.TextStyle(fontSize: 9))),
                      pw.Expanded(flex: 1, child: pw.Text('${item.quantity}', style: const pw.TextStyle(fontSize: 9))),
                      pw.Expanded(flex: 2, child: pw.Text(lineTotal.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 9))),
                    ],
                  ),
                );
              }),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Amount:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text('Rs. ${bill.total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Paid:', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('Rs. ${bill.amountPaid.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
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
      final items = await db.select(db.billItems).get();
      final customers = await db.select(db.customers).get();

      final backupData = {
        'version': 2,
        'timestamp': DateTime.now().toIso8601String(),
        'products': products.map((p) => p.toJson()).toList(),
        'customers': customers.map((c) => c.toJson()).toList(),
        'bills': bills.map((b) => b.toJson()).toList(),
        'billItems': items.map((i) => i.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save shop database backup',
        fileName: 'shop_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        bytes: utf8.encode(jsonString),
      );

      // On Windows, saveFile writes the file itself when `bytes` is given
      // and returns the chosen path; on some platforms it may return a
      // path without writing, so we write defensively if the file doesn't
      // exist yet.
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
        await db.delete(db.billItems).go();
        await db.delete(db.bills).go();
        await db.delete(db.products).go();
        await db.delete(db.customers).go();

        for (final c in (data['customers'] as List? ?? [])) {
          await db.into(db.customers).insert(
                CustomersCompanion.insert(
                  id: drift.Value(c['id']),
                  name: c['name'],
                  phone: drift.Value(c['phone']),
                  creditBalance: drift.Value((c['creditBalance'] as num).toDouble()),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }

        for (final p in (data['products'] as List? ?? [])) {
          await db.into(db.products).insert(
                ProductsCompanion.insert(
                  id: drift.Value(p['id']),
                  name: p['name'],
                  category: drift.Value(p['category']),
                  barcode: drift.Value(p['barcode']),
                  costPrice: drift.Value((p['costPrice'] as num).toDouble()),
                  salePrice: drift.Value((p['salePrice'] as num).toDouble()),
                  stockQty: drift.Value(p['stockQty']),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }

        for (final b in (data['bills'] as List? ?? [])) {
          await db.into(db.bills).insert(
                BillsCompanion.insert(
                  id: drift.Value(b['id']),
                  customerId: drift.Value(b['customerId']),
                  date: drift.Value(DateTime.parse(b['date'])),
                  total: (b['total'] as num).toDouble(),
                  amountPaid: drift.Value((b['amountPaid'] as num).toDouble()),
                  paymentType: drift.Value(b['paymentType']),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        }

        for (final i in (data['billItems'] as List? ?? [])) {
          await db.into(db.billItems).insert(
                BillItemsCompanion.insert(
                  id: drift.Value(i['id']),
                  billId: i['billId'],
                  productId: i['productId'],
                  quantity: i['quantity'],
                  unitPrice: (i['unitPrice'] as num).toDouble(),
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
