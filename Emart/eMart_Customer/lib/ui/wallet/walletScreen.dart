import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/cab_service/cab_order_detail_screen.dart';
import 'package:emartconsumer/model/CabOrderModel.dart';
import 'package:emartconsumer/model/FlutterWaveSettingDataModel.dart';
import 'package:emartconsumer/model/MercadoPagoSettingsModel.dart';
import 'package:emartconsumer/model/PayFastSettingData.dart';
import 'package:emartconsumer/model/PayStackSettingsModel.dart';

import 'package:emartconsumer/model/createRazorPayOrderModel.dart';
import 'package:emartconsumer/model/payStackURLModel.dart';
import 'package:emartconsumer/model/payment_model/mid_trans.dart';
import 'package:emartconsumer/model/payment_model/orange_money.dart';
import 'package:emartconsumer/model/payment_model/xendit.dart';
import 'package:emartconsumer/model/paypalSettingData.dart';
import 'package:emartconsumer/model/paytmSettingData.dart';
import 'package:emartconsumer/model/razorpayKeyModel.dart';
import 'package:emartconsumer/model/stripeSettingData.dart';
import 'package:emartconsumer/model/topupTranHistory.dart';
import 'package:emartconsumer/onDemand_service/onDemand_ui/order_screen/ondemand_order_details_screen.dart';
import 'package:emartconsumer/parcel_delivery/parcel_model/parcel_order_model.dart';
import 'package:emartconsumer/parcel_delivery/parcel_ui/parcel_order_detail_screen.dart';
import 'package:emartconsumer/payment/midtrans_screen.dart';
import 'package:emartconsumer/payment/orangePayScreen.dart';
import 'package:emartconsumer/payment/xenditModel.dart';
import 'package:emartconsumer/payment/xenditScreen.dart';
import 'package:emartconsumer/rental_service/model/rental_order_model.dart';
import 'package:emartconsumer/rental_service/renatal_summary_screen.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:emartconsumer/services/paystack_url_genrater.dart';
import 'package:emartconsumer/services/rozorpayConroller.dart';
import 'package:emartconsumer/services/show_toast_dialog.dart';
import 'package:emartconsumer/theme/app_them_data.dart';
import 'package:emartconsumer/ui/gift_card/gift_card_redeem_screen.dart';
import 'package:emartconsumer/ui/wallet/MercadoPagoScreen.dart';
import 'package:emartconsumer/ui/wallet/PayFastScreen.dart';
import 'package:emartconsumer/ui/wallet/payStackScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe1;

