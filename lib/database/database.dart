import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// TABLES
// ---------------------------------------------------------------------------

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text().nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get costPrice => real().withDefault(const Constant(0))();
  RealColumn get salePrice => real().withDefault(const Constant(0))();
  IntColumn get stockQty => integer().withDefault(const Constant(0))();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(5))();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  // Positive balance = customer owes the shop (udhaar / credit).
  RealColumn get creditBalance => real().withDefault(const Constant(0))();
}

class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId =>
      integer().nullable().references(Customers, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  RealColumn get total => real()();
  // How much of `total` has actually been collected. For a cash sale this
  // equals `total`. For a credit (udhaar) sale it can be 0 or a partial
  // amount; `total - amountPaid` is what the customer still owes.
  RealColumn get amountPaid => real().withDefault(const Constant(0))();
  // 'cash' or 'credit'
  TextColumn get paymentType => text().withDefault(const Constant('cash'))();
}

class BillItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get billId => integer().references(Bills, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
}

// A single item the billing screen is building up before it's saved.
class BillLine {
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const BillLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

// ---------------------------------------------------------------------------
// DATABASE
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [Products, Customers, Bills, BillItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(products, products.barcode);
            await m.addColumn(bills, bills.amountPaid);
          }
        },
      );

  // ---- Products ---------------------------------------------------------

  Future<List<Product>> getAllProducts() => select(products).get();

  Stream<List<Product>> watchAllProducts() => select(products).watch();

  Future<List<Product>> getLowStockProducts() {
    return (select(products)
          ..where((p) => p.stockQty.isSmallerOrEqual(p.lowStockThreshold)))
        .get();
  }

  Future<int> addProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Future<bool> updateProduct(Product product) =>
      update(products).replace(product);

  Future<int> deleteProduct(int id) =>
      (delete(products)..where((p) => p.id.equals(id))).go();

  // ---- Customers ----------------------------------------------------------

  Future<List<Customer>> getAllCustomers() => select(customers).get();

  Future<int> addCustomer(CustomersCompanion customer) =>
      into(customers).insert(customer);

  // ---- Billing: THE critical atomic operation ----------------------------
  //
  // Saving a bill must never leave stock counts wrong if something fails
  // partway through, so everything below runs inside one transaction.
  // If any step throws, drift rolls back the entire thing automatically.

  Future<int> saveBill({
    required List<BillLine> items,
    int? customerId,
    String paymentType = 'cash',
    double? amountPaid,
  }) async {
    final total = items.fold<double>(0, (sum, line) => sum + line.lineTotal);
    // Cash sales are fully paid by definition. Credit sales default to
    // fully unpaid (0) unless the shop owner records a partial payment
    // at time of sale.
    final paid = paymentType == 'cash' ? total : (amountPaid ?? 0);

    return transaction(() async {
      // 1. Create the bill header.
      final billId = await into(bills).insert(
        BillsCompanion.insert(
          total: total,
          customerId: Value(customerId),
          paymentType: Value(paymentType),
          amountPaid: Value(paid),
        ),
      );

      // 2. Insert each line item and deduct stock.
      for (final line in items) {
        await into(billItems).insert(
          BillItemsCompanion.insert(
            billId: billId,
            productId: line.productId,
            quantity: line.quantity,
            unitPrice: line.unitPrice,
          ),
        );

        final product = await (select(products)
              ..where((p) => p.id.equals(line.productId)))
            .getSingle();

        final newStock = product.stockQty - line.quantity;
        if (newStock < 0) {
          // Throwing here rolls back the whole transaction, including
          // the bill and item rows already inserted above.
          throw StateError(
            'Not enough stock for "${product.name}" '
            '(have ${product.stockQty}, need ${line.quantity})',
          );
        }

        await (update(products)..where((p) => p.id.equals(line.productId)))
            .write(ProductsCompanion(stockQty: Value(newStock)));
      }

      // 3. If sold on credit, add the unpaid portion to the customer's balance.
      final unpaid = total - paid;
      if (unpaid > 0 && customerId != null) {
        final customer = await (select(customers)
              ..where((c) => c.id.equals(customerId)))
            .getSingle();

        await (update(customers)..where((c) => c.id.equals(customerId)))
            .write(CustomersCompanion(
          creditBalance: Value(customer.creditBalance + unpaid),
        ));
      }

      return billId;
    });
  }

  Future<String> getCustomerName(int? customerId) async {
    if (customerId == null) return 'Walk-in customer';
    final customer = await (select(customers)
          ..where((c) => c.id.equals(customerId)))
        .getSingleOrNull();
    return customer?.name ?? 'Walk-in customer';
  }

  Future<Product?> findProductByBarcode(String barcode) {
    return (select(products)..where((p) => p.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  // ---- Reports ------------------------------------------------------------

  Future<double> getSalesTotalBetween(DateTime start, DateTime end) async {
    final query = selectOnly(bills)
      ..addColumns([bills.total.sum()])
      ..where(bills.date.isBetweenValues(start, end));
    final row = await query.getSingle();
    return row.read(bills.total.sum()) ?? 0;
  }

  Future<List<Bill>> getBillsBetween(DateTime start, DateTime end) {
    return (select(bills)..where((b) => b.date.isBetweenValues(start, end)))
        .get();
  }

  Future<int> getProductCount() async {
    final query = selectOnly(products)..addColumns([products.id.count()]);
    final row = await query.getSingle();
    return row.read(products.id.count()) ?? 0;
  }

  Future<int> getLowStockCount() async {
    final rows = await getLowStockProducts();
    return rows.length;
  }

  /// Profit = (unit_price - product.cost_price) * quantity, summed across
  /// every bill_item belonging to a bill in the given date range.
  Future<double> getProfitBetween(DateTime start, DateTime end) async {
    final query = select(billItems).join([
      innerJoin(bills, bills.id.equalsExp(billItems.billId)),
      innerJoin(products, products.id.equalsExp(billItems.productId)),
    ])
      ..where(bills.date.isBetweenValues(start, end));

    final rows = await query.get();
    double profit = 0;
    for (final row in rows) {
      final item = row.readTable(billItems);
      final product = row.readTable(products);
      profit += (item.unitPrice - product.costPrice) * item.quantity;
    }
    return profit;
  }
}

// ---------------------------------------------------------------------------
// Connection: a plain file on disk in the user's app-data folder.
// This is what makes the whole app work with zero internet connection.
// ---------------------------------------------------------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'shop_data.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
