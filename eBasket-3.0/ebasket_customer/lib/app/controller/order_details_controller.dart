import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/cart_model.dart';

class OrderDetailsController extends GetxController {
  Rx<CartModel> productModel = CartModel().obs;
  RxBool isLoading = true.obs;
  RxInt quantity = 0.obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxString orderId = ''.obs;
  RxDouble totalAmount = 0.0.obs;
  Rx<TextEditingController> searchTextFiledController =
      TextEditingController().obs;
  RxList<OrderModel> orderDataList = <OrderModel>[].obs;
  RxList<OrderModel> allOrderDataList = <OrderModel>[].obs;

  @override
  void onInit() {

    getArgument();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;


  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderId.value = argumentData['orderId'];
    }
    update();
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      orderDataList.value = allOrderDataList
          .where((e) =>
              e.status.toLowerCase()
                  .contains(value.toLowerCase().toString()) ||
              e.status.startsWith(value.toString()))
          .toList();
    } else {
      orderDataList.value = allOrderDataList;
    }
    update();
  }
}
