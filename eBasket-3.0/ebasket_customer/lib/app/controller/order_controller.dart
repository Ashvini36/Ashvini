import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  RxList<OrderModel> orderDataList = <OrderModel>[].obs;
  RxList<OrderModel> allOrderDataList = <OrderModel>[].obs;
  RxString selectOrderStatusRadioListTile = 'All'.obs;

  Rx<OrderModel> orderModel = OrderModel().obs;
  RxList saveAsList = ['All', 'InProcess', 'InTransit', 'Delivered'].obs;

  getFilterData(String value) async {
    if (value.toString().isNotEmpty && value.toString() != 'All') {
      orderDataList.value = allOrderDataList.where((e) => e.status.contains(value)).toList();
    } else {
      orderDataList.value = allOrderDataList;
    }
    update();
  }
}
