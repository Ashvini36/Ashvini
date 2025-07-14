// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localDatabase.dart';

// ignore_for_file: type=lint
class $CartProductsTable extends CartProducts with TableInfo<$CartProductsTable, CartProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $CartProductsTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _category_idMeta = const VerificationMeta('category_id');
  late final GeneratedColumn<String> category_id = GeneratedColumn<String>('category_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50), type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>('photo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>('price', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _discountPriceMeta = const VerificationMeta('discountPrice');
  @override
  late final GeneratedColumn<String> discountPrice = GeneratedColumn<String>('discountPrice', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>('quantity', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta('hsn_code');
  @override
  late final GeneratedColumn<String> hsn_code = GeneratedColumn<String>('hsn_code', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta = const VerificationMeta('discount');
  @override
  late final GeneratedColumn<String> discount = GeneratedColumn<String>('discount', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  late final GeneratedColumn<String> unit = GeneratedColumn<String>('unit', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);

  // static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  // late final GeneratedColumn<String> tax = GeneratedColumn<String>('tax', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);

  static const VerificationMeta _variant_infoMeta = const VerificationMeta('variant_info');
  late final GeneratedColumn<String> variant_info = GeneratedColumn<String>('variant_info', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);

  @override
  List<GeneratedColumn> get $columns => [
        id, category_id, name, photo, price, discountPrice, quantity, this.hsn_code, this.description, this.discount, this.unit,
        // this.tax,
        variant_info
      ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'cart_products';

  @override
  VerificationContext validateIntegrity(Insertable<CartProduct> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(_category_idMeta, category_id.isAcceptableOrUnknown(data['category_id']!, _category_idMeta));
    } else if (isInserting) {
      context.missing(_category_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(_photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    if (data.containsKey('price')) {
      context.handle(_priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('discountPrice')) {
      context.handle(_discountPriceMeta, discountPrice.isAcceptableOrUnknown(data['discountPrice']!, _discountPriceMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta, quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(_hsnCodeMeta, hsn_code.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta));
    } else if (isInserting) {
      context.missing(_hsnCodeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta, discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(_unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    // if (data.containsKey('tax')) {
    //   context.handle(_taxMeta, description.isAcceptableOrUnknown(data['tax']!, _taxMeta));
    // } else if (isInserting) {
    //   context.missing(_taxMeta);
    // }
    if (data.containsKey('variant_info')) {
      context.handle(_variant_infoMeta, variant_info.isAcceptableOrUnknown(data['variant_info']!, _variant_infoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  CartProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartProduct(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category_id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      photo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}photo'])!,
      price: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}price'])!,
      discountPrice: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}discountPrice']),
      quantity: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      hsn_code: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hsn_code'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      discount: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}discount'])!,
      unit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      //   tax: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tax']),
      variant_info: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}variant_info']),
    );
  }

  @override
  $CartProductsTable createAlias(String alias) {
    return $CartProductsTable(attachedDatabase, alias);
  }
}

class CartProduct extends DataClass implements Insertable<CartProduct> {
  final String id;
  final String category_id;
  final String name;
  final String photo;
  final String price;
  final String? discountPrice;
  late int quantity;
  final String hsn_code;
  final String description;
  final String discount;
  final String unit;

  // late dynamic tax;
  late dynamic variant_info;

  CartProduct({
    required this.id,
    required this.category_id,
    required this.name,
    required this.photo,
    required this.price,
    this.discountPrice,
    required this.quantity,
    required this.hsn_code,
    required this.description,
    required this.discount,
    required this.unit,
    // this.tax,
    this.variant_info,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(category_id);
    map['name'] = Variable<String>(name);
    map['photo'] = Variable<String>(photo);
    map['price'] = Variable<String>(price);
    if (!nullToAbsent || discountPrice != null) {
      map['discountPrice'] = Variable<String>(discountPrice);
    }
    map['quantity'] = Variable<int>(quantity);
    map['hsn_code'] = Variable<String>(hsn_code);
    map['description'] = Variable<String>(description);
    map['discount'] = Variable<String>(discount);
    map['unit'] = Variable<String>(unit);
    // if (!nullToAbsent || tax != null) {
    //   map['tax'] = Variable<String>(jsonEncode(tax));
    // }
    if (!nullToAbsent || variant_info != null) {
      map['variant_info'] = Variable<String>(jsonEncode(variant_info));
    }
    return map;
  }

  CartProductsCompanion toCompanion(bool nullToAbsent) {
    return CartProductsCompanion(
      id: Value(id),
      category_id: Value(category_id),
      name: Value(name),
      photo: Value(photo),
      price: Value(price),
      discountPrice: discountPrice == null && nullToAbsent ? const Value.absent() : Value(discountPrice),
      quantity: Value(quantity),
      hsn_code: Value(hsn_code),
      description: Value(description),
      discount: Value(discount),
      unit: Value(unit),
      //    tax: tax == null && nullToAbsent ? const Value.absent() : Value(tax),
      variant_info: variant_info == null && nullToAbsent ? const Value.absent() : Value(variant_info),
    );
  }

  factory CartProduct.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartProduct(
      id: serializer.fromJson<String>(json['id']),
      category_id: serializer.fromJson<String>(json['category_id']),
      name: serializer.fromJson<String>(json['name']),
      photo: serializer.fromJson<String>(json['photo']),
      price: serializer.fromJson<String>(json['price']),
      discountPrice: serializer.fromJson<String?>(json['discountPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      hsn_code: serializer.fromJson<String>(json['hsn_code']),
      description: serializer.fromJson<String>(json['description']),
      discount: serializer.fromJson<String>(json['discount']),
      unit: serializer.fromJson<String>(json['unit']),
      // tax: json['tax'] != null ? serializer.fromJson<TaxModel>((json.containsKey('tax') && json['tax'] != null) ? TaxModel.fromJson(json['tax']) : null) : null,
      variant_info: json['variant_info'] != null
          ? serializer.fromJson<VariantInfo>((json.containsKey('variant_info') && json['variant_info'] != null) ? VariantInfo.fromJson(json['variant_info']) : null)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id.split('~').first),
      'category_id': serializer.toJson<String>(category_id),
      'name': serializer.toJson<String>(name),
      'photo': serializer.toJson<String>(photo),
      'price': serializer.toJson<String>(price),
      'discountPrice': serializer.toJson<String?>(discountPrice),
      'quantity': serializer.toJson<int>(quantity),
      'hsn_code': serializer.toJson<String>(hsn_code),
      'description': serializer.toJson<String>(description),
      'discount': serializer.toJson<String>(discount),
      'unit': serializer.toJson<String>(unit),
      // 'tax': tax != null ? serializer.toJson<Map<String, dynamic>>(TaxModel.fromJson(jsonDecode(tax)).toJson()) : null,
      'variant_info': variant_info != null ? serializer.toJson<Map<String, dynamic>>(VariantInfo.fromJson(jsonDecode(variant_info)).toJson()) : null,
    };
  }

  CartProduct copyWith(
          {String? id,
          String? category_id,
          String? name,
          String? photo,
          String? price,
          Value<String?> discountPrice = const Value.absent(),
          int? quantity,
          String? hsn_code,
          String? description,
          String? discount,
          String? unit,
          String? tax,
          String? variant_info}) =>
      CartProduct(
        id: id ?? this.id,
        category_id: category_id ?? this.category_id,
        name: name ?? this.name,
        photo: photo ?? this.photo,
        price: price ?? this.price,
        discountPrice: discountPrice.present ? discountPrice.value : this.discountPrice,
        quantity: quantity ?? this.quantity,
        hsn_code: hsn_code ?? this.hsn_code,
        description: description ?? this.description,
        discount: discount ?? this.discount,
        unit: unit ?? this.unit,
        //   tax: tax ?? this.tax.toJson(),
        variant_info: variant_info ?? this.variant_info.toJson(),
      );

  @override
  String toString() {
    return (StringBuffer('CartProduct(')
          ..write('id: $id, ')
          ..write('category_id: $category_id, ')
          ..write('name: $name, ')
          ..write('photo: $photo, ')
          ..write('price: $price, ')
          ..write('discountPrice: $discountPrice, ')
          ..write('quantity: $quantity, ')
          ..write('hsn_code: $hsn_code, ')
          ..write('description: $description, ')
          ..write('discount: $discount, ')
          ..write('unit: $unit, ')
          // ..write('tax: $tax, ')
          ..write('variant_info: $variant_info, ')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category_id, name, photo, price, discountPrice, quantity, hsn_code, description, unit,
     // tax,
      variant_info);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartProduct &&
          other.id == this.id &&
          other.category_id == this.category_id &&
          other.name == this.name &&
          other.photo == this.photo &&
          other.price == this.price &&
          other.discountPrice == this.discountPrice &&
          other.quantity == this.quantity &&
          other.hsn_code == this.hsn_code &&
          other.description == this.description &&
          other.discount == this.discount &&
          other.unit == this.unit &&
          //  other.tax == this.tax &&
          other.variant_info == this.variant_info);
}

class CartProductsCompanion extends UpdateCompanion<CartProduct> {
  final Value<String> id;
  final Value<String> category_id;
  final Value<String> name;
  final Value<String> photo;
  final Value<String> price;
  final Value<String?> discountPrice;
  final Value<int> quantity;
  final Value<String> hsn_code;
  final Value<String> description;
  final Value<String> discount;
  final Value<String> unit;

  // final Value<String?> tax;
  final Value<String?> variant_info;

  const CartProductsCompanion({
    this.id = const Value.absent(),
    this.category_id = const Value.absent(),
    this.name = const Value.absent(),
    this.photo = const Value.absent(),
    this.price = const Value.absent(),
    this.discountPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.hsn_code = const Value.absent(),
    this.description = const Value.absent(),
    this.discount = const Value.absent(),
    this.unit = const Value.absent(),
    //this.tax = const Value.absent(),
    this.variant_info = const Value.absent(),
  });

  CartProductsCompanion.insert({
    required String id,
    required String category_id,
    required String name,
    required String photo,
    required String price,
    this.discountPrice = const Value.absent(),
    required int quantity,
    required String hsn_code,
    required String description,
    required String discount,
    required String unit,
    //  this.tax = const Value.absent(),
    this.variant_info = const Value.absent(),
  })  : id = Value(id),
        category_id = Value(category_id),
        name = Value(name),
        photo = Value(photo),
        price = Value(price),
        quantity = Value(quantity),
        hsn_code = Value(hsn_code),
        description = Value(description),
        discount = Value(discount),
        unit = Value(unit);

  static Insertable<CartProduct> custom({
    Expression<String>? id,
    Expression<String>? category_id,
    Expression<String>? name,
    Expression<String>? photo,
    Expression<String>? price,
    Expression<String>? discountPrice,
    Expression<int>? quantity,
    Expression<String>? hsn_code,
    Expression<String>? description,
    Expression<String>? discount,
    Expression<String>? unit,
    // Expression<String>? tax,
    Expression<String>? variant_info,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category_id != null) 'category_id': category_id,
      if (name != null) 'name': name,
      if (photo != null) 'photo': photo,
      if (price != null) 'price': price,
      if (discountPrice != null) 'discountPrice': discountPrice,
      if (quantity != null) 'quantity': quantity,
      if (hsn_code != null) 'hsn_code': hsn_code,
      if (description != null) 'description': description,
      if (discount != null) 'discount': discount,
      if (unit != null) 'unit': unit,
      // if (tax != null) 'tax': tax,
      if (variant_info != null) 'variant_info': variant_info,
    });
  }

  CartProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? category_id,
      Value<String>? name,
      Value<String>? photo,
      Value<String>? price,
      Value<String?>? discountPrice,
      Value<int>? quantity,
      Value<String>? hsn_code,
      Value<String>? description,
      Value<String>? discount,
      Value<String>? unit,
      //     Value<String?>? tax,
      Value<String?>? variant_info}) {
    return CartProductsCompanion(
      id: id ?? this.id,
      category_id: category_id ?? this.category_id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      hsn_code: hsn_code ?? this.hsn_code,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      unit: discount ?? this.unit,
      //  tax: tax ?? this.tax,
      variant_info: variant_info ?? this.variant_info,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category_id.present) {
      map['category_id'] = Variable<String>(category_id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (discountPrice.present) {
      map['discountPrice'] = Variable<String>(discountPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (hsn_code.present) {
      map['hsn_code'] = Variable<String>(hsn_code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (discount.present) {
      map['discount'] = Variable<String>(discount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    // if (tax.present) {
    //   map['tax'] = Variable<String>(tax.value);
    // }
    if (variant_info.present) {
      map['variant_info'] = Variable<String>(variant_info.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartProductsCompanion(')
          ..write('id: $id, ')
          ..write('category_id: $category_id, ')
          ..write('name: $name, ')
          ..write('photo: $photo, ')
          ..write('price: $price, ')
          ..write('discountPrice: $discountPrice, ')
          ..write('quantity: $quantity, ')
          ..write('hsn_code: $hsn_code, ')
          ..write('description: $description, ')
          ..write('discount: $discount, ')
          ..write('unit: $unit, ')
          // ..write('tax: $tax, ')
          ..write('variant_info: $variant_info, ')
          ..write(')'))
        .toString();
  }
}

abstract class _$CartDatabase extends GeneratedDatabase {
  _$CartDatabase(QueryExecutor e) : super(e);
  late final $CartProductsTable cartProducts = $CartProductsTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cartProducts];
}
