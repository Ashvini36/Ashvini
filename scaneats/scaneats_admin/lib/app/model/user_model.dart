import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? restaurantId;
  String? branchId;
  String? email;
  String? password;
  String? name;
  String? mobileNo;
  String? walletAmount;
  String? profileImage;
  bool? isActive;
  String? role;
  String? roleId;
  String? fcmToken;
  bool? notificationReceive;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserModel(
      {this.id,
        this.restaurantId,
        this.branchId,
        this.email,
        this.password,
        this.profileImage,
        this.name,
        this.mobileNo,
        this.walletAmount,
        this.role,
        this.roleId,
        this.fcmToken,
        this.notificationReceive,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurantId'];
    branchId = json['branchId'];
    email = json['email'];
    name = json['name'];
    roleId = json['roleId'];
    mobileNo = json['mobileNo'];
    profileImage = json['profileImage'];
    walletAmount = json['walletAmount'] ?? "0";
    isActive = json['isActive'];
    role = json['role'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notificationReceive = json['notificationReceive']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurantId'] = restaurantId;
    data['branchId'] = branchId;
    data['email'] = email;
    data['roleId'] = roleId;
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['profileImage'] = profileImage;
    data['walletAmount'] = walletAmount ?? "0";
    data['isActive'] = isActive;
    data['role'] = role;
    data['fcmToken'] = fcmToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['notificationReceive'] = notificationReceive;
    return data;
  }
}
