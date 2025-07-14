import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String? id;
  String? branchId;
  String? email;
  String? password;
  String? name;
  String? mobileNo;
  String? profileImage;
  bool? isActive;
  String? role;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  AdminModel({this.id, this.branchId, this.email, this.password, this.profileImage, this.name, this.mobileNo, this.role, this.isActive, this.createdAt, this.updatedAt});

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branchId'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    profileImage = json['profileImage'];
    isActive = json['isActive'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['branchId'] = branchId;
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['profileImage'] = profileImage;
    data['isActive'] = isActive;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