import 'package:http/http.dart' as http;

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../model/OrderModel.dart';
import '../../model/User.dart';
import '../../model/getPaytmTxtToken.dart';
import '../../services/helper.dart';
import '../../userPrefrence.dart';
import '../orderDetailsScreen/OrderDetailsScreen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  WalletScreenState createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {

  Stream<QuerySnapshot>? topupHistoryQuery;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? userQuery;

  String? selectedRadioTile;

  final GlobalKey<FormState> _globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Razorpay _razorPay = Razorpay();
  RazorPayModel? razorPayData;
  StripeSettingData? stripeData;
  PaytmSettingData? paytmSettingData;
  PaypalSettingData? paypalSettingData;
  PayStackSettingData? payStackSettingData;
  FlutterWaveSettingData? flutterWaveSettingData;
  PayFastSettingData? payFastSettingData;
  MercadoPagoSettingData? mercadoPagoSettingData;
  MidTrans? midTransModel;
  OrangeMoney? orangeMoneyModel;
  Xendit? xenditModel;

  final TextEditingController _amountController = TextEditingController(text: 50.toString());

  Map<String, dynamic>? paymentIntentData;

  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  showAlert(context, {required String response, required Color colors}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response),
      backgroundColor: colors,
      duration: const Duration(seconds: 8),
    ));
  }

  final userId = MyAppState.currentUser!.userID;

  getPaymentSettingData() async {
    topupHistoryQuery = FireStoreUtils.firestore.collection(Wallet).where('user_id', isEqualTo: userId).orderBy('date', descending: true).snapshots();
    userQuery = FireStoreUtils.firestore.collection(USERS).doc(MyAppState.currentUser!.userID).snapshots();

    await UserPreference.getStripeData().then((value) async {
      stripeData = value;
      stripe1.Stripe.publishableKey = stripeData!.clientpublishableKey;
      stripe1.Stripe.merchantIdentifier = 'Emart';
      await stripe1.Stripe.instance.applySettings();
    });

    razorPayData = await UserPreference.getRazorPayData();
    paytmSettingData = await UserPreference.getPaytmData();
    paypalSettingData = await UserPreference.getPayPalData();
    payStackSettingData = await UserPreference.getPayStackData();
    flutterWaveSettingData = await UserPreference.getFlutterWaveData();
    payFastSettingData = await UserPreference.getPayFastData();
    mercadoPagoSettingData = await UserPreference.getMercadoPago();
    midTransModel = await UserPreference.getMidTransData();
    orangeMoneyModel = await UserPreference.getOrangeData();
    xenditModel = await UserPreference.getXenditData();

    print("===>");
    print(xenditModel!.toJson());
    initPayPal();
  }

  @override
  void initState() {
    setRef();
    getPaymentSettingData();
    selectedRadioTile = "Stripe";

    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWaller);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    // TODO: implement initState
    super.initState();
  }

  void initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode = paypalSettingData!.isLive == false ? true : false;
    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.emart.customer://paypalpay",
      //client id from developer dashboard
      clientID: paypalSettingData!.paypalClient,
      //sandbox, staging, live etc
      payPalEnvironment: paypalSettingData!.isLive == true ? FPayPalEnvironment.live : FPayPalEnvironment.sandbox,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          Navigator.pop(context);
          ShowToastDialog.showToast("Payment canceled");
        },
        onSuccess: (data) {
          Navigator.pop(context);
          _flutterPaypalNativePlugin.removeAllPurchaseItems();
          String visitor = data.cart?.shippingAddress?.firstName ?? 'Visitor';
          String address = data.cart?.shippingAddress?.line1 ?? 'Unknown Address';
          ShowToastDialog.showToast("Payment Successfully");
          paymentCompleted(paymentMethod: "Paypal");
        },
        onError: (data) {
          Navigator.pop(context);
          ShowToastDialog.showToast("error: ${data.reason}");
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          Navigator.pop(context);
          ShowToastDialog.showToast("shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDarkMode(context) ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/wallet_background@3x.png"))),
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Balance".tr(),
                              style: const TextStyle(color: Colors.white, fontFamily: AppThemeData.medium, fontSize: 18),
                            ),
                            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: userQuery,
                              builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> asyncSnapshot) {
                                if (asyncSnapshot.hasError) {
                                  return Text(
                                    "error".tr(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                  );
                                }
                                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 0.8,
                                            color: Colors.white,
                                            backgroundColor: Colors.transparent,
                                          )));
                                }
                                MyAppState.currentUser = User.fromJson(asyncSnapshot.data!.data()!);
                                User userData = User.fromJson(asyncSnapshot.data!.data()!);
                                return Text(
                                  "${amountShow(amount: userData.wallet_amount.toString())}",
                                  //  "${currencyData!.symbol} ${double.parse(userData.wallet_amount.toString()).toStringAsFixed(decimal)}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    buildTopUpButton(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: showTopupHistory(context)),
        ],
      ),
    );
  }

  Widget buildTopUpButton() {
    return GestureDetector(
      onTap: () {
        topUpBalance();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: Text(
            "TOPUP WALLET".tr(),
            style: TextStyle(color: AppThemeData.primary300, fontFamily: AppThemeData.semiBold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget showTopupHistory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: topupHistoryQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'.tr()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox(height: 35, width: 35, child: CircularProgressIndicator()));
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            "No Transaction History".tr(),
            style: const TextStyle(fontSize: 18),
          ));
        } else {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final topUpData = TopupTranHistoryModel.fromJson(document.data() as Map<String, dynamic>);
              //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return buildTransactionCard(
                topupTranHistory: topUpData,
                date: topUpData.date.toDate(),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget buildTransactionCard({
    required TopupTranHistoryModel topupTranHistory,
    required DateTime date,
  }) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
      child: GestureDetector(
        onTap: () => showTransactionDetails(topupTranHistory: topupTranHistory),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    color: AppThemeData.primary300.withOpacity(0.06),
                    child: Padding(
                      child: Icon(Icons.account_balance_wallet_rounded, size: 28, color: AppThemeData.primary300),
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.78,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topupTranHistory.note.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Opacity(
                              opacity: 0.65,
                              child: Text(
                                DateFormat('KK:mm:ss a, dd MMM yyyy').format(topupTranHistory.date.toDate()).toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0, left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              topupTranHistory.isTopup
                                  ? "${"+"} ${amountShow(amount: topupTranHistory.amount.toString())}"
                                  : "(${"-"} ${amountShow(amount: topupTranHistory.amount.toString())})",
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: topupTranHistory.isTopup ? Colors.green : Colors.red,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )
                          ],
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
    );
  }

  paymentCompleted({required String paymentMethod}) async {
    TopupTranHistoryModel wallet = TopupTranHistoryModel(
        amount: _amountController.text,
        order_id: '',
        serviceType: '',
        id: Uuid().v4(),
        user_id: MyAppState.currentUser!.userID,
        date: Timestamp.now(),
        isTopup: true,
        payment_method: paymentMethod,
        payment_status: "success",
        transactionUser: "customer",
        note: 'Wallet Top-up.');

    await FireStoreUtils.firestore.collection("wallet").doc(wallet.id).set(wallet.toJson()).then((value) async {
      await FireStoreUtils.updateWalletAmount(amount: _amountController.text).then((value) async {
        await FireStoreUtils.sendTopUpMail(paymentMethod: paymentMethod, amount: _amountController.text, tractionId: wallet.id);
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text("Payment Successful!!".tr() + "\n"),
          backgroundColor: Colors.green,
        ));
      }).whenComplete(() {
        showAlert(context, response: "Payment Successful Via".tr() + " " "Wallet".tr(), colors: Colors.green);
      });
    });
  }

  showLoadingAlert() {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CircularProgressIndicator(),
              const Text('Please wait!!').tr(),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Please wait!! while completing Transaction'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showTransactionDetails({required TopupTranHistoryModel topupTranHistory}) {
    final size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        elevation: 5,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: size.height * 0.80,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Text(
                        "Transaction Details".tr(),
                        style: const TextStyle(
                          fontFamily: AppThemeData.medium,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transaction ID".tr(),
                                    style: const TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      topupTranHistory.id,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
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
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
                        child: Card(
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    color: AppThemeData.primary300.withOpacity(0.05),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.account_balance_wallet_rounded, size: 28, color: AppThemeData.primary300),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.48,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('KK:mm:ss a, dd MMM yyyy').format(topupTranHistory.date.toDate()),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          topupTranHistory.note.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      //  "${topupTranHistory.isTopup ? "+" : "-"} ${amountShow(amount: topupTranHistory.amount.toString())}",
                                      topupTranHistory.isTopup
                                          ? "${"+"} ${amountShow(amount: topupTranHistory.amount.toString())}"
                                          : "(${"-"} ${amountShow(amount: topupTranHistory.amount.toString())})",
                                      style: TextStyle(
                                        fontFamily: AppThemeData.medium,
                                        color: topupTranHistory.isTopup ? Colors.green : Colors.red,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Payment Details".tr(),
                                        style: const TextStyle(
                                          fontFamily: AppThemeData.medium,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Opacity(
                                            opacity: 0.7,
                                            child: Text(
                                              "Pay Via".tr(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !topupTranHistory.isTopup,
                                            child: Text(
                                              "  " + topupTranHistory.payment_method.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: AppThemeData.primary300,
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!topupTranHistory.isTopup) {
                                        if (topupTranHistory.serviceType == "cab-service") {
                                          FireStoreUtils.firestore.collection(RIDESORDER).doc(topupTranHistory.order_id).get().then((value) {
                                            CabOrderModel orderModel = CabOrderModel.fromJson(value.data()!);
                                            push(context, CabOrderDetailScreen(orderModel: orderModel));
                                          });
                                        } else if (topupTranHistory.serviceType == "parcel-service") {
                                          FireStoreUtils.firestore.collection(PARCELORDER).doc(topupTranHistory.order_id).get().then((value) {
                                            ParcelOrderModel orderModel = ParcelOrderModel.fromJson(value.data()!);
                                            push(context, ParcelOrderDetailScreen(orderModel: orderModel));
                                          });
                                        } else if (topupTranHistory.serviceType == "rental-service") {
                                          FireStoreUtils.firestore.collection(RENTALORDER).doc(topupTranHistory.order_id).get().then((value) {
                                            RentalOrderModel orderModel = RentalOrderModel.fromJson(value.data()!);
                                            push(context, RenatalSummaryScreen(rentalOrderModel: orderModel));
                                          });
                                        } else if (topupTranHistory.serviceType == "ondemand-service") {
                                          await FireStoreUtils.firestore.collection(PROVIDER_ORDER).doc(topupTranHistory.order_id).get().then((value) {
                                            push(context, OnDemandOrderDetailsScreen(orderId: topupTranHistory.order_id));
                                          });
                                        } else {
                                          FireStoreUtils.firestore.collection(ORDERS).doc(topupTranHistory.order_id).get().then((value) {
                                            OrderModel orderModel = OrderModel.fromJson(value.data()!);
                                            push(context, OrderDetailsScreen(orderModel: orderModel));
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      topupTranHistory.isTopup ? topupTranHistory.payment_method.toUpperCase() : "View Order".tr().toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: AppThemeData.medium,
                                        color: AppThemeData.primary300,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date in UTC Format".tr(),
                                        style: const TextStyle(
                                          fontFamily: AppThemeData.medium,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          DateFormat('KK:mm:ss a, dd MMM yyyy').format(topupTranHistory.date.toDate()).toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  topUpBalance() {
    final size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        elevation: 5,
        enableDrag: true,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.94,
            child: StatefulBuilder(
              builder: (context, setState) => SizedBox(
                width: size.width,
                child: Form(
                  key: _globalKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Topup Wallet".tr(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode(context) ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                              child: RichText(
                                text: TextSpan(
                                  text: "Add Topup Amount".tr(),
                                  style: TextStyle(fontSize: 16, color: isDarkMode(context) ? Colors.white54 : Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                          child: Card(
                            elevation: 2.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
                              child: TextFormField(
                                controller: _amountController,
                                style: TextStyle(color: AppThemeData.primary300, fontSize: 20, fontFamily: AppThemeData.semiBold),
                                //initialValue:"50",
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "*required Field".tr();
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                ],                                decoration: InputDecoration(
                                  prefix: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
                                    child: Text(
                                      currencyData!.symbol.toString(),
                                      style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 20, fontFamily: AppThemeData.semiBold),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                              child: RichText(
                                text: TextSpan(
                                  text: "Select Payment Option".tr(),
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: isDarkMode(context) ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: stripeData!.isEnabled,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: stripe ? 0 : 2,
                              child: RadioListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: stripe ? AppThemeData.primary300 : Colors.transparent)),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "Stripe",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    flutterWave = false;
                                    stripe = true;
                                    mercadoPago = false;
                                    payFast = false;
                                    payStack = false;
                                    razorPay = false;
                                    payTm = false;
                                    paypal = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;

                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: stripe,
                                //selectedRadioTile == "strip" ? true : false,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                          child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                                              child: Image.asset(
                                                "assets/images/stripe.png",
                                              ),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Stripe").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: payStackSettingData!.isEnabled,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: payStack ? 0 : 2,
                              child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), side: BorderSide(color: payStack ? AppThemeData.primary300 : Colors.transparent)),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "PayStack",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    flutterWave = false;
                                    payStack = true;
                                    mercadoPago = false;
                                    stripe = false;
                                    payFast = false;
                                    razorPay = false;
                                    payTm = false;
                                    paypal = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: payStack,
                                //selectedRadioTile == "strip" ? true : false,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                          child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                                              child: Image.asset(
                                                "assets/images/paystack.png",
                                              ),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("PayStack").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: flutterWaveSettingData!.isEnable,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: flutterWave ? 0 : 2,
                              child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), side: BorderSide(color: flutterWave ? AppThemeData.primary300 : Colors.transparent)),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "FlutterWave",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    flutterWave = true;
                                    payStack = false;
                                    mercadoPago = false;
                                    payFast = false;
                                    stripe = false;
                                    razorPay = false;
                                    payTm = false;
                                    paypal = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: flutterWave,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                          child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                                              child: Image.asset(
                                                "assets/images/flutterwave.png",
                                              ),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("FlutterWave").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: razorPayData!.isEnabled,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: razorPay ? 0 : 2,
                              child: RadioListTile(
                                //toggleable: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), side: BorderSide(color: razorPay ? AppThemeData.primary300 : Colors.transparent)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "RazorPay",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    mercadoPago = false;
                                    flutterWave = false;
                                    stripe = false;
                                    razorPay = true;
                                    payTm = false;
                                    payFast = false;
                                    paypal = false;
                                    payStack = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: razorPay,
                                //selectedRadioTile == "strip" ? true : false,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                          child: SizedBox(width: 80, height: 35, child: Image.asset("assets/images/razorpay_@3x.png")),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("RazorPay").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: payFastSettingData!.isEnable,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: payFast ? 0 : 2,
                              child: RadioListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: payFast ? AppThemeData.primary300 : Colors.transparent)),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "payFast",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    payFast = true;
                                    stripe = false;
                                    mercadoPago = false;
                                    razorPay = false;
                                    payStack = false;
                                    flutterWave = false;
                                    payTm = false;
                                    paypal = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: payFast,
                                //selectedRadioTile == "strip" ? true : false,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                          child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                                              child: Image.asset(
                                                "assets/images/payfast.png",
                                              ),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Payfast").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: paytmSettingData!.isEnabled,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: payTm ? 0 : 2,
                              child: RadioListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: payTm ? AppThemeData.primary300 : Colors.transparent)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "PayTm",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    stripe = false;
                                    flutterWave = false;
                                    payTm = true;
                                    mercadoPago = false;
                                    razorPay = false;
                                    paypal = false;
                                    payFast = false;
                                    payStack = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: payTm,
                                //selectedRadioTile == "strip" ? true : false,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                          child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Image.asset(
                                                  "assets/images/paytm_@3x.png",
                                                ),
                                              )),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Paytm").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: mercadoPagoSettingData!.isEnabled,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: mercadoPago ? 0 : 2,
                              child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), side: BorderSide(color: mercadoPago ? AppThemeData.primary300 : Colors.transparent)),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "MercadoPago",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    mercadoPago = true;
                                    payFast = false;
                                    stripe = false;
                                    razorPay = false;
                                    payStack = false;
                                    flutterWave = false;
                                    payTm = false;
                                    paypal = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: mercadoPago,
                                //selectedRadioTile == "strip" ? true : false,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                          child: SizedBox(
                                            width: 80,
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                                              child: Image.asset(
                                                "assets/images/mercadopago.png",
                                              ),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Mercado Pago").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: paypalSettingData!.isEnabled,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: paypal ? 0 : 2,
                              child: RadioListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: paypal ? AppThemeData.primary300 : Colors.transparent)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "PayPal",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    stripe = false;
                                    payTm = false;
                                    mercadoPago = false;
                                    flutterWave = false;
                                    razorPay = false;
                                    paypal = true;
                                    payFast = false;
                                    payStack = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: paypal,
                                //selectedRadioTile == "strip" ? true : false,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                          child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Image.asset("assets/images/paypal_@3x.png"),
                                              )),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("PayPal").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: xenditModel!.enable ?? false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: xendit ? 0 : 2,
                              child: RadioListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: xendit ? AppThemeData.primary300 : Colors.transparent)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "Xendit",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    stripe = false;
                                    payTm = false;
                                    mercadoPago = false;
                                    flutterWave = false;
                                    razorPay = false;
                                    paypal = false;
                                    payFast = false;
                                    payStack = false;
                                    orange = false;
                                    Midtrans = false;
                                    xendit = true;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: xendit,
                                //selectedRadioTile == "strip" ? true : false,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                          child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Image.asset("assets/images/xendit.png"),
                                              )),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Xendit").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: orangeMoneyModel!.enable ?? false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: orange ? 0 : 2,
                              child: RadioListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: orange ? AppThemeData.primary300 : Colors.transparent)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "OrangeMoney",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    stripe = false;
                                    payTm = false;
                                    mercadoPago = false;
                                    flutterWave = false;
                                    razorPay = false;
                                    paypal = false;
                                    payFast = false;
                                    payStack = false;
                                    orange = true;
                                    Midtrans = false;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: orange,
                                //selectedRadioTile == "strip" ? true : false,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                          child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Image.asset("assets/images/orange_money.png"),
                                              )),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("OrangeMoney").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: midTransModel!.enable ?? false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: Midtrans ? 0 : 2,
                              child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), side: BorderSide(color: Midtrans ? AppThemeData.primary300 : Colors.transparent)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,
                                value: "Midtrans",
                                groupValue: selectedRadioTile,
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    stripe = false;
                                    payTm = false;
                                    mercadoPago = false;
                                    flutterWave = false;
                                    razorPay = false;
                                    paypal = false;
                                    payFast = false;
                                    payStack = false;
                                    orange = false;
                                    Midtrans = true;
                                    xendit = false;
                                    selectedRadioTile = value!;
                                  });
                                },
                                selected: Midtrans,
                                //selectedRadioTile == "strip" ? true : false,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                          child: SizedBox(
                                              width: 80,
                                              height: 35,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Image.asset("assets/images/midtrans.png"),
                                              )),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Midtrans").tr(),
                                  ],
                                ),
                                //toggleable: true,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22),
                          child: GestureDetector(
                            onTap: () async {
                              if (selectedRadioTile == "Stripe" && stripeData?.isEnabled == true) {
                                Navigator.pop(context);
                                showLoadingAlert();
                                stripeMakePayment(amount: _amountController.text);
                                //push(context, CardDetailsScreen(paymentMode: selectedRadioTile,),);
                              } else if (selectedRadioTile == "MercadoPago") {
                                Navigator.pop(context);
                                showLoadingAlert();
                                mercadoPagoMakePayment();
                              } else if (selectedRadioTile == "payFast") {
                                showLoadingAlert();
                                PayStackURLGen.getPayHTML(payFastSettingData: payFastSettingData!, amount: _amountController.text).then((value) async {
                                  bool isDone = await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PayFastScreen(
                                            htmlData: value,
                                            payFastSettingData: payFastSettingData!,
                                          )));
                                  print(isDone);
                                  if (isDone) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    await paymentCompleted(paymentMethod: "PayFast");
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Payment Unsuccessful!!".tr() + "\n",
                                      ),
                                      backgroundColor: Colors.red.shade400,
                                      duration: const Duration(seconds: 6),
                                    ));
                                  }
                                });
                              } else if (selectedRadioTile == "RazorPay") {
                                print(_amountController.text);
                                Navigator.pop(context);
                                showLoadingAlert();
                                RazorPayController().createOrderRazorPay(isTopup: true, amount: int.parse(_amountController.text)).then((value) {
                                  if (value != null) {
                                    CreateRazorPayOrderModel result = value;

                                    openCheckout(
                                      amount: _amountController.text,
                                      orderId: result.id,
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    showAlert(_globalKey.currentContext!, response: "Something went wrong, please contact admin.".tr(), colors: Colors.red);
                                  }
                                });
                              } else if (selectedRadioTile == "PayPal") {
                                Navigator.pop(context);
                                showLoadingAlert();
                                paypalPaymentSheet();
                              } else if (selectedRadioTile == "PayStack") {
                                Navigator.pop(context);
                                showLoadingAlert();
                                payStackPayment();
                              } else if (selectedRadioTile == "FlutterWave") {
                                _flutterWaveInitiatePayment(context);
                              } else if (selectedRadioTile == "Midtrans") {
                                midtransMakePayment(context: context, amount: _amountController.text);
                              } else if (selectedRadioTile == "OrangeMoney") {
                                orangeMakePayment(context: context, amount: _amountController.text);
                              } else if (selectedRadioTile == "Xendit") {
                                xenditPayment(context, _amountController.text);
                              }
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppThemeData.primary300,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                  child: Text(
                                "Continue".tr().toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  bool stripe = true;

  bool razorPay = false;
  bool payTm = false;
  bool paypal = false;
  bool payStack = false;
  bool flutterWave = false;
  bool payFast = false;
  bool mercadoPago = false;
  bool xendit = false;
  bool orange = false;
  bool Midtrans = false;

  ///
  ///
  ///

  /// RazorPay Payment Gateway
  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': razorPayData!.razorpayKey,
      'amount': amount * 100,
      'name': 'Emart',
      'order_id': orderId,
      "currency": currencyData?.code,
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': MyAppState.currentUser!.phoneNumber,
        'email': MyAppState.currentUser!.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorPay.open(options);
    } catch (e) {
      debugPrint('error'.tr() + ': $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentCompleted(paymentMethod: "RazorPay");
  }

  void _handleExternalWaller(ExternalWalletResponse response) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Payment Processing Via".tr() + "\n" + response.walletName!,
      ),
      backgroundColor: Colors.blue.shade400,
      duration: const Duration(seconds: 8),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Payment Failed!!".tr() + "\n" + jsonDecode(response.message!)['error']['description'],
      ),
      backgroundColor: Colors.red.shade400,
      duration: const Duration(seconds: 8),
    ));
  }

  /// PayPal Payment Gateway
  paypalPaymentSheet() {
    //add 1 item to cart. Max is 4!
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          // random prices
          amount: double.parse(_amountController.text),

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }
    // initPayPal();
    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }

  /// Stripe Payment Gateway
  Future<void> stripeMakePayment({required String amount}) async {
    try {
      paymentIntentData = await createStripeIntent(
        amount,
      );
      print('----->paymentIntentData :${paymentIntentData!.keys.toString()}');
      if (paymentIntentData!.containsKey("error")) {
        Navigator.pop(context);
        showAlert(_scaffoldKey.currentContext, response: "Something went wrong, please contact admin.".tr(), colors: Colors.red);
      } else {
        print('----->paymentIntentData :${paymentIntentData!['client_secret']}');
        await stripe1.Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: stripe1.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
              customerId: paymentIntentData!['customer'],
              applePay: const stripe1.PaymentSheetApplePay(
                merchantCountryCode: 'US',
              ),
              allowsDelayedPaymentMethods: false,
              googlePay: stripe1.PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                testEnv: true,
                currencyCode: currencyData!.code,
              ),
              style: ThemeMode.system,
              customFlow: true,
              appearance: stripe1.PaymentSheetAppearance(
                colors: stripe1.PaymentSheetAppearanceColors(
                  primary: AppThemeData.primary300,
                ),
              ),
              merchantDisplayName: 'Emart',
            ))
            .then((value) {});
        setState(() {});
        displayStripePaymentSheet();
      }
    } catch (e, s) {
      print('----->exception:$e$s');
    }
  }

  displayStripePaymentSheet() async {
    print('----->exception:');
    try {
      await stripe1.Stripe.instance.presentPaymentSheet().then((value) async {
        Navigator.pop(context);
        paymentCompleted(paymentMethod: "Stripe");
        paymentIntentData = null;
      });
    } on stripe1.StripeException catch (e) {
      print("============${e}");
      print("============${jsonEncode(e)}");
      Navigator.pop(context);
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      showDialog(context: context, builder: (_) => AlertDialog(content: Text("Payment Failed")));
    } catch (e) {
      print('$e');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$e"),
        duration: const Duration(seconds: 8),
        backgroundColor: Colors.red,
      ));
    }
  }

  createStripeIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currencyData!.code,
      };
      print(body);
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body, headers: {'Authorization': 'Bearer ${stripeData?.stripeSecret}', 'Content-Type': 'application/x-www-form-urlencoded'});
      print('Create Intent response ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('error charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  /// Paytm Payment Gateway
  bool isStaging = true;
  String callbackUrl = "http://162.241.125.167/~foodie/payments/paytmpaymentcallback?ORDER_ID=";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  String result = "";

  getPaytmCheckSum(
    context, {
    required double amount,
  }) async {
    final String orderId = UserPreference.getPaymentId();
    print(orderId);
    String getChecksum = "${GlobalURL}payments/getpaytmchecksum";

    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paytmSettingData?.PaytmMID,
          "order_id": orderId,
          "key_secret": paytmSettingData?.PAYTM_MERCHANT_KEY,
        });

    final data = jsonDecode(response.body);

    await verifyCheckSum(checkSum: data["code"], amount: amount, orderId: orderId).then((value) {
      initiatePayment(context, amount: amount, orderId: orderId).then((value) {
        GetPaymentTxtTokenModel result = value;
        String callback = "";
        if (paytmSettingData!.isSandboxEnabled) {
          callback = callback + "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        } else {
          callback = callback + "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        }

        _startTransaction(
          context,
          txnTokenBy: result.body.txnToken,
          orderId: orderId,
          amount: amount,
        );
      });
    });
  }

  Future verifyCheckSum({required String checkSum, required double amount, required orderId}) async {
    String getChecksum = "${GlobalURL}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paytmSettingData?.PaytmMID,
          "order_id": orderId,
          "key_secret": paytmSettingData?.PAYTM_MERCHANT_KEY,
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);
    print(data);
    print(checkSum);
    print(data['status']);
    return data['status'];
  }

  Future<GetPaymentTxtTokenModel> initiatePayment(BuildContext context, {required double amount, required orderId}) async {
    String initiateURL = "${GlobalURL}payments/initiatepaytmpayment";
    String callback = "";
    if (paytmSettingData!.isSandboxEnabled) {
      callback = callback + "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback = callback + "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }

    final response = await http.post(
        Uri.parse(
          initiateURL,
        ),
        headers: {},
        body: {
          "mid": paytmSettingData?.PaytmMID,
          "order_id": orderId,
          "key_secret": paytmSettingData?.PAYTM_MERCHANT_KEY.toString(),
          "amount": amount.toString(),
          "currency": currencyData!.code,
          "callback_url": callback,
          "custId": MyAppState.currentUser!.userID,
          "issandbox": paytmSettingData!.isSandboxEnabled ? "1" : "2",
        });
    final data = jsonDecode(response.body);
    print(data);
    if (data["body"]["txnToken"] == null || data["body"]["txnToken"].toString().isEmpty) {
      Navigator.pop(_scaffoldKey.currentContext!);
      showAlert(_scaffoldKey.currentContext!, response: "something went wrong, please contact admin.".tr(), colors: Colors.red);
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  Future<void> _startTransaction(
    context, {
    required String txnTokenBy,
    required orderId,
    required double amount,
  }) async {
    // try {
    //   var response = AllInOneSdk.startTransaction(
    //     paytmSettingData!.PaytmMID,
    //     orderId,
    //     amount.toString(),
    //     txnTokenBy,
    //     "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",
    //     isStaging,
    //     true,
    //     enableAssist,
    //   );
    //
    //   response.then((value) {
    //     if (value!["RESPMSG"] == "Txn Success") {
    //       Navigator.pop(context);
    //       paymentCompleted(paymentMethod: "Paytm");
    //     }
    //   }).catchError((onError) {
    //     if (onError is PlatformException) {
    //       Navigator.pop(_scaffoldKey.currentContext!);
    //       result = onError.message.toString() + " \n  " + onError.code.toString();
    //       showAlert(_scaffoldKey.currentContext!, response: onError.message.toString(), colors: Colors.red);
    //     } else {
    //       result = onError.toString();
    //       Navigator.pop(_scaffoldKey.currentContext!);
    //       showAlert(_scaffoldKey.currentContext!, response: result, colors: Colors.red);
    //     }
    //   });
    // } catch (err) {
    //   result = err.toString();
    //   Navigator.pop(_scaffoldKey.currentContext!);
    //   showAlert(_scaffoldKey.currentContext!, response: result, colors: Colors.red);
    // }
  }

  ///PayStack Payment Method
  payStackPayment() async {
    await PayStackURLGen.payStackURLGen(
      amount: (double.parse(_amountController.text) * 100).toString(),
      currency: currencyData!.code,
      secretKey: payStackSettingData!.secretKey,
    ).then((value) async {
      if (value != null) {
        PayStackUrlModel _payStackModel = value;
        bool isDone = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PayStackScreen(
                  secretKey: payStackSettingData!.secretKey,
                  callBackUrl: payStackSettingData!.callbackURL,
                  initialURl: _payStackModel.data.authorizationUrl,
                  amount: _amountController.text,
                  reference: _payStackModel.data.reference,
                )));
        Navigator.pop(_scaffoldKey.currentContext!);

        if (isDone) {
          // Navigator.pop(context);
          paymentCompleted(paymentMethod: "PayStack");
        } else {
          hideProgress();
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
            content: Text("Payment UnSuccessful!!".tr() + "\n"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        hideProgress();
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text("Error while transaction!".tr() + "\n"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  ///MercadoPago Payment Method

  mercadoPagoMakePayment() async {
    final headers = {
      'Authorization': 'Bearer ${mercadoPagoSettingData!.accessToken}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": "Test",
          "description": "Test Payment",
          "quantity": 1,
          "currency_id": "BRL", // or your preferred currency
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": MyAppState.currentUser!.email},
      "back_urls": {
        "failure": "${GlobalURL}payment/failure",
        "pending": "${GlobalURL}payment/pending",
        "success": "${GlobalURL}payment/success",
      },
      "auto_return": "approved" // Automatically return after payment is approved
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MercadoPagoScreen(initialURl: data['init_point'])));

      if (isDone) {
        ShowToastDialog.showToast("Payment Successful!!");
        paymentCompleted(paymentMethod: "Mercoado");
      } else {
        ShowToastDialog.showToast("Payment UnSuccessful!!");
      }
    } else {
      print('Error creating preference: ${response.body}');
      return null;
    }
  }

  ///FlutterWave Payment Method
  String? _ref;

  setRef() {
    Random numRef = Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      setState(() {
        _ref = "AndroidRef$year$refNumber";
      });
    } else if (Platform.isIOS) {
      setState(() {
        _ref = "IOSRef$year$refNumber";
      });
    }
  }

  _flutterWaveInitiatePayment(BuildContext context) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${flutterWaveSettingData!.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": _ref,
      "amount": amount,
      "currency": "NGN",
      "redirect_url": "${GlobalURL}payment/success",
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": MyAppState.currentUser!.email.toString(),
        "phonenumber": MyAppState.currentUser!.phoneNumber, // Add a real phone number
        "name": MyAppState.currentUser!.fullName(), // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MercadoPagoScreen(initialURl: data['data']['link'])));

      if (isDone) {
        ShowToastDialog.showToast("Payment Successful!!");
        paymentCompleted(paymentMethod: "FlutterWave");
      } else {
        ShowToastDialog.showToast("Payment UnSuccessful!!");
      }
    } else {
      print('Payment initialization failed: ${response.body}');
      return null;
    }
  }

  //Midtrans payment
  midtransMakePayment({required String amount, required BuildContext context}) async {
    await createPaymentLink(amount: amount).then((url) async {
      ShowToastDialog.closeLoader();
      if (url != '') {
        final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MidtransScreen(initialURl: url)));
        if (isDone) {
          ShowToastDialog.showToast("Payment Successful!!");
          paymentCompleted(paymentMethod: "midtrans");
        } else {
          ShowToastDialog.showToast("Payment Unsuccessful!!");
        }
      }
    });
  }

  Future<String> createPaymentLink({required var amount}) async {
    var ordersId = const Uuid().v1();
    final url = Uri.parse(midTransModel!.isSandbox! ? 'https://api.sandbox.midtrans.com/v1/payment-links' : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': generateBasicAuthHeader(midTransModel!.serverKey!),
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['payment_url'];
    } else {
      ShowToastDialog.showToast("something went wrong, please contact admin.");
      return '';
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
    ShowToastDialog.closeLoader();
    if (paymentURL.toString() != '') {
      final bool isDone = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrangeMoneyScreen(
                    initialURl: paymentURL,
                    accessToken: accessToken,
                    amount: amount,
                    orangePay: orangeMoneyModel!,
                    orderId: orderId,
                    payToken: payToken,
                  )));

      if (isDone) {
        ShowToastDialog.showToast("Payment Successful!!");
        paymentCompleted(paymentMethod: "orangepay");
      } else {
        ShowToastDialog.showToast("Payment Unsuccessful!!");
      }
    } else {
      ShowToastDialog.showToast("Payment Unsuccessful!!");
    }
  }

  Future fetchToken({required String orderId, required String currency, required BuildContext context, required String amount}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': "Basic ${orangeMoneyModel!.auth!}",
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      accessToken = responseData['access_token'];
      return await webpayment(context: context, amountData: amount, currency: currency, orderIdData: orderId);
    } else {
      ShowToastDialog.showToast("Something went wrong, please contact admin.");
      return '';
    }
  }

  Future webpayment({required String orderIdData, required BuildContext context, required String currency, required String amountData}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl =
        orangeMoneyModel!.isSandbox! == true ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment' : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key": orangeMoneyModel!.merchantKey ?? '',
      "currency": orangeMoneyModel!.isSandbox == true ? "OUV" : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url": orangeMoneyModel!.returnUrl!.toString(),
      "cancel_url": orangeMoneyModel!.cancelUrl!.toString(),
      "notif_url": orangeMoneyModel!.notifyUrl!.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode(requestBody),
    );
    print(response.statusCode);
    print(response.body);

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
      ShowToastDialog.showToast("Something went wrong, please contact admin.");
      return '';
    }
  }

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

  //XenditPayment
  xenditPayment(context, amount) async {
    await createXenditInvoice(amount: amount).then((model) async {
      ShowToastDialog.closeLoader();
      if (model.id != null) {
        final bool isDone = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => XenditScreen(
                      initialURl: model.invoiceUrl ?? '',
                      transId: model.id ?? '',
                      apiKey: xenditModel!.apiKey!.toString() ?? "",
                    )));

        if (isDone) {
          ShowToastDialog.showToast("Payment Successful!!");
          paymentCompleted(paymentMethod: "xendit");
        } else {
          ShowToastDialog.showToast("Payment Unsuccessful!!");
        }
      }
    });
  }

  Future<XenditModel> createXenditInvoice({required var amount}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(xenditModel!.apiKey!.toString()),
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
        return model;
      } else {
        return XenditModel();
      }
    } catch (e) {
      return XenditModel();
    }
  }

  Future<void> showLoading({required String message, Color txtColor = Colors.black}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 30,
            child: Text(
              message,
              style: TextStyle(color: txtColor),
            ),
          ),
        );
      },
    );
  }
}

enum PaymentOptionString { RazorPay, Stripe, PayTm, PayPal, PayStack, FlutterWave }
