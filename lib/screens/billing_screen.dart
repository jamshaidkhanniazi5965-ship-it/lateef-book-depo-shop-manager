import 'package:flutter/material.dart';
import '../database/database.dart';
import '../services/shop_services.dart';
import 'billing_numpad.dart';

const List<Color> _categoryPalette = [
  Color(0xFF5C6BC0),
  Color(0xFF26A69A),
  Color(0xFFEF5350),
  Color(0xFFFFA726),
  Color(0xFF8D6E63),
];

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<CartLine> _lines = [];
  final _searchController = TextEditingController();
  final _customerController = TextEditingController();
  final _paidAmountController = TextEditingController();
  String _selectedCategory = 'All';
  String _paymentType = 'cash';
  bool _saving = false;

  double get _total => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  void _addProduct(Product p) {
    if (p.stockQty <= 0) return;
    setState(() {
      final i = _lines.indexWhere((l) => l.productId == p.id);
      if (i != -1) {
        final existing = _lines[i];
        if (existing.quantity + 1 > p.stockQty) return;
        _lines[i] = CartLine(
          productId: existing.productId,
          productName: existing.productName,
          quantity: existing.quantity + 1,
          unitPrice: existing.unitPrice,
        );
      } else {
        _lines.add(CartLine(
          productId: p.id,
          productName: p.name,
          quantity: 1,
          unitPrice: p.salePrice,
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
      _lines[index] = CartLine(
        productId: l.productId,
        productName: l.productName,
        quantity: newQty,
        unitPrice: l.unitPrice,
      );
    });
  }

  void _removeLine(int index) => setState(() => _lines.removeAt(index));

  Future<void> _saveBill({required bool shouldPrint}) async {
    if (_lines.isEmpty || _saving) return;
    setState(() => _saving = true);

    final custName = _customerController.text.trim().isEmpty
        ? 'Walk-in Customer'
        : _customerController.text.trim();

    double paidUpfront;
    if (_paymentType == 'partial') {
      paidUpfront = double.tryParse(_paidAmountController.text.trim()) ?? 0.0;
    } else if (_paymentType == 'credit') {
      paidUpfront = 0.0;
    } else {
      paidUpfront = _total;
    }

    // Keep a copy for the receipt before we clear the cart below.
    final savedLines = List<CartLine>.from(_lines);

    try {
      final billId = await db.saveBill(
        items: _lines,
        paymentType: _paymentType,
        customerName: custName,
        paidAmount: paidUpfront,
      );
      setState(() {
        _lines.clear();
        _customerController.clear();
        _paidAmountController.clear();
        _paymentType = 'cash';
        _saving = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill #$billId saved for $custName.')),
      );

      if (!shouldPrint) return;

      // Printing is a bonus step - a missing/unconfigured printer should
      // never be treated as a failed sale, so it's wrapped separately.
      try {
        final bill =
            await (db.select(db.bills)..where((b) => b.id.equals(billId)))
                .getSingle();
        if (!mounted) return;
        await ShopServices.printReceipt(bill: bill, items: savedLines);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Bill saved, but the receipt could not be printed.')));
        }
      }
    } catch (e) {
      setState(() => _saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save bill: $e')),
      );
    }
  }

  Widget _paymentButton(String value, String label, IconData icon) {
    final selected = _paymentType == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark ? Colors.white70 : Colors.black87;
    return ChoiceChip(
      label: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: selected ? Colors.white : unselectedColor),
        const SizedBox(width: 6),
        Text(label),
      ]),
      selected: selected,
      selectedColor: Colors.teal,
      labelStyle: TextStyle(color: selected ? Colors.white : unselectedColor),
      onSelected: (_) => setState(() => _paymentType = value),
    );
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
          final matchesSearch = p.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('New Bill',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search),
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final cat = categories[i];
                            final selected = cat == _selectedCategory;
                            final color = cat == 'All'
                                ? Colors.teal
                                : _categoryPalette[i % _categoryPalette.length];
                            return ChoiceChip(
                              label: Text(cat),
                              selected: selected,
                              selectedColor: color,
                              labelStyle: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white70
                                          : Colors.black87),
                              onSelected: (_) => setState(() => _selectedCategory = cat),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('No products found.'))
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 180,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  mainAxisExtent: 130,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, i) {
                                  final p = filtered[i];
                                  final outOfStock = p.stockQty <= 0;
                                  return Card(
                                    elevation: 0,
                                    color: outOfStock ? Colors.grey.shade200 : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: outOfStock ? null : () => _addProduct(p),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(p.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                                            Text(p.salePrice.toStringAsFixed(0),
                                                style: TextStyle(
                                                    color: Colors.teal.shade700,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text(
                                              outOfStock ? 'Out of stock' : 'Stock: ${p.stockQty}',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: outOfStock ? Colors.red : Colors.black54),
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
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (_lines.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                              SizedBox(width: 32),
                            ],
                          ),
                        ),
                      Expanded(
                        child: _lines.isEmpty
                            ? const Center(child: Text('Tap a product to add it to the bill.'))
                            : ListView.builder(
                                itemCount: _lines.length,
                                itemBuilder: (context, i) {
                                  final l = _lines[i];
                                  final match = products.where((p) => p.id == l.productId);
                                  final stock = match.isEmpty ? l.quantity : match.first.stockQty;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 3, child: Text(l.productName)),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove_circle_outline, size: 18),
                                                onPressed: () => _changeQty(i, -1, stock),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 4),
                                              Text('${l.quantity}'),
                                              const SizedBox(width: 4),
                                              IconButton(
                                                icon: const Icon(Icons.add_circle_outline, size: 18),
                                                onPressed: () => _changeQty(i, 1, stock),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(flex: 2, child: Text(l.lineTotal.toStringAsFixed(2))),
                                        IconButton(
                                          icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                          onPressed: () => _removeLine(i),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Customer Name',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _customerController,
                        decoration: const InputDecoration(
                          hintText: 'Enter customer name',
                          prefixIcon: Icon(Icons.person_outline),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Payment Method',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _paymentButton('cash', 'Cash', Icons.payments_outlined),
                          _paymentButton('card', 'Card', Icons.credit_card),
                          _paymentButton('mobile', 'Mobile/QR', Icons.qr_code),
                          _paymentButton('credit', 'Udhaar', Icons.menu_book_outlined),
                          _paymentButton('partial', 'Partial Pay', Icons.pie_chart_outline),
                        ],
                      ),
                      if (_paymentType == 'partial') ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _paidAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Amount currently paying',
                            hintText: '0.00',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(_total.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _lines.isEmpty || _saving
                                  ? null
                                  : () => _saveBill(shouldPrint: true),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.teal,
                                side: const BorderSide(color: Colors.teal),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              icon: const Icon(Icons.print, size: 18),
                              label: const Text('Save & Print'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: _lines.isEmpty || _saving
                                  ? null
                                  : () => _saveBill(shouldPrint: false),
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(vertical: 14)),
                              child: Text(_saving ? 'Saving...' : 'Save Bill'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              const BillingNumpad(),
            ],
          ),
        );
      },
    );
  }
}


