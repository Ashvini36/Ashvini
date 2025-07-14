import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/page/success_page.dart';

class PayStackPage extends StatefulWidget {
  final String publicKey;
  final String secretKey;
  final String amount;

  const PayStackPage({super.key, required this.publicKey, required this.secretKey, required this.amount});

  @override
  State<PayStackPage> createState() => _PayStackPageState();
}

class _PayStackPageState extends State<PayStackPage> {
  String successURL = '';

  @override
  void initState() {
    if (kIsWeb) {
      if (kDebugMode) {
        successURL = 'http://localhost:58041/?payment_status=success';
      } else {
        successURL = "${Constant.customerWebSite}?payment_status=success";
      }
    } else {
      successURL = "${Constant.customerWebSite}?payment_status=success";
    }

    callPayment();
    super.initState();
  }

  String generateRef() {
    final randomCode = Random().nextInt(3234234);
    return 'ref-$randomCode';
  }

  callPayment() async {
    final ref = generateRef();
    try {
      await FlutterPaystackPlus.openPaystackPopup(
        publicKey: widget.publicKey,
        context: context,
        secretKey: widget.secretKey,
        currency: 'NGN',
        customerEmail: 'test1@gmail.com',
        amount: (double.parse(widget.amount) * 100).toString(),
        reference: ref,
        plan: '',
        callBackUrl: successURL,
        onClosed: () {
          Get.offAll(const SuccessPage(isSuccess: true));
          return null;
        },
        onSuccess: () {
          Get.offAll(const SuccessPage(isSuccess: true));
          return null;
        },
      );
    } catch (e) {
      debugPrint("Error :: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Color.fromARGB(255, 238, 237, 237), body: Center(child: SizedBox()));
  }
}
