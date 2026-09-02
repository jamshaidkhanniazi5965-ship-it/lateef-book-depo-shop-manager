import 'package:flutter/material.dart';

import '../database/database.dart';
import '../main.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<BillLine> _lines = [];

  double get _total => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  Future<void> _addProductToBill() async {
    final products = await db.getAllProducts();
    if (!mounted || products.isEmpty) return;

    final chosen = await showDialog<Product>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select a product'),
        children: products
            .map((p) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, p),
                  child: Text('${p.name}  (${p.salePrice})'),
                ))
            .toList(),
      ),
    );
    if (chosen == null) return;

    setState(() {
      _lines.add(BillLine(
        productId: chosen.id,
        productName: chosen.name,
        quantity: 1,
        unitPrice: chosen.salePrice,
      ));
    });
  }

  Future<void> _saveBill() async {
    if (_lines.isEmpty) return;
    try {
      await db.saveBill(items: _lines, paymentType: 'cash');
      setState(() => _lines.clear());
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Bill saved.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not save bill: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New bill'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: _addProductToBill,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _lines.isEmpty
                ? const Center(child: Text('Tap the cart icon to add items.'))
                : ListView.builder(
                    itemCount: _lines.length,
                    itemBuilder: (context, i) {
                      final l = _lines[i];
                      return ListTile(
                        title: Text(l.productName),
                        subtitle: Text('Qty: ${l.quantity} x ${l.unitPrice}'),
                        trailing: Text(l.lineTotal.toStringAsFixed(2)),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${_total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
                FilledButton(
                  onPressed: _lines.isEmpty ? null : _saveBill,
                  child: const Text('Save bill'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
