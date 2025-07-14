import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/offer_model.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/app/model/user_model.dart';

class OrderModel {
  String? id;
  UserModel? customer;
  String? tokenNo;
  String? branchId;
  List<ItemModel>? product;
  String? discount;
  String? subtotal;
  String? total;
  double? totalDouble;
  OfferModel? offerModel;
  List<TaxModel>? taxList;
  String? status;
  String? tableId;
  String? type;
  String? paymentMethod;
  bool? paymentStatus;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  OrderModel(
      {this.id,
      this.customer,
      this.tokenNo,
      this.taxList,
      this.offerModel,
      this.product,
      this.subtotal,
      this.branchId,
      this.createdAt,
      this.total,
      this.discount,
      this.status,
      this.tableId,
      this.type,
      this.totalDouble,
      this.paymentMethod,
      this.paymentStatus,
      this.updatedAt});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null ? UserModel.fromJson(json['customer']) : null;
    tokenNo = json['tokenNo'];
    branchId = json['branchId'];
    if (json['product'] != null) {
      product = <ItemModel>[];
      json['product'].forEach((v) {
        product!.add(ItemModel.fromJson(v));
      });
    }
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    offerModel = json['offerModel'] != null ? OfferModel.fromJson(json['offerModel']) : null;
    subtotal = json['subtotal'] ?? "0";
    total = json['total'] ?? "0";
    discount = json['discount'] ?? "0";
    createdAt = json['createdAt'];
    status = json['status'] ?? "";
    tableId = json['tableId'];
    type = json['type'];
    paymentMethod = json['paymentMethod'];
    paymentStatus = json['paymentStatus'] ?? false;
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (offerModel != null) {
      data['offerModel'] = offerModel!.toJson();
    }
    data['tokenNo'] = tokenNo;
    data['branchId'] = branchId;
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = subtotal ?? "0";
    data['total'] = total ?? "0";
    data['discount'] = discount ?? "0";
    data['status'] = status ?? '';
    data['createdAt'] = createdAt;
    data['tableId'] = tableId;
    data['type'] = type;
    data['paymentMethod'] = paymentMethod;
    data['paymentStatus'] = paymentStatus ?? false;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toStringData() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (offerModel != null) {
      data['offerModel'] = offerModel!.toJson();
    }
    data['tokenNo'] = tokenNo;
    data['branchId'] = branchId;
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = subtotal ?? "0";
    data['total'] = total ?? "0";
    data['discount'] = discount ?? "0";
    data['status'] = status ?? '';
    data['tableId'] = tableId;
    data['type'] = type;
    data['paymentMethod'] = paymentMethod;
    data['paymentStatus'] = paymentStatus;
    return data;
  }
}
