// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkMe/constant/collection_name.dart';
import 'package:parkMe/constant/constant.dart';
import 'package:parkMe/constant/show_toast_dialog.dart';
import 'package:parkMe/model/order_model.dart';
import 'package:parkMe/themes/common_ui.dart';
import 'package:parkMe/ui/after_scanned/after_scanned_screen.dart';
import 'package:parkMe/ui/after_scanned/early_arrive_screen.dart';
import 'package:parkMe/utils/dark_theme_provider.dart';
import 'package:parkMe/utils/fire_store_utils.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QrCodeScanScreen extends StatelessWidget {
  final String? orderId;

  const QrCodeScanScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: UiInterface().customAppBar(
        context,
        themeChange,
        'Scan QR code'.tr,
      ),
      body: QRCodeDartScanView(
        scanInvertedQRCode: true, // enable scan invert qr code ( default = false)

        typeScan: TypeScan.live, // if TypeScan.takePicture will try decode when click to take a picture(default TypeScan.live)
        onCapture: (Result result) async {

          Get.back();

          if (orderId == null) {
            ShowToastDialog.showLoader("Please wait".tr);
            await FireStoreUtils.fireStore.collection(CollectionName.bookedParkingOrder).doc(result.text).get().then((value) async {
              OrderModel orderModel = OrderModel.fromJson(value.data()!);
              ShowToastDialog.closeLoader();
              if (orderModel.parkingDetails!.userId != FireStoreUtils.getCurrentUid()) {
                ShowToastDialog.showToast("Invalid QR code".tr);
              } else if (orderModel.status == Constant.completed) {
                ShowToastDialog.showToast("This booking already completed".tr);
              } else if (orderModel.status == Constant.onGoing) {
                ShowToastDialog.showToast("This Order already scanned".tr);
              } else if (DateTime.now().isBefore(orderModel.bookingStartTime!.toDate())) {
                Get.to(() => const EarlyArriveScreen(), arguments: {"orderModel": orderModel});
              } else {
                Get.to(() => const AfterScannedScreen(), arguments: {"orderModel": orderModel});
              }
            });
            debugPrint('Barcode found! ${result.text}'.tr);
          } else {
            if (orderId == result.text) {
              await FireStoreUtils.fireStore.collection(CollectionName.bookedParkingOrder).doc(result.text).get().then((value) async {
                OrderModel orderModel = OrderModel.fromJson(value.data()!);
                ShowToastDialog.closeLoader();
                if (orderModel.parkingDetails!.userId != FireStoreUtils.getCurrentUid()) {
                  ShowToastDialog.showToast("Invalid QR code".tr);
                } else if (orderModel.status == Constant.completed) {
                  ShowToastDialog.showToast("This booking already completed".tr);
                } else if (orderModel.status == Constant.onGoing) {
                  ShowToastDialog.showToast("This Order already scanned".tr);
                } else if (DateTime.now().isBefore(orderModel.bookingStartTime!.toDate())) {
                  Get.to(() => const EarlyArriveScreen(), arguments: {"orderModel": orderModel});
                } else {
                  Get.to(() => const AfterScannedScreen(), arguments: {"orderModel": orderModel});
                }
              });
            } else {
              ShowToastDialog.showToast("Invalid QR code".tr);
            }
          }
        },
      ),
    );
  }
}
