import 'dart:convert';
import 'dart:developer';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/payment/stripe/webviewScreen.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StripeService {
  static Future<String> createPrice({required String secretKey, required String amount}) async {
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $secretKey';
      dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      Response response = await dio.post(
        'https://api.stripe.com/v1/prices',
        data: {
          'currency': 'usd',
          'product_data[name]': 'product',
          'unit_amount': (double.parse(amount) * 100).round().toString(),
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        log("CreatePrice :: ${jsonEncode(responseData)}");
        return responseData['id'];
      } else {
        return '';
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<String> makeStripeCheckoutCall({required String priceId, required String secretKey}) async {
    Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $secretKey';
    dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    try {
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
      Response response = await dio.post(
        'https://api.stripe.com/v1/checkout/sessions',
        data: {'line_items[0][price]': priceId, 'line_items[0][quantity]': '1', 'mode': 'payment', 'success_url': successURL, 'cancel_url': cancelURL},
      );

      Map<String, dynamic> responseData = response.data;
      log("CreatePrice :: ${jsonEncode(responseData)}");
      return responseData['url'];
    } catch (e) {
      return '';
    }

    // Handle response here
  }

  static dynamic handlePayPalPayment(context, {String? approvalUrl}) async {
    if (kIsWeb) {
      html.window.open(approvalUrl ?? '', "_self");
    } else {
      bool isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(initialURl: approvalUrl ?? '')));
      log("Stripe :: $isSuccess");
      return isSuccess;
    }
  }
}
