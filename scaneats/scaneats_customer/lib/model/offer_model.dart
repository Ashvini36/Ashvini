import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  String? id;
  String? name;
  bool? isFix;
  String? rate;
  String? image;
  String? code;
  Timestamp? startDate;
  Timestamp? endDate;
  bool? isActive;

  OfferModel({this.id, this.name, this.isFix, this.rate, this.image, this.startDate, this.endDate, this.isActive, this.code});

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isFix = json['isFix'];
    rate = json['rate'];
    image = json['image'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isFix'] = isFix;
    data['rate'] = rate;
    data['image'] = image;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['isActive'] = isActive;
    data['code'] = code;
    return data;
  }
}
