import 'package:flutter/material.dart';
import '../database/database.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: color),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bill>>(
      future: db.getAllBills(),
      builder: (context, snapshot) {
        final bills = snapshot.data ?? [];

        double totalRevenue = 0;
        double totalProfit = 0;
        int pendingCount = 0;

        return FutureBuilder<List<double>>(
          future: Future.wait(bills.map((b) async {
            final items = await db.getBillLinesForBill(b.id);
            final products = await db.getAllProducts();
            double profit = 0;
            for (final item in items) {
              final match = products.where((p) => p.id == item.productId);
              if (match.isNotEmpty) {
                profit += (item.unitPrice - match.first.purchasePrice) * item.quantity;
              }
            }
            return profit;
          })),
          builder: (context, profitSnapshot) {
            final profits = profitSnapshot.data ?? [];
            for (var i = 0; i < bills.length; i++) {
              totalRevenue += bills[i].totalAmount;
              if (i < profits.length) totalProfit += profits[i];
              if (!bills[i].isCleared) pendingCount++;
            }
            final margin = totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reports & Profit Analytics',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _statCard('Total Revenue', 'Rs. ${totalRevenue.toStringAsFixed(2)}',
                          Icons.point_of_sale, Colors.teal),
                      _statCard('Net Profit', 'Rs. ${totalProfit.toStringAsFixed(2)}',
                          Icons.trending_up, Colors.green),
                      _statCard('Profit Margin', '${margin.toStringAsFixed(1)}%',
                          Icons.pie_chart, Colors.indigo),
                      _statCard('Pending Udhaar', '$pendingCount Bills',
                          Icons.menu_book_outlined, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('Sales & Profit Log',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Expanded(
                    child: bills.isEmpty
                        ? const Center(child: Text('No sales yet.'))
                        : ListView.separated(
                            itemCount: bills.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, i) {
                              final b = bills[i];
                              final profit = i < profits.length ? profits[i] : 0.0;
                              final dateStr =
                                  '${b.createdAt.toLocal()}'.substring(0, 16);
                              final method = b.isCleared
                                  ? b.paymentType.toUpperCase()
                                  : 'PARTIAL (Pending)';
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green.shade50,
                                  child: const Icon(Icons.arrow_upward, color: Colors.green),
                                ),
                                title: Text('Bill #${b.id} — ${b.customerName}'),
                                subtitle: Text('Date: $dateStr | Method: $method'),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Rev: Rs. ${b.totalAmount.toStringAsFixed(0)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Profit: Rs. ${profit.toStringAsFixed(0)}',
                                        style: const TextStyle(color: Colors.green)),
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
    );
  }
}
