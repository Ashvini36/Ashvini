import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:scaneats/app/ui/success_page.dart';

class RazorPayService {
  static late Razorpay _razorpay;

  init() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void openCheckout({required String key, required String amount}) async {
    var options = {
      'key': key,
      'amount': double.parse(amount) * 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log('Error: e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    log('Success Response: $response');
    Get.offAll(const SuccessPage(isSuccess: true));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    log('Error Response: $response');
    Get.offAll(const SuccessPage(isSuccess: false));
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    log('External SDK Response: $response');
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}", toastLength: Toast.LENGTH_SHORT);
  }
}
