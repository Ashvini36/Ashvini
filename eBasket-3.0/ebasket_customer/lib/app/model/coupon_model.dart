import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? code;
  String? description;
  String? discount;
  String? discountType;
  Timestamp? expiresAt;
  bool? isEnabled;
  String? id;


  CouponModel({this.code, this.description, this.discount,this.discountType,this.expiresAt, this.isEnabled, this.id,});

  CouponModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    discount = json['discount'] ?? '';
    discountType = json['discountType'] ?? '';
    expiresAt = json['expiresAt'];
    isEnabled = json['isEnabled'];
    id = json['id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['discount'] = discount;
    data['discountType'] = discountType;
    data['isEnabled'] = isEnabled;
    data['id'] = id;
    return data;
  }
}




// class CouponModel {
//   List<CouponList>? couponList;
//
//   CouponModel({this.couponList});
//
//   CouponModel.fromJson(Map<String, dynamic> json) {
//     if (json['coupon_list'] != null) {
//       couponList = <CouponList>[];
//       json['coupon_list'].forEach((v) {
//         couponList!.add(CouponList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (couponList != null) {
//       data['coupon_list'] = couponList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class CouponList {
//   String? id;
//   String? title;
//   String? code;
//   String? description;
//
//
//   CouponList({this.id, this.title, this.code, this.description});
//
//   CouponList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     code = json['code'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['code'] = code;
//     data['description'] = description;
//     return data;
//   }
// }
