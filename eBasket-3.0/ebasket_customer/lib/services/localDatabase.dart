import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/variant_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'localDatabase.g.dart';

class CartProducts extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(max: 50)();

  TextColumn get photo => text()();

  TextColumn get price => text()();

  TextColumn get discountPrice => text().nullable()();

  IntColumn get quantity => integer()();

  TextColumn get hsn_code => text()();

  TextColumn get description => text()();

  TextColumn get discount => text()();

  TextColumn get unit => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CartProducts])
class CartDatabase extends _$CartDatabase {
  CartDatabase() : super(_openConnection());

  addProduct(ProductModel model, CartDatabase cartDatabase, bool isIncrementQuantity) async {
    String mainPrice = "";

    bool isAddSame = false;

    if (!isAddSame) {
      if (model.discount != null && model.discount!.isNotEmpty && double.parse(model.discount!) != 0) {
        mainPrice = (double.parse(model.price.toString()) - ((double.parse(model.price.toString()) * double.parse(model.discount.toString())) / 100)).toString();
      } else {
        mainPrice = model.price.toString();
      }
    }

    allCartProducts.then((products) async {
      final bool productIsInList = products.any((product) => product.id == ("${model.id!}~${model.variantInfo != null ? model.variantInfo!.variantId.toString() : ""}"));
      if (productIsInList) {
        CartProduct element = products.firstWhere((product) => product.id == ("${model.id!}~${model.variantInfo != null ? model.variantInfo!.variantId.toString() : ""}"));
        await cartDatabase.updateProduct(CartProduct(
            id: element.id,
            name: element.name,
            photo: element.photo,
            price: element.price,
            quantity: isIncrementQuantity ? element.quantity + 1 : element.quantity,
            category_id: element.category_id,
            discountPrice: element.discountPrice!,
            hsn_code: element.hsn_code,
            description: element.description,
            discount: element.discount,
            unit: element.unit));
      } else {

        CartProduct entity = CartProduct(
            id: "${model.id}~${model.variantInfo != null ? model.variantInfo!.variantId.toString() : ""}",
            category_id: model.categoryID!,
            name: model.name!,
            photo: model.photo!,
            price: model.price!,
            discountPrice: (model.discount != null && model.discount!.isNotEmpty && double.parse(model.discount!) != 0) ? mainPrice : '0',
            quantity: isIncrementQuantity ? 1 : 0,
            hsn_code: model.hsn_code!,
            description: model.description!,
            discount: model.discount!,
            unit: model.unit!,
            //tax: model.taxModel,
            variant_info: model.variantInfo);
        if (products.where((element) => element.id == model.id).isEmpty) {
          into(cartProducts).insert(entity);
        } else {
          updateProduct(entity);
        }
      }
    });
  }

  reAddProduct(CartProduct cartProduct) => into(cartProducts).insert(cartProduct);

  removeProduct(String productID) => (delete(cartProducts)..where((product) => product.id.equals(productID))).go();

  deleteAllProducts() => (delete(cartProducts)).go();

  updateProduct(CartProduct entity) => (update(cartProducts)..where((product) => product.id.equals(entity.id))).write(entity);

  @override
  int get schemaVersion => 2;

  Future<List<CartProduct>> get allCartProducts => select(cartProducts).get();

  Stream<List<CartProduct>> get watchProducts => select(cartProducts).watch();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    print("Database path");
    print(dbFolder.path);
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
