import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_driver/app/controller/order_details_controller.dart';
import 'package:ebasket_driver/app/ui/order_screen/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_driver/app/controller/notification_controller.dart';
import 'package:ebasket_driver/app/model/notification_payload_model.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/theme/responsive.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: NotificationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title: Text("Notification".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.notificationList.isEmpty
                    ? const Center(child: Text("You don't have any notifications.", style: TextStyle(fontFamily: AppThemeData.medium)))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: controller.notificationList.length,
                                itemBuilder: (context, index) {
                                  NotificationPayload notification = controller.notificationList[index];

                                  bool isSameDate = true;
                                  final Timestamp dateString = notification.createdAt!;
                                  final DateTime date = dateString.toDate();
                                  if (index == 0) {
                                    isSameDate = false;
                                  } else {
                                    final Timestamp prevDateString = controller.notificationList[index - 1].createdAt!;
                                    final DateTime prevDate = prevDateString.toDate();
                                    isSameDate = date.isSameDate(prevDate);
                                  }
                                  return InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (index == 0 || !(isSameDate))
                                              ? Padding(
                                                  padding: const EdgeInsets.only(bottom: 15.0),
                                                  child: Text(
                                                    date.isToday ? "Today".tr : date.formatDate(),
                                                    style: const TextStyle(color: AppThemeData.black, fontSize: 16, fontWeight: FontWeight.w700),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          InkWell(
                                            onTap: () {
                                              if (notification.notificationType == "order" ) {
                                                Get.to(const OrderDetailsScreen(), arguments: {"orderId": notification.orderId})!.then((value) {
                                                  Get.delete<OrderDetailsController>();
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: AppThemeData.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0x3F000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    notification.notificationType == "order" || notification.notificationType == "orderDelivered"
                                                        ? SvgPicture.asset(
                                                            "assets/icons/ic_order.svg",
                                                            width: 50,
                                                            height: 50,
                                                          )
                                                        : notification.notificationType == "password"
                                                            ? SvgPicture.asset(
                                                                "assets/icons/ic_password_update.svg",
                                                                width: 50,
                                                                height: 50,
                                                              )
                                                            : SvgPicture.asset(
                                                                "assets/icons/ic_account.svg",
                                                                width: 50,
                                                                height: 50,
                                                              ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            width: Responsive.width(50, context),
                                                            child: Text(
                                                              notification.title.toString(),
                                                              maxLines: 3,
                                                              style: const TextStyle(
                                                                  color: AppThemeData.black, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Responsive.width(50, context),
                                                            child: Text(
                                                              'Order ID: ${notification.orderId.toString()}',
                                                              style: TextStyle(
                                                                  color: AppThemeData.black.withOpacity(0.50),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: AppThemeData.medium),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                            child: SizedBox(
                                                              width: Responsive.width(50, context),
                                                              child: Text(
                                                                notification.body.toString(),
                                                                maxLines: 3,
                                                                style: TextStyle(
                                                                    color: AppThemeData.black.withOpacity(0.50),
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: AppThemeData.medium),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          //    const SizedBox(height: 12)
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ]),
                      ),
          );
        });
  }
}
