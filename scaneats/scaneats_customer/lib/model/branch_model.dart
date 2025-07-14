import 'package:scaneats_customer/model/lat_lng_model.dart';

class BranchModel {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? city;
  String? state;
  String? zipCode;
  String? address;
  bool? isActive;
  LatLngModel? latLng;

  BranchModel({this.id, this.name, this.email, this.phoneNumber,this.latLng, this.city, this.state, this.zipCode, this.address, this.isActive});

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    address = json['address'];
    isActive = json['isActive'];
    latLng = json['latLng'] != null ? LatLngModel.fromJson(json['latLng']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipCode;
    data['address'] = address;
    data['isActive'] = isActive;
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    return data;
  }
}
