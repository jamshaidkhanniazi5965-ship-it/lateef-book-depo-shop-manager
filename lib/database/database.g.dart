// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _salePriceMeta =
      const VerificationMeta('salePrice');
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
      'sale_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockQtyMeta =
      const VerificationMeta('stockQty');
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
      'stock_qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, barcode, purchasePrice, salePrice, stockQty, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(_salePriceMeta,
          salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta));
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('stock_qty')) {
      context.handle(_stockQtyMeta,
          stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta));
    } else if (isInserting) {
      context.missing(_stockQtyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price'])!,
      salePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sale_price'])!,
      stockQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_qty'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? barcode;
  final double purchasePrice;
  final double salePrice;
  final int stockQty;
  final String? category;
  const Product(
      {required this.id,
      required this.name,
      this.barcode,
      required this.purchasePrice,
      required this.salePrice,
      required this.stockQty,
      this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['sale_price'] = Variable<double>(salePrice);
    map['stock_qty'] = Variable<int>(stockQty);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      purchasePrice: Value(purchasePrice),
      salePrice: Value(salePrice),
      stockQty: Value(stockQty),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'salePrice': serializer.toJson<double>(salePrice),
      'stockQty': serializer.toJson<int>(stockQty),
      'category': serializer.toJson<String?>(category),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> barcode = const Value.absent(),
          double? purchasePrice,
          double? salePrice,
          int? stockQty,
          Value<String?> category = const Value.absent()}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        barcode: barcode.present ? barcode.value : this.barcode,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        salePrice: salePrice ?? this.salePrice,
        stockQty: stockQty ?? this.stockQty,
        category: category.present ? category.value : this.category,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, barcode, purchasePrice, salePrice, stockQty, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.purchasePrice == this.purchasePrice &&
          other.salePrice == this.salePrice &&
          other.stockQty == this.stockQty &&
          other.category == this.category);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<double> purchasePrice;
  final Value<double> salePrice;
  final Value<int> stockQty;
  final Value<String?> category;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.category = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.barcode = const Value.absent(),
    required double purchasePrice,
    required double salePrice,
    required int stockQty,
    this.category = const Value.absent(),
  })  : name = Value(name),
        purchasePrice = Value(purchasePrice),
        salePrice = Value(salePrice),
        stockQty = Value(stockQty);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<double>? purchasePrice,
    Expression<double>? salePrice,
    Expression<int>? stockQty,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (stockQty != null) 'stock_qty': stockQty,
      if (category != null) 'category': category,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? barcode,
      Value<double>? purchasePrice,
      Value<double>? salePrice,
      Value<int>? stockQty,
      Value<String?>? category}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      stockQty: stockQty ?? this.stockQty,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, Bill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _remainingAmountMeta =
      const VerificationMeta('remainingAmount');
  @override
  late final GeneratedColumn<double> remainingAmount = GeneratedColumn<double>(
      'remaining_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CASH'));
  static const VerificationMeta _paymentTypeMeta =
      const VerificationMeta('paymentType');
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
      'payment_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CASH'));
  static const VerificationMeta _isClearedMeta =
      const VerificationMeta('isCleared');
  @override
  late final GeneratedColumn<bool> isCleared = GeneratedColumn<bool>(
      'is_cleared', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_cleared" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerName,
        totalAmount,
        paidAmount,
        remainingAmount,
        paymentMethod,
        paymentType,
        isCleared,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(Insertable<Bill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
          _remainingAmountMeta,
          remainingAmount.isAcceptableOrUnknown(
              data['remaining_amount']!, _remainingAmountMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('payment_type')) {
      context.handle(
          _paymentTypeMeta,
          paymentType.isAcceptableOrUnknown(
              data['payment_type']!, _paymentTypeMeta));
    }
    if (data.containsKey('is_cleared')) {
      context.handle(_isClearedMeta,
          isCleared.isAcceptableOrUnknown(data['is_cleared']!, _isClearedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      remainingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      paymentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_type'])!,
      isCleared: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_cleared'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }
}

class Bill extends DataClass implements Insertable<Bill> {
  final int id;
  final String customerName;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String paymentMethod;
  final String paymentType;
  final bool isCleared;
  final DateTime createdAt;
  const Bill(
      {required this.id,
      required this.customerName,
      required this.totalAmount,
      required this.paidAmount,
      required this.remainingAmount,
      required this.paymentMethod,
      required this.paymentType,
      required this.isCleared,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['total_amount'] = Variable<double>(totalAmount);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['remaining_amount'] = Variable<double>(remainingAmount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['payment_type'] = Variable<String>(paymentType);
    map['is_cleared'] = Variable<bool>(isCleared);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      customerName: Value(customerName),
      totalAmount: Value(totalAmount),
      paidAmount: Value(paidAmount),
      remainingAmount: Value(remainingAmount),
      paymentMethod: Value(paymentMethod),
      paymentType: Value(paymentType),
      isCleared: Value(isCleared),
      createdAt: Value(createdAt),
    );
  }

  factory Bill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bill(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      remainingAmount: serializer.fromJson<double>(json['remainingAmount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      isCleared: serializer.fromJson<bool>(json['isCleared']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'remainingAmount': serializer.toJson<double>(remainingAmount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paymentType': serializer.toJson<String>(paymentType),
      'isCleared': serializer.toJson<bool>(isCleared),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bill copyWith(
          {int? id,
          String? customerName,
          double? totalAmount,
          double? paidAmount,
          double? remainingAmount,
          String? paymentMethod,
          String? paymentType,
          bool? isCleared,
          DateTime? createdAt}) =>
      Bill(
        id: id ?? this.id,
        customerName: customerName ?? this.customerName,
        totalAmount: totalAmount ?? this.totalAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentType: paymentType ?? this.paymentType,
        isCleared: isCleared ?? this.isCleared,
        createdAt: createdAt ?? this.createdAt,
      );
  Bill copyWithCompanion(BillsCompanion data) {
    return Bill(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentType:
          data.paymentType.present ? data.paymentType.value : this.paymentType,
      isCleared: data.isCleared.present ? data.isCleared.value : this.isCleared,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bill(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentType: $paymentType, ')
          ..write('isCleared: $isCleared, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerName, totalAmount, paidAmount,
      remainingAmount, paymentMethod, paymentType, isCleared, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.totalAmount == this.totalAmount &&
          other.paidAmount == this.paidAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentType == this.paymentType &&
          other.isCleared == this.isCleared &&
          other.createdAt == this.createdAt);
}

class BillsCompanion extends UpdateCompanion<Bill> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<double> totalAmount;
  final Value<double> paidAmount;
  final Value<double> remainingAmount;
  final Value<String> paymentMethod;
  final Value<String> paymentType;
  final Value<bool> isCleared;
  final Value<DateTime> createdAt;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.isCleared = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BillsCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.isCleared = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : customerName = Value(customerName);
  static Insertable<Bill> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<double>? totalAmount,
    Expression<double>? paidAmount,
    Expression<double>? remainingAmount,
    Expression<String>? paymentMethod,
    Expression<String>? paymentType,
    Expression<bool>? isCleared,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentType != null) 'payment_type': paymentType,
      if (isCleared != null) 'is_cleared': isCleared,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BillsCompanion copyWith(
      {Value<int>? id,
      Value<String>? customerName,
      Value<double>? totalAmount,
      Value<double>? paidAmount,
      Value<double>? remainingAmount,
      Value<String>? paymentMethod,
      Value<String>? paymentType,
      Value<bool>? isCleared,
      Value<DateTime>? createdAt}) {
    return BillsCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentType: paymentType ?? this.paymentType,
      isCleared: isCleared ?? this.isCleared,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<double>(remainingAmount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (isCleared.present) {
      map['is_cleared'] = Variable<bool>(isCleared.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentType: $paymentType, ')
          ..write('isCleared: $isCleared, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BillLinesTable extends BillLines
    with TableInfo<$BillLinesTable, BillLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
      'bill_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bills (id) ON DELETE CASCADE'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES products (id) ON DELETE RESTRICT'));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, billId, productId, productName, quantity, unitPrice, lineTotal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_lines';
  @override
  VerificationContext validateIntegrity(Insertable<BillLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_id')) {
      context.handle(_billIdMeta,
          billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta));
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      billId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bill_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
    );
  }

  @override
  $BillLinesTable createAlias(String alias) {
    return $BillLinesTable(attachedDatabase, alias);
  }
}

class BillLine extends DataClass implements Insertable<BillLine> {
  final int id;
  final int billId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  const BillLine(
      {required this.id,
      required this.billId,
      required this.productId,
      required this.productName,
      required this.quantity,
      required this.unitPrice,
      required this.lineTotal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_id'] = Variable<int>(billId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['line_total'] = Variable<double>(lineTotal);
    return map;
  }

  BillLinesCompanion toCompanion(bool nullToAbsent) {
    return BillLinesCompanion(
      id: Value(id),
      billId: Value(billId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
    );
  }

  factory BillLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillLine(
      id: serializer.fromJson<int>(json['id']),
      billId: serializer.fromJson<int>(json['billId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billId': serializer.toJson<int>(billId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'lineTotal': serializer.toJson<double>(lineTotal),
    };
  }

  BillLine copyWith(
          {int? id,
          int? billId,
          int? productId,
          String? productName,
          int? quantity,
          double? unitPrice,
          double? lineTotal}) =>
      BillLine(
        id: id ?? this.id,
        billId: billId ?? this.billId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        lineTotal: lineTotal ?? this.lineTotal,
      );
  BillLine copyWithCompanion(BillLinesCompanion data) {
    return BillLine(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillLine(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, billId, productId, productName, quantity, unitPrice, lineTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillLine &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal);
}

class BillLinesCompanion extends UpdateCompanion<BillLine> {
  final Value<int> id;
  final Value<int> billId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<int> quantity;
  final Value<double> unitPrice;
  final Value<double> lineTotal;
  const BillLinesCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
  });
  BillLinesCompanion.insert({
    this.id = const Value.absent(),
    required int billId,
    required int productId,
    this.productName = const Value.absent(),
    required int quantity,
    this.unitPrice = const Value.absent(),
    required double lineTotal,
  })  : billId = Value(billId),
        productId = Value(productId),
        quantity = Value(quantity),
        lineTotal = Value(lineTotal);
  static Insertable<BillLine> custom({
    Expression<int>? id,
    Expression<int>? billId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<int>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? lineTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
    });
  }

  BillLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? billId,
      Value<int>? productId,
      Value<String>? productName,
      Value<int>? quantity,
      Value<double>? unitPrice,
      Value<double>? lineTotal}) {
    return BillLinesCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillLinesCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $BillLinesTable billLines = $BillLinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [products, bills, billLines];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('bills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('bill_lines', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> barcode,
  required double purchasePrice,
  required double salePrice,
  required int stockQty,
  Value<String?> category,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> barcode,
  Value<double> purchasePrice,
  Value<double> salePrice,
  Value<int> stockQty,
  Value<String?> category,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillLinesTable, List<BillLine>>
      _billLinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.billLines,
              aliasName: 'products__id__bill_lines__product_id');

  $$BillLinesTableProcessedTableManager get billLinesRefs {
    final manager = $$BillLinesTableTableManager($_db, $_db.billLines)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  Expression<bool> billLinesRefs(
      Expression<bool> Function($$BillLinesTableFilterComposer f) f) {
    final $$BillLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.billLines,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillLinesTableFilterComposer(
              $db: $db,
              $table: $db.billLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> billLinesRefs<T extends Object>(
      Expression<T> Function($$BillLinesTableAnnotationComposer a) f) {
    final $$BillLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.billLines,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.billLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool billLinesRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<double> salePrice = const Value.absent(),
            Value<int> stockQty = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            barcode: barcode,
            purchasePrice: purchasePrice,
            salePrice: salePrice,
            stockQty: stockQty,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> barcode = const Value.absent(),
            required double purchasePrice,
            required double salePrice,
            required int stockQty,
            Value<String?> category = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            barcode: barcode,
            purchasePrice: purchasePrice,
            salePrice: salePrice,
            stockQty: stockQty,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({billLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billLinesRefs) db.billLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billLinesRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            BillLine>(
                        currentTable: table,
                        referencedTable:
                            $$ProductsTableReferences._billLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .billLinesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool billLinesRefs})>;
typedef $$BillsTableCreateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  required String customerName,
  Value<double> totalAmount,
  Value<double> paidAmount,
  Value<double> remainingAmount,
  Value<String> paymentMethod,
  Value<String> paymentType,
  Value<bool> isCleared,
  Value<DateTime> createdAt,
});
typedef $$BillsTableUpdateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  Value<String> customerName,
  Value<double> totalAmount,
  Value<double> paidAmount,
  Value<double> remainingAmount,
  Value<String> paymentMethod,
  Value<String> paymentType,
  Value<bool> isCleared,
  Value<DateTime> createdAt,
});

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, Bill> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillLinesTable, List<BillLine>>
      _billLinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.billLines,
              aliasName: 'bills__id__bill_lines__bill_id');

  $$BillLinesTableProcessedTableManager get billLinesRefs {
    final manager = $$BillLinesTableTableManager($_db, $_db.billLines)
        .filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCleared => $composableBuilder(
      column: $table.isCleared, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> billLinesRefs(
      Expression<bool> Function($$BillLinesTableFilterComposer f) f) {
    final $$BillLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.billLines,
        getReferencedColumn: (t) => t.billId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillLinesTableFilterComposer(
              $db: $db,
              $table: $db.billLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCleared => $composableBuilder(
      column: $table.isCleared, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => column);

  GeneratedColumn<bool> get isCleared =>
      $composableBuilder(column: $table.isCleared, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> billLinesRefs<T extends Object>(
      Expression<T> Function($$BillLinesTableAnnotationComposer a) f) {
    final $$BillLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.billLines,
        getReferencedColumn: (t) => t.billId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.billLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillsTable,
    Bill,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (Bill, $$BillsTableReferences),
    Bill,
    PrefetchHooks Function({bool billLinesRefs})> {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> remainingAmount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> paymentType = const Value.absent(),
            Value<bool> isCleared = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BillsCompanion(
            id: id,
            customerName: customerName,
            totalAmount: totalAmount,
            paidAmount: paidAmount,
            remainingAmount: remainingAmount,
            paymentMethod: paymentMethod,
            paymentType: paymentType,
            isCleared: isCleared,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String customerName,
            Value<double> totalAmount = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> remainingAmount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> paymentType = const Value.absent(),
            Value<bool> isCleared = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BillsCompanion.insert(
            id: id,
            customerName: customerName,
            totalAmount: totalAmount,
            paidAmount: paidAmount,
            remainingAmount: remainingAmount,
            paymentMethod: paymentMethod,
            paymentType: paymentType,
            isCleared: isCleared,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BillsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({billLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billLinesRefs) db.billLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billLinesRefs)
                    await $_getPrefetchedData<Bill, $BillsTable, BillLine>(
                        currentTable: table,
                        referencedTable:
                            $$BillsTableReferences._billLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BillsTableReferences(db, table, p0).billLinesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.billId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillsTable,
    Bill,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (Bill, $$BillsTableReferences),
    Bill,
    PrefetchHooks Function({bool billLinesRefs})>;
typedef $$BillLinesTableCreateCompanionBuilder = BillLinesCompanion Function({
  Value<int> id,
  required int billId,
  required int productId,
  Value<String> productName,
  required int quantity,
  Value<double> unitPrice,
  required double lineTotal,
});
typedef $$BillLinesTableUpdateCompanionBuilder = BillLinesCompanion Function({
  Value<int> id,
  Value<int> billId,
  Value<int> productId,
  Value<String> productName,
  Value<int> quantity,
  Value<double> unitPrice,
  Value<double> lineTotal,
});

final class $$BillLinesTableReferences
    extends BaseReferences<_$AppDatabase, $BillLinesTable, BillLine> {
  $$BillLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('bill_lines__bill_id__bills__id');

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<int>('bill_id')!;

    final manager = $$BillsTableTableManager($_db, $_db.bills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('bill_lines__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BillLinesTableFilterComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableFilterComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableOrderingComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableAnnotationComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillLinesTable,
    BillLine,
    $$BillLinesTableFilterComposer,
    $$BillLinesTableOrderingComposer,
    $$BillLinesTableAnnotationComposer,
    $$BillLinesTableCreateCompanionBuilder,
    $$BillLinesTableUpdateCompanionBuilder,
    (BillLine, $$BillLinesTableReferences),
    BillLine,
    PrefetchHooks Function({bool billId, bool productId})> {
  $$BillLinesTableTableManager(_$AppDatabase db, $BillLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> billId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
          }) =>
              BillLinesCompanion(
            id: id,
            billId: billId,
            productId: productId,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            lineTotal: lineTotal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int billId,
            required int productId,
            Value<String> productName = const Value.absent(),
            required int quantity,
            Value<double> unitPrice = const Value.absent(),
            required double lineTotal,
          }) =>
              BillLinesCompanion.insert(
            id: id,
            billId: billId,
            productId: productId,
            productName: productName,
            quantity: quantity,
            unitPrice: unitPrice,
            lineTotal: lineTotal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BillLinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({billId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (billId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.billId,
                    referencedTable:
                        $$BillLinesTableReferences._billIdTable(db),
                    referencedColumn:
                        $$BillLinesTableReferences._billIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$BillLinesTableReferences._productIdTable(db),
                    referencedColumn:
                        $$BillLinesTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BillLinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillLinesTable,
    BillLine,
    $$BillLinesTableFilterComposer,
    $$BillLinesTableOrderingComposer,
    $$BillLinesTableAnnotationComposer,
    $$BillLinesTableCreateCompanionBuilder,
    $$BillLinesTableUpdateCompanionBuilder,
    (BillLine, $$BillLinesTableReferences),
    BillLine,
    PrefetchHooks Function({bool billId, bool productId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$BillLinesTableTableManager get billLines =>
      $$BillLinesTableTableManager(_db, _db.billLines);
}
