import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/payment/paypal/Model/accesstokenmodel.dart';
import 'package:scaneats_customer/payment/paypal/Model/paymentmodel.dart';
import 'package:scaneats_customer/payment/stripe/webviewScreen.dart';
import 'package:universal_html/html.dart' as html;

class FlutterPaypalSDK {
  final String paypalClient;
  final String paypalSecret;
  final String amount;
  final bool isSendBox;

  FlutterPaypalSDK({required this.paypalClient, required this.paypalSecret, required this.isSendBox, required this.amount});

  transaction() {
    String successURL = '';
    String cancelURL = '';
    if (kIsWeb) {
      if (kDebugMode) {
        successURL = 'http://localhost:58041/?payment_status=success';
        cancelURL = 'http://localhost:58041/?payment_status=failed';
      } else {
        successURL = "${Constant.customerWebSite}?payment_status=success";
        cancelURL = "${Constant.customerWebSite}?payment_status=failed";
      }
    } else {
      successURL = "${Constant.customerWebSite}?payment_status=success";
      cancelURL = "${Constant.customerWebSite}?payment_status=failed";
    }

    Map<String, dynamic> transactions = {
      "intent": "sale",
      "payer": {
        "payment_method": "paypal",
      },
      "redirect_urls": {
        "return_url": successURL,
        "cancel_url": cancelURL,
      },
      'transactions': [
        {
          "amount": {
            "currency": "USD",
            "total": amount,
          },
        }
      ],
    };

    return transactions;
  }

  Future<AccessToken> getAccessToken() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$paypalClient:$paypalSecret'))}';

    Dio dio = Dio();

    try {
      String baseUrl = isSendBox == true ? "https://api.sandbox.paypal.com" : 'https://api.paypal.com';
      Response response = await dio.post(
        '$baseUrl/v1/oauth2/token',
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        String accessToken = response.data['access_token'];
        return AccessToken(
          token: accessToken,
          message: 'access granted',
        );
      } else {
        // Handle other status codes if needed
        return AccessToken(token: null, message: 'access denied');
      }
    } catch (e) {
      print('Error obtaining token: $e');
    }
    return AccessToken(token: null, message: 'access denied');
  }

  Future<Payment> createPayment(Map<String, dynamic> transactions, String accessToken) async {
    Dio dio = Dio();
    String baseUrl = isSendBox == true ? "https://api.sandbox.paypal.com" : 'https://api.paypal.com';
    Response response = await dio.post(
      '$baseUrl/v1/payments/payment',
      data: transactions,
      options: Options(headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer $accessToken',
      }),
    );
    print("========>paypal");
    print(response.data);
    if (response.statusCode == 201) {
      final data = response.data;
      if (data["links"] != null && data["links"].length > 0) {
        List links = data["links"];

        String executeUrl = "";
        String approvalUrl = "";
        final item = links.firstWhere(
          (o) => o["rel"] == "approval_url",
          orElse: () => null,
        );
        if (item != null) {
          approvalUrl = item["href"];
        }
        final item1 = links.firstWhere(
          (o) => o["rel"] == "execute",
          orElse: () => null,
        );
        if (item1 != null) {
          executeUrl = item1["href"];
        }
        return Payment(
          paymentId: data["id"],
          status: true,
          executeUrl: executeUrl,
          approvalUrl: approvalUrl,
        );
      }
    }
    return Payment(status: false);
  }

  // Future<Map<String, dynamic>?> executePayment(String executeUrl, String payerId, String accessToken) async {
  //   Dio dio = Dio();
  //   var response = await dio.post(
  //     executeUrl,
  //     data: {"payer_id": payerId},
  //     options: Options(headers: {"content-type": "application/json", 'Authorization': 'Bearer $accessToken'}),
  //   );
  //   if (response.statusCode == 200) {
  //     return response.data;
  //   }
  //   return null;
  // }

  dynamic handlePayPalPayment(BuildContext context, {Payment? payment}) async {
    if (kIsWeb) {
      html.window.open(payment?.approvalUrl ?? '', "_self");
    } else {
      bool isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(initialURl: payment?.approvalUrl ?? '')));
      log("Stripe :: Paypal :: $isSuccess");
      return isSuccess;
    }
  }

  // Future<String> checkPaymentStatus(String paymentId) async {
  //   Dio dio = Dio();
  //   final response = await dio.get('https://api.sandbox.paypal.com/check-payment-status?paymentId=$paymentId');
  //
  //   if (response.statusCode == 200) {
  //     return response.data as String;
  //   } else {
  //     throw Exception('Failed to fetch payment status');
  //   }
  // }
}
