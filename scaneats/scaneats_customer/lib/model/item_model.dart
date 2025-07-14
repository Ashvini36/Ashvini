import 'package:scaneats_customer/model/item_attributes.dart';

class ItemModel {
  String? id;
  String? name;
  String? price;
  String? categoryId;
  String? itemType;
  bool? isFeature;
  String? image;
  bool? isActive;
  String? caution;
  String? description;
  List<Addons>? addons;
  ItemAttributes? itemAttributes;
  String? variantId;
  int? qty;
  String? disPrice;
  String? specialInstructions;

  ItemModel(
      {this.id,
        this.name,
        this.price,
        this.categoryId,
        this.itemType,
        this.isFeature,
        this.image,
        this.isActive,
        this.caution,
        this.description,
        this.addons,
        this.itemAttributes,
        this.variantId,
        this.qty,
        this.disPrice,
        this.specialInstructions});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'] ?? '0';
    categoryId = json['categoryId'];
    itemType = json['itemType'];
    isFeature = json['isFeature'];
    image = json['image'];
    isActive = json['isActive'];
    caution = json['caution'];
    itemAttributes = (json.containsKey('item_attribute') && json['item_attribute'] != null) ? ItemAttributes.fromJson(json['item_attribute']) : null;
    variantId = json['variantId'];
    description = json['description'];
    addons = json.containsKey('addons') ? List<Addons>.from((json['addons'] as List<dynamic>).map((e) => Addons.fromJson(e))).toList() : [];
    qty = json['qty'] ?? 0;
    disPrice = json['disPrice'] ?? '0';
    specialInstructions = json['specialInstructions'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price ?? '0';
    data['categoryId'] = categoryId;
    data['itemType'] = itemType;
    data['isFeature'] = isFeature;
    data['image'] = image;
    data['isActive'] = isActive;
    data['caution'] = caution;
    data['description'] = description;
    // ignore: prefer_null_aware_operators
    data['item_attribute'] = itemAttributes != null ? itemAttributes!.toJson() : null;
    data['variantId'] = variantId;
    if (addons != null) data['addons'] = addons!.map((e) => e.toJson()).toList();
    data['qty'] = qty ?? 0;
    data['disPrice'] = disPrice ?? '0';
    // data['totalCost'] = totalCost ?? 0.0;
    data['specialInstructions'] = specialInstructions ?? '';
    return data;
  }
}

class Addons {
  String? id;
  bool? isActive;
  String? name;
  String? price;
  String? image;
  int? qty;

  Addons({this.id, this.name, this.price, this.isActive, this.image, this.qty = 0});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    name = json['name'];
    price = json['price'] ?? '0';
    image = json['image'];
    qty = json['qty'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isActive'] = isActive;
    data['name'] = name;
    data['price'] = price ?? '0';
    data['image'] = image;
    data['qty'] = qty ?? 0;
    return data;
  }
}
