import 'package:scaneats_owner/app/model/day_model.dart';

class SubscriptionModel {
  String? id;
  List<DayModel>? durations;
  String? planName;
  String? noOfItem;
  String? noOfBranch;
  String? noOfEmployee;
  String? noOfOrders;
  String? noOfAdmin;
  String? noOfTablePerBranch;
  bool? isActive;

  SubscriptionModel({this.id, this.durations, this.planName, this.noOfItem, this.noOfBranch, this.noOfEmployee, this.noOfOrders, this.noOfAdmin, this.noOfTablePerBranch,this.isActive});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['durations'] != null) {
      durations = <DayModel>[];
      json['durations'].forEach((v) {
        durations!.add(DayModel.fromJson(v));
      });
    }
    planName = json['planName'];
    noOfItem = json['noOfItem'];
    noOfBranch = json['noOfBranch'];
    noOfEmployee = json['noOfEmployee'];
    noOfOrders = json['noOfOrders'];
    noOfAdmin = json['noOfAdmin'];
    noOfTablePerBranch = json['noOfTablePerBranch'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (durations != null) {
      data['durations'] = durations!.map((v) => v.toJson()).toList();
    }
    data['planName'] = planName;
    data['noOfItem'] = noOfItem;
    data['noOfBranch'] = noOfBranch;
    data['noOfEmployee'] = noOfEmployee;
    data['noOfOrders'] = noOfOrders;
    data['noOfAdmin'] = noOfAdmin;
    data['noOfTablePerBranch'] = noOfTablePerBranch;
    data['isActive'] = isActive;
    return data;
  }
}
