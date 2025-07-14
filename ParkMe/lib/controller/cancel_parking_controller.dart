// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:parkMe/constant/show_toast_dialog.dart';
import 'package:parkMe/model/payment/razorpay_failed_model.dart';
import 'package:parkMe/model/payment_method_model.dart';
import 'package:parkMe/utils/fire_store_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CancelParkingController extends GetxController {
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  RxBool isLoading = false.obs;

  ///RazorPay payment function
  final Razorpay razorPay = Razorpay();

  @override
  void onInit() {
    getPaymentData();

    super.onInit();
  }

  getPaymentData() async {
    isLoading.value = true;
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;

        Stripe.publishableKey = paymentModel.value.strip!.clientpublishableKey.toString();
        Stripe.merchantIdentifier = 'Parkme';
        Stripe.instance.applySettings();

        razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
        razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
        razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      }
    });

    isLoading.value = false;
    update();
  }

  // String? _ref;

  // setRef() {
  //   maths.Random numRef = maths.Random();
  //   int year = DateTime.now().year;
  //   int refNumber = numRef.nextInt(20000);
  //   if (Platform.isAndroid) {
  //     _ref = "AndroidRef$year$refNumber";
  //   } else if (Platform.isIOS) {
  //     _ref = "IOSRef$year$refNumber";
  //   }
  // }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Successful!!");
  }

  void handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Processing!! via");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    RazorPayFailedModel lom = RazorPayFailedModel.fromJson(jsonDecode(response.message!.toString()));
    ShowToastDialog.showToast("Payment Failed!!");
  }
}
