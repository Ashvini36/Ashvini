import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/constant/send_notification.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/page/pos_screen/navigate_pos_screen.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';

class SuccessController extends GetxController {
  late Timer timer;

  RxInt start = 10.obs;
  RxString status = ''.obs;

  void startTimer(bool isSuccess) {
    placeOrder();
    if (isSuccess) {
      const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (start.value == 0) {
            timer.cancel();
            moveToPosScreen(isSuccess);
          } else {
            start.value--;
          }
        },
      );
    }
  }

  moveToPosScreen(bool isSuccess) async {
    Constant.paymentStatus = null;
    await Preferences.clearKeyData(Preferences.orderData);
    Get.offAll(const NavigatePosScreen());
  }

  placeOrder() async {
    final String order = Preferences.getString(Preferences.orderData);
    OrderModel orderModel = OrderModel.fromJson(jsonDecode(order));
    orderModel.paymentStatus = true;
    orderModel.status = Constant.statusDelivered;
    orderModel.createdAt = Timestamp.now();
    orderModel.updatedAt = Timestamp.now();
    await FireStoreUtils.orderPlace(orderModel).then((value) async {
      await FireStoreUtils.getAllUserByBranch(Constant.branchId).then((value) async {
        if (value != null) {
          for (var element in value) {
            if (element.fcmToken != null) {
              if (element.notificationReceive == true || element.fcmToken!.isNotEmpty) {
                Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": orderModel.id};
                await SendNotification.sendOneNotification(
                  token: element.fcmToken.toString(),
                  title: "New Order",
                  body: "New Table Order Placed",
                  payload: playLoad,
                );
              }
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
