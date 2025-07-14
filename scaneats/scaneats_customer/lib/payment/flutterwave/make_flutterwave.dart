// import 'dart:developer';

// import 'package:flutterwave_web_client/flutterwave_web_client.dart';
// import 'package:get/get.dart';
// import 'package:scaneats_customer/page/success_page.dart';

// void makePayment() async {
//   final customer = FlutterwaveCustomer('lazicah@gmail.com', '08102894804', 'Lazarus');
//   final charge = Charge()
//     ..amount = 100
//     ..reference = 'test'
//     ..currency = 'NGN'
//     ..country = 'NG'
//     ..customer = customer;

//   final response = await FlutterwaveWebClient.checkout(charge: charge);
//   if (response.status) {
//     log('Successful, Transaction ref $response.');
//     Get.back();
//     Get.offAll(const SuccessPage(isSuccess: true));
//   } else {
//     log('Transaction Failed');
//     Get.back();
//     Get.offAll(const SuccessPage(isSuccess: false));
//   }
// }
