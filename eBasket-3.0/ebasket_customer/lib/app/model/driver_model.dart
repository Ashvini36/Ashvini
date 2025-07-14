import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';

class DriverModel {
  bool? active;
  String? carName;
  String? carNumber;
  String? carPictureURL;
  Timestamp? createdAt;
  String? email;
  String? name;
  String? id;
  LocationLatLng? location;
  String? phoneNumber;
  String? pinCode;
  String? profilePictureURL;
  String? fcmToken;
  String? role;
  String? countryCode;

  DriverModel(
      {this.active,
      this.carName,
      this.carNumber,
      this.carPictureURL,
      this.createdAt,
      this.email,
      this.name,
      this.id,
      this.location,
      this.phoneNumber,
      this.pinCode,
      this.profilePictureURL,
      this.fcmToken,
      this.role,
      this.countryCode});

  DriverModel.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    carName = json['carName'];
    carNumber = json['carNumber'];
    carPictureURL = json['carPictureURL'];
    createdAt = json['createdAt'];
    email = json['email'];
    name = json['name'];
    id = json['id'];
//   location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : LocationLatLng();

    phoneNumber = json['phoneNumber'];
    pinCode = json['pinCode'];
    profilePictureURL = json['profilePictureURL'];
    fcmToken = json['fcmToken'];
    role = json['role'];
    countryCode = json['countryCode'];
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['carName'] = carName;
    data['carNumber'] = carNumber;
    data['carPictureURL'] = carPictureURL;
    data['createdAt'] = createdAt;
    data['email'] = email;
    data['name'] = name;
    data['id'] = id;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['phoneNumber'] = phoneNumber;
    data['pinCode'] = pinCode;
    data['profilePictureURL'] = profilePictureURL;
    data['fcmToken'] = fcmToken;
    data['role'] = role;
    data['countryCode'] = countryCode;
    location = data['location'] != null ? LocationLatLng.fromJson(data['location']) : null;
    return data;
  }
}
