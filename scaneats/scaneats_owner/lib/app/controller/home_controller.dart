import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/subscription_transaction.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class HomeController extends GetxController {
  RxString title = "Home".obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getRecentTransactionData();
    super.onInit();
  }


  RxBool isOrderLoading = false.obs;
  RxList<SubscriptionTransaction> orderDataList = <SubscriptionTransaction>[].obs;

  Future<void> getRecentTransactionData() async {
    isOrderLoading.value = true;
    orderDataList.clear();
    await FireStoreUtils.getAllSubscriptionTransaction().then((value) {
      if (value != null) {
        if (value.length >= 5) {
          orderDataList.value = value.sublist(0, 5);
        }else{
          orderDataList.value = value;
        }
      }
      isOrderLoading.value = false;
      update();
    });
  }

  Color selectColorByOrderType({required String order}) {
    if (order == Constant.orderTypePos) {
      return const Color(0XFFF0A42F);
    } else {
      return const Color(0XFF888AF1);
    }
  }

  Color selectColorByOrderStatus({required String order}) {
    if (order == Constant.statusOrderPlaced) {
      return const Color(0XFF888AF1);
    } else if (order == Constant.statusDelivered) {
      return AppThemeData.forestGreen600;
    } else if (order == Constant.statusAccept) {
      return const Color(0xff008000);
    } else if (order == Constant.statusPending) {
      return const Color(0XFF888AF1);
    } else if (order == Constant.statusRejected) {
      return Colors.red;
    } else {
      return const Color(0XFFF0A42F);
    }
  }
}
