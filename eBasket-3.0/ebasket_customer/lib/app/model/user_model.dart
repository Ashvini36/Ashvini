import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/address_model.dart';

class UserModel {
  String? id;
  String? fullName;
  String? image;
  String? email;
  String? phoneNumber;

  String? fcmToken;
  String? role;
  Timestamp? createdAt;
  bool? active;
  String? countryCode;
  String? walletAmount;

  List<AddressModel>? shippingAddress = [];

  UserModel({
    this.id,
    this.fullName,
    this.image = '',
    this.email,
    this.phoneNumber,
    this.fcmToken,
    this.role,
    this.createdAt,
    this.active = true,
    this.countryCode,
    this.walletAmount,
    this.shippingAddress,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['name'];
    image = json['image'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    fcmToken = json['fcmToken'];
    role = json['role'];
    createdAt = json['createdAt'];
    active = json['active'] ?? true;
    countryCode = json['countryCode'];
    walletAmount = json['walletAmount'] ?? "0.0";
    if (json['shippingAddress'] != null) {
      shippingAddress = <AddressModel>[];
      json['shippingAddress'].forEach((v) {
        shippingAddress!.add(AddressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = fullName;
    data['image'] = image;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['fcmToken'] = fcmToken;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['active'] = active;
    data['countryCode'] = countryCode;
    data['walletAmount'] = walletAmount;

    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
