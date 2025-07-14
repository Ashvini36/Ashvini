// ignore_for_file: prefer_null_aware_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/coupon_model.dart';
import 'package:ebasket_customer/app/model/driver_model.dart';
import 'package:ebasket_customer/app/model/tax_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/model/vendor_model.dart';
import 'package:ebasket_customer/services/localDatabase.dart';

class OrderModel {
  String userID;
  UserModel? user;
  VendorModel? vendor;
  String paymentMethod;
  List<CartProduct> products;
  String status;
  String id;
  CouponModel? coupon;
  List<TaxModel>? taxModel;
  String? deliveryCharge;
  String? estimatedTimeToPrepare;
  Timestamp createdAt;
  String? otp;
  DriverModel? driver;
  String? driverID;
  AddressModel? address;

  OrderModel(
      {this.paymentMethod = '',
      createdAt,
      this.id = '',
      this.products = const [],
      this.status = '',
      vendor,
      user,
      this.coupon,
      this.userID = '',
      this.deliveryCharge,
      this.estimatedTimeToPrepare,
      this.taxModel,
      this.otp,
      this.driver,
      this.driverID,
      this.address})
      : createdAt = createdAt ?? Timestamp.now(),
        user = user ?? UserModel(),
        vendor = vendor ?? VendorModel();

  factory OrderModel.fromJson(Map<String, dynamic> parsedJson) {
    List<CartProduct> products = parsedJson.containsKey('products')
        ? List<CartProduct>.from((parsedJson['products'] as List<dynamic>).map((e) => CartProduct.fromJson(e))).toList()
        : [].cast<CartProduct>();

    List<TaxModel>? taxList;
    if (parsedJson['tax'] != null) {
      taxList = <TaxModel>[];
      parsedJson['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    return OrderModel(
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
      id: parsedJson['id'] ?? '',
      products: products,
      status: parsedJson['status'] ?? '',
      coupon: parsedJson['coupon'] != null
          ? parsedJson.containsKey('coupon')
              ? CouponModel.fromJson(parsedJson['coupon'])
              : CouponModel()
          : null,
      vendor: parsedJson.containsKey('vendor') ? VendorModel.fromJson(parsedJson['vendor']) : VendorModel(),
      deliveryCharge: parsedJson["deliveryCharge"] ?? "0.0",
      paymentMethod: parsedJson["paymentMethod"] ?? '',
      estimatedTimeToPrepare: parsedJson["estimatedTimeToPrepare"] ?? '',
      taxModel: taxList,
      user: parsedJson.containsKey('user') ? UserModel.fromJson(parsedJson['user']) : UserModel(),
      userID: parsedJson['userID'] ?? '',
      otp: parsedJson['otp'],
   //   driver: parsedJson.containsKey('driver') ? DriverModel.fromJson(parsedJson['driver']) : DriverModel(),
      driver: parsedJson['driver'] != null ? DriverModel.fromJson(parsedJson['driver']) : null,
      driverID: parsedJson['driverID'] ?? '',
      address: parsedJson.containsKey('address') ? AddressModel.fromJson(parsedJson['address']) : AddressModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'id': id,
      'products': products.map((e) => e.toJson()).toList(),
      'status': status,
      if (coupon != null) 'coupon': coupon != null ? coupon!.toJson() : null,
      'vendor': vendor!.toJson(),
      "deliveryCharge": deliveryCharge,
      'paymentMethod': paymentMethod,
      "estimatedTimeToPrepare": estimatedTimeToPrepare,
      "tax": taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null,
      'user': user!.toJson(),
      "userID": userID,
      'otp': otp,
      'address': address == null ? null : this.address!.toJson(),
      'driver': driver != null ? driver!.toJson() : null,
      "driverID": driverID,
    };
  }
}
