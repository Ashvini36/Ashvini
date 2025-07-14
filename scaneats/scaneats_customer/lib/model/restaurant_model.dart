import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scaneats_customer/model/day_model.dart';
import 'package:scaneats_customer/model/subscription_model.dart';

class RestaurantModel {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? slug;
  String? city;
  String? state;
  String? countryCode;
  String? zipCode;
  String? address;
  String? webSiteUrl;
  bool? isActive;
  bool? isTrail;
  SubscriptionModel? subscription;
  SubscribedModel? subscribed;
  Timestamp? createdAt;
  Timestamp? updateAt;

  RestaurantModel(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.slug,
      this.city,
      this.state,
      this.countryCode,
      this.zipCode,
      this.address,
      this.webSiteUrl,
      this.isActive,
      this.isTrail,
      this.createdAt,
      this.updateAt,
      this.subscription,
      this.subscribed});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    slug = json['slug'];
    city = json['city'];
    state = json['state'];
    countryCode = json['countryCode'];
    zipCode = json['zipCode'];
    address = json['address'];
    webSiteUrl = json['webSiteUrl'];
    isActive = json['isActive'];
    isTrail = json['isTrail'];
    createdAt = json['createdAt'];
    updateAt = json['updateAt'];
    subscription = json['subscription'] != null ? SubscriptionModel.fromJson(json['subscription']) : null;
    subscribed = json['subscribed'] != null ? SubscribedModel.fromJson(json['subscribed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['slug'] = slug;
    data['city'] = city;
    data['state'] = state;
    data['countryCode'] = countryCode;
    data['zipCode'] = zipCode;
    data['address'] = address;
    data['webSiteUrl'] = webSiteUrl;
    data['isActive'] = isActive;
    data['isTrail'] = isTrail;
    data['createdAt'] = createdAt;
    data['updateAt'] = updateAt;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    if (subscribed != null) {
      data['subscribed'] = subscribed!.toJson();
    }
    return data;
  }
}

class SubscribedModel {
  String? subscriptionId;
  DayModel? durations;
  Timestamp? startDate;
  Timestamp? endDate;

  SubscribedModel({this.durations, this.startDate, this.endDate,this.subscriptionId});

  SubscribedModel.fromJson(Map<String, dynamic> json) {
    durations = json['durations'] != null ? DayModel.fromJson(json['durations']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    subscriptionId = json['subscriptionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (durations != null) {
      data['durations'] = durations!.toJson();
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['subscriptionId'] = subscriptionId;
    return data;
  }
}
