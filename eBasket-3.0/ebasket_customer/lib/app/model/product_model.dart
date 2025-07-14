import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/variant_info.dart';

class ProductModel {
  String? id;
  String? categoryID;
  String? description;
  String? photo;
  List<dynamic>? photos;
  String? price;
  String? name;
  int? quantity;
  int? productQuantity;
  bool? publish;
  String? discount = "0";
  String? qty_pack;
  ItemAttributes? itemAttributes;
  Map<String, dynamic>? reviewAttributes;
  num? reviewsCount;
  num? reviewsSum;
  VariantInfo? variantInfo;
  String? brandID;

  String? shelf_life;
  String? country;
  String? seller_fssai;
  Timestamp? expiry_date;
  String? seller;
  String? packaging_type;
  String? license_fssai;
  String? disclaimer;
  String? hsn_code;
  bool? is_best_offer;
  bool? is_establish_brand;
  String? unit;

  ProductModel({
    this.id,
    this.categoryID,
    this.brandID,
    this.description,
    this.photo,
    this.photos,
    this.price,
    this.name,
    this.quantity = 0,
    this.productQuantity = 0,
    this.publish = true,
    this.discount,
    this.qty_pack,
    this.reviewsCount = 0,
    this.reviewsSum = 0,
    this.itemAttributes,
    this.reviewAttributes,
    this.variantInfo,
    this.shelf_life,
    this.country,
    this.seller_fssai,
    this.expiry_date,
    this.seller,
    this.packaging_type,
    this.license_fssai,
    this.disclaimer,
    this.hsn_code,
    this.is_best_offer = false,
    this.is_establish_brand = false,
    this.unit,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryID = json['categoryID'];
    brandID = json['brandID'];
    description = json['description'];
    photo = json['photo'];
    photos = json['photos'] ?? [];
    price = json['price'] ?? '';
    quantity = json['quantity'] ?? 0;
    productQuantity = 0;
    name = json['name'] ?? '';
    publish = json['publish'] ?? true;
    discount = json['discount'] ?? '0';
    qty_pack = json['qty_pack'];
    reviewsCount = json['reviewsCount'] ?? 0;
    reviewsSum = json['reviewsSum'] ?? 0;
    reviewAttributes = json['reviewAttributes'] ?? {};
    itemAttributes = (json.containsKey('item_attribute') && json['item_attribute'] != null) ? ItemAttributes.fromJson(json['item_attribute']) : null;
    variantInfo = (json.containsKey('variant_info') && json['variant_info'] != null)
        ? json['variant_info'].runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>'
            ? VariantInfo.fromJson(json['variant_info'])
            : null
        : null;
    shelf_life = json['shelf_life'];
    country = json['country'];
    seller_fssai = json['seller_fssai'];
    expiry_date = json['expiry_date'];
    seller = json['seller'];
    packaging_type = json['packaging_type'];
    license_fssai = json['license_fssai'];
    disclaimer = json['disclaimer'];
    hsn_code = json['hsn_code'];
    is_best_offer = json['is_best_offer'] ?? true;
    is_establish_brand = json['is_establish_brand'] ?? true;
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    photos!.toList().removeWhere((element) => element == null);

    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryID'] = categoryID;
    data['brandID'] = brandID;
    data['description'] = description;
    data['photo'] = photo;
    data['photos'] = photos;
    data['price'] = price;
    data['name'] = name;
    data['quantity'] = quantity;
    data['publish'] = publish;
    data['discount'] = discount;
    data['qty_pack'] = qty_pack;
    if (itemAttributes == null) {
      data['item_attribute'] = null;
    } else {
      data['item_attribute'] = itemAttributes!.toJson();
    }
    data['reviewAttributes'] = reviewAttributes;
    data['reviewsCount'] = reviewsCount;
    data['reviewsSum'] = reviewsSum;
    data['shelf_life'] = shelf_life;
    data['country'] = country;
    data['seller_fssai'] = seller_fssai;
    data['expiry_date'] = expiry_date;
    data['seller'] = seller;
    data['packaging_type'] = packaging_type;
    data['license_fssai'] = license_fssai;
    data['disclaimer'] = disclaimer;
    data['hsn_code'] = hsn_code;
    data['is_best_offer'] = is_best_offer;
    data['is_establish_brand'] = is_establish_brand;
    data['unit'] = unit;
    return data;
  }
}

class ReviewsAttribute {
  num? reviewsCount;
  num? reviewsSum;

  ReviewsAttribute({
    this.reviewsCount,
    this.reviewsSum,
  });

  ReviewsAttribute.fromJson(Map<String, dynamic> json) {
    reviewsCount = json['reviewsCount'] ?? 0;
    reviewsSum = json['reviewsSum'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reviewsCount'] = reviewsCount;
    data['reviewsSum'] = reviewsSum;
    return data;
  }
}
