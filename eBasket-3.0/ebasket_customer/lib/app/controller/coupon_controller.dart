import 'package:flutter/material.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/coupon_model.dart';

class CouponController extends GetxController {
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;
  Rx<TextEditingController> couponCodeTextFieldController = TextEditingController().obs;
  RxDouble couponAmount = 0.0.obs;
  RxString subTotal = '0'.obs;
  RxList<CouponModel> couponModel = <CouponModel>[].obs;
  RxList<CouponModel> couponSearchList = <CouponModel>[].obs;

  @override
  void onInit() {
    getArgument();
    getCoupon();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      subTotal.value = argumentData['subTotal'];
    }
    update();
  }

  getCoupon() async {
    await FireStoreUtils.getCoupon().then((value) {
      if (value != null) {
        couponModel.value = value;
        couponSearchList.value = value;
      }
      update();
    });
  }
  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      couponModel.value = couponSearchList.where((e) => e.code!.toLowerCase().contains(value.toLowerCase().toString()) || e.code!.startsWith(value.toString())).toList();
    } else {
      couponModel.value = couponSearchList;
    }
    ShowToastDialog.closeLoader();
    update();
  }
}
