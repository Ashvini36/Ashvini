import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_driver/app/model/address_model.dart';
import 'package:ebasket_driver/app/model/coupon_model.dart';
import 'package:ebasket_driver/app/model/product_model.dart';
import 'package:ebasket_driver/app/model/tax_model.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/app/model/user_model.dart';
import 'package:ebasket_driver/app/model/vendor_model.dart';

class OrderModel {
  String userID;
  String driverID;
  UserModel? user;
  DriverModel? driver;
  VendorModel? vendor;
  String paymentMethod;
  List<ProductModel> products;
  String status;
  String id;

  //String? discount;
  CouponModel? coupon;
  List<TaxModel>? taxModel;
  String? deliveryCharge;
  String? estimatedTimeToPrepare;
  Timestamp createdAt;
  String? otp;
  AddressModel? address;

  OrderModel(
      {this.paymentMethod = '',
      createdAt,
      this.id = '',
      this.otp = "",
      this.products = const [],
      this.status = '',
      // this.discount = '',
      vendor,
      user,
      this.coupon,
      this.userID = '',
      this.driverID = '',
      this.driver,
      this.deliveryCharge,
      this.estimatedTimeToPrepare,
      this.taxModel,
      this.address})
      : createdAt = createdAt ?? Timestamp.now(),
        user = user ?? UserModel(),
        vendor = vendor ?? VendorModel();

  factory OrderModel.fromJson(Map<String, dynamic> parsedJson) {
    List<ProductModel> products = parsedJson.containsKey('products')
        ? List<ProductModel>.from((parsedJson['products'] as List<dynamic>).map((e) => ProductModel.fromJson(e))).toList()
        : [].cast<ProductModel>();

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
      //  discount: parsedJson['discount'].toString(),
      coupon: parsedJson.containsKey('coupon') ? CouponModel.fromJson(parsedJson['coupon']) : CouponModel(),
      vendor: parsedJson.containsKey('vendor') ? VendorModel.fromJson(parsedJson['vendor']) : VendorModel(),
      deliveryCharge: parsedJson["deliveryCharge"] ?? "0.0",
      paymentMethod: parsedJson["paymentMethod"] ?? '',
      estimatedTimeToPrepare: parsedJson["estimatedTimeToPrepare"] ?? '',
      taxModel: taxList,
      user: parsedJson.containsKey('user') ? UserModel.fromJson(parsedJson['user']) : UserModel(),
      userID: parsedJson['userID'] ?? '',
      //  driver: parsedJson.containsKey('driver') ? DriverModel.fromJson(parsedJson['driver']) : DriverModel(),
      driver: parsedJson['driver'] != null ? DriverModel.fromJson(parsedJson['driver']) : null,
      driverID: parsedJson['driverID'] ?? '',
      otp: parsedJson['otp'] ?? '',
      address: parsedJson.containsKey('address') ? AddressModel.fromJson(parsedJson['address']) : AddressModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'id': id,
      'products': products.map((e) => e.toJson()).toList(),
      'status': status,
      //'discount': discount,
      'coupon': coupon != null ? coupon!.toJson() : null,
      'vendor': vendor!.toJson(),
      "deliveryCharge": deliveryCharge,
      'paymentMethod': paymentMethod,
      "estimatedTimeToPrepare": estimatedTimeToPrepare,
      "tax": taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null,
      'user': user!.toJson(),
      "userID": userID,
      'driver': driver != null ? driver!.toJson() : null,
      "driverID": driverID,
      "otp": otp,
      'address': address?.toJson(),
    };
  }
}
