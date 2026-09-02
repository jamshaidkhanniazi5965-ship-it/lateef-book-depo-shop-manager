import 'package:flutter/material.dart';

import '../main.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: FutureBuilder<double>(
        future: db.getSalesTotalBetween(startOfDay, endOfDay),
        builder: (context, snapshot) {
          final total = snapshot.data ?? 0;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today\'s sales',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(total.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
            ),
          );
          // Phase 2: add monthly totals, low-stock list, and profit
          // (sale_price - cost_price summed across bill_items).
        },
      ),
    );
  }
}
