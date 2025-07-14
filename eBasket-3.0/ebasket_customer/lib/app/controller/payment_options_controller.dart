import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/xenditModel.dart';
import 'package:ebasket_customer/payment/RazorPayFailedModel.dart';
import 'package:ebasket_customer/payment/createRazorPayOrderModel.dart';
import 'package:ebasket_customer/payment/midtrans_screen.dart';
import 'package:ebasket_customer/payment/orangePayScreen.dart';
import 'package:ebasket_customer/payment/xenditScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/payment_method_model.dart';
import 'package:ebasket_customer/payment/MercadoPagoScreen.dart';
import 'package:ebasket_customer/payment/PayFastScreen.dart';
import 'package:ebasket_customer/payment/paystack/pay_stack_screen.dart';
import 'package:ebasket_customer/payment/paystack/pay_stack_url_model.dart';
import 'package:ebasket_customer/payment/paystack/paystack_url_genrater.dart';
import 'package:ebasket_customer/payment/stripe_failed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/controller/razorpay_controller.dart';
import 'package:ebasket_customer/app/model/notification_payload_model.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/app/ui/order_details_screen/order_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/constant/send_notification.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentOptionsController extends GetxController {
  RxString selectedPaymentMethod = "".obs;
  HomeController homeController = Get.find<HomeController>();
  Rx<OrderModel> orderModel = OrderModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString totalAmount = ''.obs;
  RxBool walletBalanceError = false.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    getPaymentData();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;

    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      totalAmount.value = argumentData['totalAmount'];
      walletBalanceError.value = double.parse(orderModel.value.user!.walletAmount.toString()) < double.parse(totalAmount.value.toString()) ? true : false;
    }
    update();
  }

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
        Stripe.publishableKey = paymentModel.value.strip!.clientpublishableKey.toString();
        Stripe.merchantIdentifier = 'GoRide';
        Stripe.instance.applySettings();
        setRef();

        razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
        razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
        razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      }
    });

    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);

    isLoading.value = false;
  }

  String? _ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  razorpayPayment() {
    RazorPayController().createOrderRazorPay(amount: double.parse(totalAmount.value.toString()).floor(), razorpayModel: paymentModel.value.razorpay).then((value) {
      if (value == null) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      } else {
        CreateRazorPayOrderModel result = value;
        openCheckout(amount: totalAmount.value.toString(), orderId: result.id);
      }
    });
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Successful!!");
    orderPlaced();
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

  orderPlaced() async {
    orderModel.value.paymentMethod = selectedPaymentMethod.value.toString();

    //  orderModel.value.id = 'GB${const Uuid().v4().split("-").elementAt(0)}';
    orderModel.value.status = Constant.inProcess;
    await FireStoreUtils.getDriver(orderModel.value.address!.pinCode.toString()).then((value) async {
      if (value != null) {
        orderModel.value.driver = value;

        orderModel.value.driverID = value.id;
        Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": orderModel.value.id};
        if (orderModel.value.driver != null) {
          await SendNotification.sendOneNotification(
              token: orderModel.value.driver!.fcmToken.toString(), title: 'Order Placed', body: '${orderModel.value.user!.fullName.toString()} Booking placed.', payload: playLoad);
          NotificationPayload notificationPayload = NotificationPayload(
              id: Constant.getUuid(),
              userId: orderModel.value.driverID!,
              title: 'Order Placed',
              body: '${orderModel.value.user!.fullName.toString()} Booking placed.',
              createdAt: Timestamp.now(),
              role: Constant.USER_ROLE_DRIVER,
              notificationType: "order",
              orderId: orderModel.value.id);

          await FireStoreUtils.placeOrder(orderModel.value).then((value) async {
            if (value == true) {
              await FireStoreUtils.setNotification(notificationPayload).then((value) {});
              await FireStoreUtils.sendOrderEmail(orderModel: orderModel.value);
              Future.delayed(const Duration(seconds: 2), () async {
                Get.back();
                Get.back();

                showOrderSuccessDialog(
                  orderModel.value.id,
                );
              });
            }
          });
        }
      } else {
        await FireStoreUtils.placeOrder(orderModel.value).then((value) async {
          if (value == true) {
            await FireStoreUtils.sendOrderEmail(orderModel: orderModel.value);
            Future.delayed(const Duration(seconds: 2), () async {
              Get.back();
              Get.back();

              showOrderSuccessDialog(
                orderModel.value.id,
              );
            });
          }
        });
      }
    });

    for (int i = 0; i < orderModel.value.products.length; i++) {
      await FireStoreUtils.getProductByProductId(orderModel.value.products[i].id.split('~').first).then((value) async {
        ProductModel? productModel = value;
        if (orderModel.value.products[i].variant_info != null) {
          for (int j = 0; j < productModel!.itemAttributes!.variants!.length; j++) {
            if (productModel.itemAttributes!.variants![j].variantId == orderModel.value.products[i].id.split('~').last) {
              if (productModel.itemAttributes!.variants![j].variantQuantity != "-1") {
                productModel.itemAttributes!.variants![j].variantQuantity =
                    (int.parse(productModel.itemAttributes!.variants![j].variantQuantity.toString()) - orderModel.value.products[i].quantity).toString();
              }
            }
          }
        } else {
          if (productModel!.quantity != -1) {
            productModel.quantity = productModel.quantity! - orderModel.value.products[i].quantity;
          }
        }

        await FireStoreUtils.updateProduct(productModel).then((value) {
          log("-----------2>${value!.toJson()}");
        });
      });
    }
  }

  showOrderSuccessDialog(String orderId) {
    Get.dialog(Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: AppThemeData.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    homeController.cartDatabase.value.deleteAllProducts();
                  },
                  child: SvgPicture.asset(
                    "assets/icons/ic_cancel.svg",
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              "assets/icons/ic_order_success.svg",
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Order Place Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppThemeData.black, fontSize: 36, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "You have successfully made order",
              style: TextStyle(color: AppThemeData.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: RoundedButtonGradiant(
                title: "View Order Details",
                icon: false,
                onPress: () {
                  Get.back();
                  // Get.back();
                  // Get.back();
                  //  homeController.cartDatabase.value.deleteAllProducts();
                  Get.to(const OrderDetailsScreen(), arguments: {
                    "orderId": orderId,
                  })!
                      .then((value) {
                    homeController.cartDatabase.value.deleteAllProducts();
                  });
                },
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  final Razorpay razorPay = Razorpay();

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': paymentModel.value.razorpay!.razorpayKey,
      'amount': amount * 100,
      'name': 'eBasket Customer',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': orderModel.value.user!.phoneNumber,
        'email': orderModel.value.user!.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Strip
  Future<void> stripeMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                  currencyCode: "USD",
                ),
                style: ThemeMode.system,
                customFlow: true,
                appearance: PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: AppThemeData.groceryAppDarkBlue,
                  ),
                ),
                merchantDisplayName: 'Ebasket'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.showToast("Payment successfully");
        orderPlaced();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": orderModel.value.user!.fullName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(paymentModel.value.strip!.stripeSecret.toString());
      var stripeSecret = paymentModel.value.strip!.stripeSecret;
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body, headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'});

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  //mercadoo
  mercadoPagoMakePayment({required BuildContext context, required String amount}) async {
    final headers = {
      'Authorization': 'Bearer ${paymentModel.value.mercadoPago!.accessToken}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": "Test",
          "description": "Test Payment",
          "quantity": 1,
          "currency_id": "USD", // or your preferred currency
          // 'currency_id': 'ARS',
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": orderModel.value.user!.email},
      "back_urls": {
        "failure": "${Constant.globalUrl}payment/failure",
        "pending": "${Constant.globalUrl}payment/pending",
        "success": "${Constant.globalUrl}payment/success",
      },
      "auto_return": "approved" // Automatically return after payment is approved
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(initialURl: data['init_point']))!.then((value) {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!");
          orderPlaced();
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      print('Error creating preference: ${response.body}');
      return null;
    }
  }

  ///PayStack Payment Method
  payStackPayment(String totalAmount) async {
    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(totalAmount) * 100).toString(), currency: "NGN", secretKey: paymentModel.value.payStack!.secretKey.toString(), userModel: orderModel.value.user!)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.secretKey.toString(),
          callBackUrl: paymentModel.value.payStack!.callbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            orderPlaced();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      }
    });
  }

  //flutter wave Payment Method
  flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${paymentModel.value.flutterWave!.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": _ref,
      "amount": amount,
      "currency": "NGN",
      "redirect_url": "${Constant.globalUrl}payment/success",
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": orderModel.value.user!.email.toString(),
        "phonenumber": orderModel.value.user!.phoneNumber, // Add a real phone number
        "name": orderModel.value.user!.fullName, // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ShowToastDialog.closeLoader();
      Get.to(MercadoPagoScreen(initialURl: data['data']['link']))!.then((value) {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!");
          orderPlaced();
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      print('Payment initialization failed: ${response.body}');
      ShowToastDialog.closeLoader();
      return null;
    }
  }

  // payFast
  payFastPayment({required BuildContext context, required String amount}) {
    PayStackURLGen.getPayHTML(payFastSettingData: paymentModel.value.payfast!, amount: amount.toString(), userModel: orderModel.value.user!).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(htmlData: value!, payFastSettingData: paymentModel.value.payfast!));
      if (isDone) {
        ShowToastDialog.showToast("Payment successfully");
        orderPlaced();
      } else {
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }


  paypalPaymentSheet(String amount,BuildContext context) {
    //add 1 item to cart. Max is 4!
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: paymentModel.value.paypal!.isSandbox == true ? false : true,
            clientId: paymentModel.value.paypal!.paypalClient ?? '',
            secretKey: paymentModel.value.paypal!.paypalSecret ?? '',
            returnURL: "com.parkme://paypalpay",
            cancelURL: "com.parkme://paypalpay",
            transactions: [
              {
                "amount": {
                  "total": amount,
                  "currency": "USD",
                  "details": {"subtotal": amount}
                },
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              orderPlaced();
              ShowToastDialog.showToast("Payment Successful!!");
            },
            onError: (error) {
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!");
            },
            onCancel: (params) {
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!");
            }),
      ),
    );
  }

