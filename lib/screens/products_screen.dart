import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';

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
    final purchaseCtrl =
        TextEditingController(text: existing?.purchasePrice.toString() ?? '');
    final saleCtrl =
        TextEditingController(text: existing?.salePrice.toString() ?? '');
    final stockCtrl =
        TextEditingController(text: existing?.stockQty.toString() ?? '');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add New Product' : 'Edit Product'),
        content: SizedBox(
          width: 380,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category (optional)'),
                ),
                TextField(
                  controller: barcodeCtrl,
                  decoration: const InputDecoration(labelText: 'Barcode (optional)'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: purchaseCtrl,
                        decoration: const InputDecoration(labelText: 'Purchase Price'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: saleCtrl,
                        decoration: const InputDecoration(labelText: 'Sale Price'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
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
              final purchasePrice = double.tryParse(purchaseCtrl.text) ?? 0;
              final salePrice = double.tryParse(saleCtrl.text) ?? 0;
              final stock = int.tryParse(stockCtrl.text) ?? 0;

              if (existing == null) {
                await db.addProduct(ProductsCompanion.insert(
                  name: name,
                  category: Value(category.isEmpty ? null : category),
                  barcode: Value(barcode.isEmpty ? null : barcode),
                  purchasePrice: purchasePrice,
                  salePrice: salePrice,
                  stockQty: stock,
                ));
              } else {
                await db.updateProduct(existing.copyWith(
                  name: name,
                  category: Value(category.isEmpty ? null : category),
                  barcode: Value(barcode.isEmpty ? null : barcode),
                  purchasePrice: purchasePrice,
                  salePrice: salePrice,
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
                      p.name.toLowerCase().contains(_search.toLowerCase()) ||
                      (p.barcode ?? '').toLowerCase().contains(_search.toLowerCase()))
                  .toList();

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Product Management',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => _showProductDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Product'),
                      style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search Products by Name or Barcode',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            all.isEmpty
                                ? 'No products yet. Click "Add New Product" to get started.'
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
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor:
                                  WidgetStateProperty.all(Colors.grey.shade100),
                              columns: const [
                                DataColumn(label: Text('ID', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Name', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Category', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Purchase Price', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)), numeric: true),
                                DataColumn(label: Text('Sale Price', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)), numeric: true),
                                DataColumn(label: Text('Stock', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)), numeric: true),
                                DataColumn(label: Text('Actions', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                              ],
                              rows: items.map((p) {
                                return DataRow(cells: [
                                  DataCell(Text('#${p.id}')),
                                  DataCell(Text(p.name)),
                                  DataCell(Text(p.category ?? '—')),
                                  DataCell(Text(p.purchasePrice.toStringAsFixed(2))),
                                  DataCell(Text(p.salePrice.toStringAsFixed(2))),
                                  DataCell(Text('${p.stockQty}')),
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                                        onPressed: () => _showProductDialog(context, existing: p),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                        onPressed: () => _confirmDelete(context, p),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
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

