import 'package:ebasket_driver/app/model/tax_model.dart';
import 'package:ebasket_driver/app/model/variant_info.dart';

class ProductModel {
  String? id;
  String? category_id;
  String? name;
  String? photo;
  String? price;
  String? discountPrice;
  int? quantity;
  String? hsn_code;
  String? description;
  String? discount = "0";
  String? unit;
  VariantInfo? variantInfo;
 // TaxModel? taxModel;

  ProductModel({
    this.id = "",
    this.category_id = "",
    this.name = "",
    this.photo = "",
    this.price = "",
    this.discountPrice = "",
    this.quantity,
    this.hsn_code,
    this.description,
    this.discount,
    this.unit,
    this.variantInfo,
   // this.taxModel,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_id = json['category_id'];
    name = json['name'];

    variantInfo = (json.containsKey('variant_info') &&
            json['variant_info'] != null)
        ? json['variant_info'].runtimeType.toString() == '_Map<String, dynamic>'
            ? VariantInfo.fromJson(json['variant_info'])
            : null
        : null;
    photo = json['photo'];
    price = json['price'];
    discountPrice = json['discountPrice'];
    quantity = json['quantity'];
    hsn_code = json['hsn_code'];
    description = json['description'];
    discount = json['discount'];
    unit = json['unit'];
  //  taxModel = (json.containsKey('tax') && json['tax'] != null) ? TaxModel.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = category_id;
    data['name'] = name;
    data['photo'] = photo;
    data['price'] = price;
    data['discountPrice'] = discountPrice;
    data['quantity'] = quantity;
    if (variantInfo != null) {
      data['variant_info'] = variantInfo!.toJson();
    }
    data['hsn_code'] = hsn_code;
    data['description'] = description;
    data['discount'] = discount;
    data['unit'] = unit;
    // if (taxModel != null) {
    //   data['tax'] = taxModel!.toJson();
    // }
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
