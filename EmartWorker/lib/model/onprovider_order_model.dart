import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_worker/model/address_model.dart';
import 'package:emart_worker/model/provider_service_model.dart';
import 'package:emart_worker/model/tax_model.dart';
import 'package:emart_worker/model/user.dart';


class OnProviderOrderModel {
  String authorID, payment_method;
  User author;
  Timestamp createdAt;
  String? sectionId;
  ProviderServiceModel provider;
  String status;
  AddressModel? address;
  String id;
  List<TaxModel>? taxModel;
  Timestamp? scheduleDateTime;
  Timestamp? newScheduleDateTime;
  Timestamp? startTime;
  Timestamp? endTime;
  String? notes;
  String? discount;
  String? discountType;
  String? discountLabel;
  String? couponCode;
  double quantity;
  String? reason;
  String? otp;
  String? adminCommission;
  String? adminCommissionType;
  String? extraCharges;
  String? extraChargesDescription;
  bool? paymentStatus;
  bool? extraPaymentStatus;
  String? workerId;


  OnProviderOrderModel({
    this.sectionId = '',
    this.authorID = '',
    this.payment_method = '',
    author,
    createdAt,
    provider,
    this.status = '',
    this.address,
    this.id = '',
    this.taxModel,
    scheduleDateTime,
    this.newScheduleDateTime,
    this.startTime,
    this.endTime,
    this.notes = '',
    this.discount ,
    this.discountType ,
    this.discountLabel ,
    this.couponCode,
    this.quantity = 0,
    this.reason,
    this.otp,
    this.adminCommission,
    this.adminCommissionType,
    this.extraCharges = '',
    this.extraChargesDescription = '',
    this.paymentStatus,
    this.extraPaymentStatus,
    this.workerId,
  })  : author = author ?? User(),
        createdAt = createdAt ?? Timestamp.now(),
        provider = provider ?? ProviderServiceModel(),
        scheduleDateTime = scheduleDateTime ?? Timestamp.now();

  factory OnProviderOrderModel.fromJson(Map<String, dynamic> parsedJson) {
    List<TaxModel>? taxList;
    if (parsedJson['taxSetting'] != null) {
      taxList = <TaxModel>[];
      parsedJson['taxSetting'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    return OnProviderOrderModel(
      author: parsedJson.containsKey('author') ? User.fromJson(parsedJson['author']) : User(),
      authorID: parsedJson['authorID'] ?? '',
      address: parsedJson.containsKey('address') ? AddressModel.fromJson(parsedJson['address']) : AddressModel(),
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
      id: parsedJson['id'] ?? '',
      payment_method: parsedJson['payment_method'] ?? '',
      taxModel: taxList,
      sectionId: parsedJson['sectionId'] ?? '',
      status: parsedJson['status'] ?? '',
      provider: parsedJson.containsKey('provider') ? ProviderServiceModel.fromJson(parsedJson['provider']) : ProviderServiceModel(),
      notes: parsedJson['notes'] ?? "",
      scheduleDateTime: parsedJson['scheduleDateTime'] ?? Timestamp.now(),
      newScheduleDateTime: parsedJson['newScheduleDateTime'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      discount: parsedJson['discount'] ?? "0.0",
      discountLabel: parsedJson['discountLabel'] ?? "0.0",
      discountType: parsedJson['discountType'] ?? "",
      couponCode: parsedJson['couponCode'] ?? "",
      quantity: double.parse(parsedJson['quantity'].toString()) ?? 0.0,
      reason: parsedJson['reason'] ?? '',
      otp: parsedJson['otp'] ?? '',
      adminCommission: parsedJson['adminCommission'] ?? "",
      adminCommissionType: parsedJson['adminCommissionType'] ?? "",
      extraCharges: parsedJson["extraCharges"] ?? "0.0",
      extraChargesDescription: parsedJson["extraChargesDescription"] ?? "",
      paymentStatus: parsedJson['paymentStatus'],
      extraPaymentStatus: parsedJson['extraPaymentStatus'],
      workerId: parsedJson['workerId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address?.toJson(),
      'author': author.toJson(),
      'authorID': authorID,
      'payment_method': payment_method,
      'createdAt': createdAt,
      'id': id,
      'status': status,
      'provider': provider.toJson(),
      'sectionId': sectionId,
      "taxSetting": taxModel?.map((v) => v.toJson()).toList(),
      "scheduleDateTime": scheduleDateTime,
      "newScheduleDateTime": newScheduleDateTime,
      "startTime": startTime,
      "endTime": endTime,
      "notes": notes,
      'discount': discount,
      "discountLabel": discountLabel,
      "discountType": discountType,
      "couponCode": couponCode,
      'quantity': quantity,
      'reason': reason,
      'otp': otp,
      "adminCommission": adminCommission,
      "adminCommissionType": adminCommissionType,
      'extraCharges': extraCharges,
      'extraChargesDescription': extraChargesDescription,
      'paymentStatus': paymentStatus,
      'extraPaymentStatus': extraPaymentStatus,
      'workerId': workerId,
    };
  }
}
