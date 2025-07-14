import 'package:flutter/material.dart';
import 'package:scaneats/app/model/notification_model.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingsNotificationController extends GetxController {
  Rx<TextEditingController> serverKeyController = TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getServerKeyDetails().then((value) {
      if (value != null) {
        serverKeyController.value.text = value.serverKey.toString();
      }
      update();
    });
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addCompanyData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;
    NotificationModel model = NotificationModel(
      serverKey: serverKeyController.value.text.trim(),
    );

    await FireStoreUtils.addUpdateNotification(model).then((value) {
      update();
      isAddItemLoading.value = false;
      ShowToastDialog.showToast("Server Key Update Successfully");
    });
  }
}
