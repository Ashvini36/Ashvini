import 'package:ebasket_customer/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/notification_payload_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<NotificationPayload> notificationList = <NotificationPayload>[].obs;
  RxList<NotificationPayload> allnotificationList = <NotificationPayload>[].obs;
  Rx<TextEditingController> searchTextFiledController =
      TextEditingController().obs;

  @override
  void onInit() {
    getNotificationData();
    super.onInit();
  }

  getNotificationData() async {
    if(Constant.currentUser.id != null) {
      await FireStoreUtils.getNotification(FireStoreUtils.getCurrentUid())
          .then((value) {
        if (value != null) {
          notificationList.value = value;
          allnotificationList.value = value;
        }
        update();
      });
    }
    isLoading.value = false;
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      notificationList.value = allnotificationList
          .where((e) =>
              e.title!.toLowerCase().contains(value.toLowerCase().toString()) ||
              e.title!.startsWith(value.toString()))
          .toList();
    } else {
      notificationList.value = allnotificationList;
    }
    update();
  }
}