//XenditPayment
  xenditPayment(context, amount) async {
    await createXenditInvoice(amount: amount).then((model) {
      if (model.id != null) {
        Get.to(() => XenditScreen(
                  initialURl: model.invoiceUrl ?? '',
                  transId: model.id ?? '',
                  apiKey: paymentModel.value.xendit!.apiKey!.toString() ?? "",
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            orderPlaced();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Payment Unsuccessful!! \n"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<XenditModel> createXenditInvoice({required var amount}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(paymentModel.value.xendit!.apiKey!.toString()),
      // 'Cookie': '__cf_bm=yERkrx3xDITyFGiou0bbKY1bi7xEwovHNwxV1vCNbVc-1724155511-1.0.1.1-jekyYQmPCwY6vIJ524K0V6_CEw6O.dAwOmQnHtwmaXO_MfTrdnmZMka0KZvjukQgXu5B.K_6FJm47SGOPeWviQ',
    };

    final body = jsonEncode({
      'external_id': const Uuid().v1(),
      'amount': amount,
      'payer_email': 'customer@domain.com',
      'description': 'Test - VA Successful invoice payment',
      'currency': 'IDR', //IDR, PHP, THB, VND, MYR
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        XenditModel model = XenditModel.fromJson(jsonDecode(response.body));
        ShowToastDialog.closeLoader();
        return model;
      } else {
        ShowToastDialog.closeLoader();
        return XenditModel();
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      return XenditModel();
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

//Orangepay payment
  static String accessToken = '';
  static String payToken = '';
  static String orderId = '';
  static String amount = '';

  orangeMakePayment({required String amount, required BuildContext context}) async {
    reset();
    var id = const Uuid().v4();
    var paymentURL = await fetchToken(context: context, orderId: id, amount: amount, currency: 'USD');

    if (paymentURL.toString() != '') {
      Get.to(() => OrangeMoneyScreen(
                initialURl: paymentURL,
                accessToken: accessToken,
                amount: amount,
                orangePay: paymentModel.value.orangePay!,
                orderId: orderId,
                payToken: payToken,
              ))!
          .then((value) {
        if (value == true) {
          ShowToastDialog.showToast("Payment Successful!!");
          orderPlaced();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Payment Unsuccessful!! \n"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future fetchToken({required String orderId, required String currency, required BuildContext context, required String amount}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': "Basic " + paymentModel.value.orangePay!.auth!.toString(),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody);

    // Handle the response

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      accessToken = responseData['access_token'];
      // ignore: use_build_context_synchronously
      ShowToastDialog.closeLoader();
      return await webpayment(context: context, amountData: amount, currency: currency, orderIdData: orderId);
    } else {
      ShowToastDialog.closeLoader();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.",
            style: TextStyle(fontSize: 17),
          )));

      return '';
    }
  }

  Future webpayment({required String orderIdData, required BuildContext context, required String currency, required String amountData}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl = paymentModel.value.orangePay!.isSandbox! == true
        ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'
        : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key": paymentModel.value.orangePay!.merchantKey ?? '',
      "currency": paymentModel.value.orangePay!.isSandbox == true ? "OUV" : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url": paymentModel.value.orangePay!.returnUrl!.toString(),
      "cancel_url": paymentModel.value.orangePay!.cancelUrl!.toString(),
      "notif_url": paymentModel.value.orangePay!.notifyUrl!.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] == 'OK') {
        payToken = responseData['pay_token'];
        return responseData['payment_url'];
      } else {
        return '';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.",
            style: TextStyle(fontSize: 17),
          )));
      return '';
    }
  }

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

//Midtrans payment
  midtransMakePayment({required String amount, required BuildContext context, required String ordersId}) async {
    await createPaymentLink(amount: amount, ordersId: ordersId).then((url) {
      if (url != '') {
        Get.to(() => MidtransScreen(
                  initialURl: url,
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            orderPlaced();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Payment Unsuccessful!! \n"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<String> createPaymentLink({required var amount, required String ordersId}) async {
    print("==========createPaymentLink=${amount}");
    // var orderId1 = const Uuid().v1();
    final url = Uri.parse(paymentModel.value.midtrans!.isSandbox! ? 'https://api.sandbox.midtrans.com/v1/payment-links' : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': generateBasicAuthHeader(paymentModel.value.midtrans!.serverKey!),
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': ordersId,
          'gross_amount': double.parse(amount.toString()).toInt(),
        },
        'usage_limit': 2,
        "callbacks": {"finish": "https://www.google.com?merchant_order_id=$ordersId"},
      }),
    );

    print("==========response=${response.statusCode}");
    print("==========response=${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Payment link created: ${responseData['payment_url']}');
      ShowToastDialog.closeLoader();
      return responseData['payment_url'];
    } else {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("something went wrong, please contact admin.");
      return '';
    }
  }
}
