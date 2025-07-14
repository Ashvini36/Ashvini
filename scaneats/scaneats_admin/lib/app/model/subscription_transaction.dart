import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scaneats/app/model/day_model.dart';
import 'package:scaneats/app/model/subscription_model.dart';

class SubscriptionTransaction {
  String? id;
  String? restaurantId;
  SubscriptionModel? subscription;
  String? paymentType;
  Timestamp? startDate;
  Timestamp? endDate;
  DayModel? durations;
  String? subscriptionId;

  SubscriptionTransaction({this.id, this.restaurantId, this.subscription, this.paymentType, this.durations, this.startDate, this.endDate, this.subscriptionId});

  SubscriptionTransaction.fromJson(Map<String, dynamic> json) {
    subscription = json['subscription'] != null ? SubscriptionModel.fromJson(json['subscription']) : null;
    durations = json['durations'] != null ? DayModel.fromJson(json['durations']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    subscriptionId = json['subscriptionId'];
    restaurantId = json['restaurantId'];
    paymentType = json['paymentType'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (durations != null) {
      data['durations'] = durations!.toJson();
    }

    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['subscriptionId'] = subscriptionId;
    data['restaurantId'] = restaurantId;
    data['paymentType'] = paymentType;
    data['id'] = id;
    return data;
  }
}
