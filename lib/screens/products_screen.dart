import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../database/database.dart';
import '../main.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _search = '';

  Future<void> _showProductDialog(BuildContext context, {Product? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final barcodeCtrl = TextEditingController(text: existing?.barcode ?? '');
    final costCtrl =
        TextEditingController(text: existing?.costPrice.toString() ?? '');
    final priceCtrl =
        TextEditingController(text: existing?.salePrice.toString() ?? '');
    final stockCtrl =
        TextEditingController(text: existing?.stockQty.toString() ?? '');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add product' : 'Edit product'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: categoryCtrl,
                decoration:
                    const InputDecoration(labelText: 'Category (optional)'),
              ),
              TextField(
                controller: barcodeCtrl,
                decoration:
                    const InputDecoration(labelText: 'Barcode (optional)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: costCtrl,
                      decoration: const InputDecoration(labelText: 'Cost price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      decoration: const InputDecoration(labelText: 'Sale price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final category = categoryCtrl.text.trim();
              final barcode = barcodeCtrl.text.trim();
              final cost = double.tryParse(costCtrl.text) ?? 0;
              final price = double.tryParse(priceCtrl.text) ?? 0;
              final stock = int.tryParse(stockCtrl.text) ?? 0;

              if (existing == null) {
                await db.addProduct(ProductsCompanion.insert(
                  name: name,
                  category: Value(category.isEmpty ? null : category),
                  barcode: Value(barcode.isEmpty ? null : barcode),
                  costPrice: Value(cost),
                  salePrice: Value(price),
                  stockQty: Value(stock),
                ));
              } else {
                await db.updateProduct(existing.copyWith(
                  name: name,
                  category: Value(category.isEmpty ? null : category),
                  barcode: Value(barcode.isEmpty ? null : barcode),
                  costPrice: cost,
                  salePrice: price,
                  stockQty: stock,
                ));
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('This removes "${product.name}" permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await db.deleteProduct(product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: db.watchAllProducts(),
        builder: (context, snapshot) {
          final all = snapshot.data ?? [];
          final items = _search.isEmpty
              ? all
              : all
                  .where((p) =>
                      p.name.toLowerCase().contains(_search.toLowerCase()))
                  .toList();
          final lowStockCount =
              all.where((p) => p.stockQty <= p.lowStockThreshold).length;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Products',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(width: 12),
                    if (lowStockCount > 0)
                      Chip(
                        avatar: const Icon(Icons.warning_amber,
                            color: Colors.orange, size: 18),
                        label: Text('$lowStockCount low stock'),
                        backgroundColor: Colors.orange.withValues(alpha: 0.1),
                      ),
                    const Spacer(),
                    SizedBox(
                      width: 260,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search products…',
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () => _showProductDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add product'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            all.isEmpty
                                ? 'No products yet. Click "Add product" to get started.'
                                : 'No products match your search.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                  Colors.grey.shade100),
                              columns: const [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Category')),
                                DataColumn(label: Text('Cost'), numeric: true),
                                DataColumn(label: Text('Price'), numeric: true),
                                DataColumn(label: Text('Stock'), numeric: true),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('')),
                              ],
                              rows: items.map((p) {
                                final low = p.stockQty <= p.lowStockThreshold;
                                return DataRow(cells: [
                                  DataCell(Text(p.name)),
                                  DataCell(Text(p.category ?? '—')),
                                  DataCell(Text(p.costPrice.toStringAsFixed(2))),
                                  DataCell(Text(p.salePrice.toStringAsFixed(2))),
                                  DataCell(Text('${p.stockQty}')),
                                  DataCell(Chip(
                                    label: Text(low ? 'Low stock' : 'In stock'),
                                    backgroundColor: (low
                                            ? Colors.orange
                                            : Colors.green)
                                        .withValues(alpha: 0.12),
                                    labelStyle: TextStyle(
                                      color:
                                          low ? Colors.orange[800] : Colors.green[800],
                                      fontSize: 12,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  )),
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined,
                                            size: 20),
                                        onPressed: () => _showProductDialog(
                                            context,
                                            existing: p),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            size: 20, color: Colors.red),
                                        onPressed: () =>
                                            _confirmDelete(context, p),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
