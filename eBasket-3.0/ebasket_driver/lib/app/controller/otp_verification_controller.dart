import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_driver/app/model/notification_payload_model.dart';
import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/ui/home_screen/home_screen.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/constant/send_notification.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class OtpVerificationController extends GetxController {
  Rx<TextEditingController> pinController = TextEditingController().obs;
  RxString orderId = ''.obs;
  Rx<OrderModel> orderModel = OrderModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    orderId.value = Get.arguments['orderId'];
    orderModel.value = (await FireStoreUtils.getOrder(orderId.value))!;
  }

  updateOrder() async {
    ShowToastDialog.showLoader("Please wait.");
    if (pinController.value.text.isNotEmpty && pinController.value.text == orderModel.value.otp.toString()) {
      orderModel.value.status = Constant.delivered;
      UserModel? userData = await FireStoreUtils.getUser(orderModel.value.userID);
      NotificationPayload notificationPayload = NotificationPayload(
          id: Constant.getUuid(),
          userId: userData!.id.toString(),
          title: "Order Delivered",
          body: "Order Successfully Delivered.",
          createdAt: Timestamp.now(),
          role: Constant.USER_ROLE_CUSTOMER,
          notificationType: "orderDelivered",
          orderId: orderId.value);

     /* NotificationPayload notificationPayloadDriver = NotificationPayload(
          id: Constant.getUuid(),
          userId: FireStoreUtils.getCurrentUid(),
          title: "Order Delivered",
          body: "Order Successfully Delivered.",
          createdAt: Timestamp.now(),
          role: Constant.USER_ROLE_DRIVER,
          notificationType: "orderDelivered",
          orderId: orderId.value);*/

      Map<String, dynamic> playLoad = <String, dynamic>{
        "type": "orderDelivered",
      };

      await SendNotification.sendOneNotification(token: userData.fcmToken.toString(), title: "Order Delivered", body: "Order Successfully Delivered.", payload: playLoad);

      await FireStoreUtils.updateOrder(orderModel.value).then((value) async {
        showOrderDeliveredDialog();
        pinController.value.text = '';
        await FireStoreUtils.setNotification(notificationPayload).then((value) {});
        // FireStoreUtils.setNotification(notificationPayloadDriver).then((value) {});
        await Future.delayed(const Duration(seconds: 2));
        Get.delete<OtpVerificationController>();
        Get.to(const HomeScreen(), transition: Transition.rightToLeftWithFade);
      });
    }
    else if(pinController.value.text.isNotEmpty && pinController.value.text != orderModel.value.otp.toString()){
      ShowToastDialog.showToast("Invalid OTP.".tr);
    }
    else {
      ShowToastDialog.showToast("Please enter verification code.".tr);
    }
    ShowToastDialog.closeLoader();
  }

  void showOrderDeliveredDialog() {
    Get.dialog(Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: AppThemeData.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: 120,
              height: 120,
              child: SvgPicture.asset(
                "assets/icons/ic_order_delivered.svg",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Order Delivered",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppThemeData.black, fontSize: 34, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Your Order delivered Successfully.",
                style: TextStyle(color: AppThemeData.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
              ),
            ),
          ]),
        ),
      ),
    ));
  }
}
