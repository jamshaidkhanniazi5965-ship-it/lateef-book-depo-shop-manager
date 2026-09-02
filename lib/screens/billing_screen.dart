import 'package:flutter/material.dart';

import '../database/database.dart';
import '../main.dart';
import '../services/shop_services.dart';
import 'billing_numpad.dart';

const List<Color> _categoryPalette = [
  Color(0xFF5C6BC0),
  Color(0xFF26A69A),
  Color(0xFFEF5350),
  Color(0xFFFFA726),
  Color(0xFF8D6E63),
  Color(0xFF7E57C2),
];

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<BillLine> _lines = [];
  String _search = '';
  String _selectedCategory = 'All';
  String _paymentType = 'cash';
  bool _saving = false;

  double get _total => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  void _addProduct(Product product) {
    if (product.stockQty <= 0) return;
    setState(() {
      final existingIndex =
          _lines.indexWhere((l) => l.productId == product.id);
      if (existingIndex != -1) {
        final existing = _lines[existingIndex];
        if (existing.quantity + 1 > product.stockQty) return;
        _lines[existingIndex] = BillLine(
          productId: existing.productId,
          productName: existing.productName,
          quantity: existing.quantity + 1,
          unitPrice: existing.unitPrice,
        );
      } else {
        _lines.add(BillLine(
          productId: product.id,
          productName: product.name,
          quantity: 1,
          unitPrice: product.salePrice,
        ));
      }
    });
  }

  void _changeQty(int index, int delta, int stockQty) {
    setState(() {
      final l = _lines[index];
      final newQty = l.quantity + delta;
      if (newQty <= 0) {
        _lines.removeAt(index);
        return;
      }
      if (newQty > stockQty) return;
      _lines[index] = BillLine(
        productId: l.productId,
        productName: l.productName,
        quantity: newQty,
        unitPrice: l.unitPrice,
      );
    });
  }

  void _removeLine(int index) => setState(() => _lines.removeAt(index));

  Future<void> _saveBill(List<Product> allProducts) async {
    if (_lines.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      final billId = await db.saveBill(
        items: _lines,
        paymentType: _paymentType,
      );
      final savedLines = List<BillLine>.from(_lines);

      setState(() {
        _lines.clear();
        _saving = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bill saved.')));

      // Fetch the saved bill to pass accurate totals/payment info to the
      // receipt. Printing failure should never block a bill that's
      // already safely saved, so this is wrapped separately.
      try {
        final bill =
            await (db.select(db.bills)..where((b) => b.id.equals(billId)))
                .getSingle();
        final billItems = await (db.select(db.billItems)
              ..where((i) => i.billId.equals(billId)))
            .get();
        if (!mounted) return;
        await ShopServices.printReceipt(
          bill: bill,
          items: billItems,
          allProducts: allProducts,
        );
      } catch (_) {
        // Printing is a bonus step — a missing/unconfigured printer
        // shouldn't be treated as a failed sale.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Bill saved, but the receipt could not be printed.')));
        }
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save bill: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: db.watchAllProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];

        final categories = <String>{
          'All',
          ...products.map((p) => p.category).whereType<String>(),
        }.toList();

        final filtered = products.where((p) {
          final matchesCategory =
              _selectedCategory == 'All' || p.category == _selectedCategory;
          final matchesSearch =
              p.name.toLowerCase().contains(_search.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          body: Row(
            children: [
              // ---- Left panel: search, category chips, product grid ----
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search products…',
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final cat = categories[i];
                            final selected = cat == _selectedCategory;
                            final color = cat == 'All'
                                ? Colors.grey.shade700
                                : _categoryPalette[i % _categoryPalette.length];
                            return ChoiceChip(
                              label: Text(cat),
                              selected: selected,
                              selectedColor: color,
                              labelStyle: TextStyle(
                                  color: selected ? Colors.white : Colors.black87),
                              onSelected: (_) =>
                                  setState(() => _selectedCategory = cat),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('No products found.'))
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.3,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, i) {
                                  final p = filtered[i];
                                  final outOfStock = p.stockQty <= 0;
                                  return Card(
                                    elevation: 0,
                                    color: outOfStock
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap:
                                          outOfStock ? null : () => _addProduct(p),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              p.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              p.salePrice.toStringAsFixed(0),
                                              style: TextStyle(
                                                color: Colors.teal.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              outOfStock
                                                  ? 'Out of stock'
                                                  : 'Stock: ${p.stockQty}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: outOfStock
                                                    ? Colors.red
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              // ---- Middle panel: cart, payment type, total, save ----
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current bill',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _lines.isEmpty
                            ? const Center(
                                child: Text('Tap a product to add it to the bill.'))
                            : SingleChildScrollView(
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Item')),
                                    DataColumn(label: Text('Qty')),
                                    DataColumn(label: Text('Total')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: List.generate(_lines.length, (i) {
                                    final l = _lines[i];
                                    final matching = products
                                        .where((p) => p.id == l.productId);
                                    final stock =
                                        matching.isEmpty ? 0 : matching.first.stockQty;
                                    return DataRow(cells: [
                                      DataCell(Text(l.productName)),
                                      DataCell(Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline,
                                                size: 18),
                                            onPressed: () =>
                                                _changeQty(i, -1, stock),
                                          ),
                                          Text('${l.quantity}'),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline,
                                                size: 18),
                                            onPressed: () => _changeQty(i, 1, stock),
                                          ),
                                        ],
                                      )),
                                      DataCell(Text(l.lineTotal.toStringAsFixed(0))),
                                      DataCell(IconButton(
                                        icon: const Icon(Icons.close,
                                            size: 18, color: Colors.red),
                                        onPressed: () => _removeLine(i),
                                      )),
                                    ]);
                                  }),
                                ),
                              ),
                      ),
                      const Divider(),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'cash', label: Text('Cash')),
                          ButtonSegment(value: 'credit', label: Text('Credit')),
                        ],
                        selected: {_paymentType},
                        onSelectionChanged: (s) =>
                            setState(() => _paymentType = s.first),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total: ${_total.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleLarge),
                          FilledButton.icon(
                            onPressed: _lines.isEmpty || _saving
                                ? null
                                : () => _saveBill(products),
                            icon: _saving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.print),
                            label: Text(_saving ? 'Saving…' : 'Save bill & print'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ---- Right panel: calculator ----
              const BillingNumpad(),
            ],
          ),
        );
      },
    );
  }
}
