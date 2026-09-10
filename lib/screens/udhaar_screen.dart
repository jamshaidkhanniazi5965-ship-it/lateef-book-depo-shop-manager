import 'package:flutter/material.dart';
import '../database/database.dart';

class UdhaarScreen extends StatefulWidget {
  const UdhaarScreen({super.key});

  @override
  State<UdhaarScreen> createState() => _UdhaarScreenState();
}

class _UdhaarScreenState extends State<UdhaarScreen> {
  String _search = '';

  void _showReceivePaymentDialog(Bill bill, double totalAmount) {
    final remaining = (totalAmount - bill.paidAmount).clamp(0.0, double.infinity);
    final controller = TextEditingController(text: remaining.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Receive Payment - Bill #${bill.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${bill.customerName}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Total Bill: Rs. ${totalAmount.toStringAsFixed(2)}'),
              Text('Already Paid: Rs. ${bill.paidAmount.toStringAsFixed(2)}'),
              Text(
                'Current Balance Due: Rs. ${remaining.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Payment Received Now (Rs.)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final paymentNow = double.tryParse(controller.text) ?? 0.0;
                if (paymentNow <= 0) return;

                final newTotalPaid = bill.paidAmount + paymentNow;
                final isFullyCleared = newTotalPaid >= (totalAmount - 0.01);

                await db.recordPartialPayment(
                    bill.id, newTotalPaid, isFullyCleared);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFullyCleared
                            ? 'Bill #${bill.id} is now fully cleared!'
                            : 'Payment recorded. Remaining: Rs. ${(totalAmount - newTotalPaid).toStringAsFixed(2)}',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Save Payment'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Udhaar Ledger & Credit Management'),
      ),
      body: StreamBuilder<List<Bill>>(
        stream: db.watchUdharBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allUdharBills = snapshot.data ?? [];

          return StreamBuilder<List<BillLine>>(
            stream: db.select(db.billLines).watch(),
            builder: (context, lineSnapshot) {
              final allLines = lineSnapshot.data ?? [];

              // Calculate balances per bill
              final pendingBills = <Map<String, dynamic>>[];
              double grandTotalUdhaar = 0.0;

              for (final bill in allUdharBills) {
                final lines =
                    allLines.where((l) => l.billId == bill.id).toList();
                final billTotal =
                    lines.fold(0.0, (sum, item) => sum + item.lineTotal);
                final due =
                    (billTotal - bill.paidAmount).clamp(0.0, double.infinity);

                if (!bill.isCleared && due > 0) {
                  if (_search.isEmpty ||
                      bill.customerName
                          .toLowerCase()
                          .contains(_search.toLowerCase()) ||
                      bill.id.toString().contains(_search)) {
                    pendingBills.add({
                      'bill': bill,
                      'lines': lines,
                      'total': billTotal,
                      'due': due,
                    });
                    grandTotalUdhaar += due;
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.orange.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Icon(Icons.account_balance_wallet,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Market Udhaar Due',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),
                                Text(
                                  'Rs. ${grandTotalUdhaar.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '${pendingBills.length} Pending Bills',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search customer name or bill ID...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (v) => setState(() => _search = v.trim()),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: pendingBills.isEmpty
                          ? Center(
                              child: Text(
                                'No pending Udhaar entries found.',
                                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                              ),
                            )
                          : ListView.separated(
                              itemCount: pendingBills.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final item = pendingBills[index];
                                final Bill bill = item['bill'];
                                final double total = item['total'];
                                final double due = item['due'];
                                final List<BillLine> lines = item['lines'];

                                final dt = bill.createdAt;
                                final dateStr =
                                    "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";

                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: Colors.grey.shade300),
                                  ),
                                  child: ExpansionTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.orange.shade100,
                                      child: Text(
                                        bill.customerName.isNotEmpty
                                            ? bill.customerName[0].toUpperCase()
                                            : 'C',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                    title: Text(
                                      '${bill.customerName} (Bill #${bill.id})',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        'Date: $dateStr | Paid: Rs. ${bill.paidAmount.toStringAsFixed(0)} / Rs. ${total.toStringAsFixed(0)}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text('Due',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)),
                                            Text(
                                              'Rs. ${due.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        FilledButton.icon(
                                          onPressed: () =>
                                              _showReceivePaymentDialog(
                                                  bill, total),
                                          icon: const Icon(Icons.payment,
                                              size: 16),
                                          label: const Text('Receive'),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Purchased Items:',
                                                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87, 
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 12)),
                                            const SizedBox(height: 6),
                                            ...lines.map((l) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${l.productName} (x${l.quantity})'),
                                                      Text(
                                                          'Rs. ${l.lineTotal.toStringAsFixed(2)}'),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}




