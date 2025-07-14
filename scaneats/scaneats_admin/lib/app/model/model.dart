import 'package:flutter/material.dart';

class DrawerItem {
  String? title;
  String? icon;
  bool? isVisible = false;
  Widget? widget;

  DrawerItem({this.title, this.icon, this.widget, this.isVisible});
}

class SelectModel {
  String? title;
  String? icon;
  SelectModel({this.title, this.icon});
}

class SettingsItem {
  List<String>? title;
  String? icon;
  List<Widget>? widget;
  int? selectIndex;

  SettingsItem({this.title, this.icon, this.widget, this.selectIndex});
}

class ChartData {
  int? x;
  double? y;
  ChartData(this.x, this.y);

  ChartData.fromJson(Map<String, dynamic> json) {
    x = int.parse(json['x'].toString());
    y = double.parse(json['y'].toString());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;

    return data;
  }
}

class ChartMonthData {
  String? x;
  double? y;
  ChartMonthData(this.x, this.y);
}

class ChartdoubleData {
  double? x;
  double? y;
  ChartdoubleData(this.x, this.y);
}

class ChartMultiData {
  String? x;
  double? y;
  double? z;
  ChartMultiData(this.x, this.y, this.z);
}

class OrderData {
  final DateTime date;
  double amount;

  OrderData({required this.date, required this.amount});
}

class CustomerData {
  final DateTime date;
  int customer;

  CustomerData({required this.date, required this.customer});
}
