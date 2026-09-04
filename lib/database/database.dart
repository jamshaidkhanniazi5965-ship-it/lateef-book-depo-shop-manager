import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  RealColumn get purchasePrice => real()();
  RealColumn get salePrice => real()();
  IntColumn get stockQty => integer()();
  TextColumn get category => text().nullable()();
}

class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get remainingAmount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('CASH'))();
  TextColumn get paymentType => text().withDefault(const Constant('CASH'))();
  BoolColumn get isCleared => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class BillLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get billId => integer().references(Bills, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().references(Products, #id, onDelete: KeyAction.restrict)();
  TextColumn get productName => text().withDefault(const Constant(''))();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  RealColumn get lineTotal => real()();
}

class CartLine {
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const CartLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

@DriftDatabase(tables: [Products, Bills, BillLines])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          await m.createAll();
        },
      );

  Stream<List<Product>> watchAllProducts() => select(products).watch();

  Future<List<Product>> getAllProducts() => select(products).get();

  Future<int> addProduct(ProductsCompanion entry) => into(products).insert(entry);

  Future<bool> updateProduct(Product product) => update(products).replace(product);

  Future<int> deleteProduct(int id) =>
      (delete(products)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> saveBill({
    required List<CartLine> items,
    required String paymentType,
    required String customerName,
    required double paidAmount,
  }) async {
    return transaction(() async {
      final totalAmount = items.fold<double>(0, (sum, l) => sum + l.lineTotal);
      final remainingAmount = totalAmount - paidAmount;
      final isCleared = remainingAmount <= 0.01;

      final billId = await into(bills).insert(BillsCompanion(
        customerName: Value(customerName),
        totalAmount: Value(totalAmount),
        paidAmount: Value(paidAmount),
        remainingAmount: Value(remainingAmount < 0 ? 0 : remainingAmount),
        paymentType: Value(paymentType),
        paymentMethod: Value(paymentType),
        isCleared: Value(isCleared),
      ));

      for (final item in items) {
        await into(billLines).insert(BillLinesCompanion(
          billId: Value(billId),
          productId: Value(item.productId),
          productName: Value(item.productName),
          quantity: Value(item.quantity),
          unitPrice: Value(item.unitPrice),
          lineTotal: Value(item.lineTotal),
        ));

        final product =
            await (select(products)..where((p) => p.id.equals(item.productId))).getSingle();
        final newStock = product.stockQty - item.quantity;

        await (update(products)..where((p) => p.id.equals(item.productId))).write(
          ProductsCompanion(stockQty: Value(newStock < 0 ? 0 : newStock)),
        );
      }

      return billId;
    });
  }

  Stream<List<Bill>> watchUdharBills() {
    return (select(bills)
          ..where((tbl) => tbl.remainingAmount.isBiggerThanValue(0.0))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  Future<void> recordPartialPayment(
      int billId, double newTotalPaid, bool isFullyCleared) async {
    final bill = await (select(bills)..where((b) => b.id.equals(billId))).getSingle();
    final newRemaining = bill.totalAmount - newTotalPaid;

    await (update(bills)..where((b) => b.id.equals(billId))).write(
      BillsCompanion(
        paidAmount: Value(newTotalPaid),
        remainingAmount: Value(newRemaining < 0 ? 0 : newRemaining),
        isCleared: Value(isFullyCleared),
      ),
    );
  }

  Future<List<Bill>> getAllBills() =>
      (select(bills)..orderBy([(b) => OrderingTerm.desc(b.createdAt)])).get();

  Future<List<CartLine>> getBillLinesForBill(int billId) async {
    final rows = await (select(billLines)..where((l) => l.billId.equals(billId))).get();
    return rows
        .map((r) => CartLine(
              productId: r.productId,
              productName: r.productName,
              quantity: r.quantity,
              unitPrice: r.unitPrice,
            ))
        .toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'shop_management.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final db = AppDatabase();


