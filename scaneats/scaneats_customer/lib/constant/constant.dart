import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/constant/show_toast_dialog.dart';
import 'package:scaneats_customer/model/branch_model.dart';
import 'package:scaneats_customer/model/currencies_model.dart';
import 'package:scaneats_customer/model/offer_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/model/payment_method_model.dart';
import 'package:scaneats_customer/model/restaurant_model.dart';
import 'package:scaneats_customer/model/tax_model.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';
import 'package:scaneats_customer/widget/text_widget.dart';
import 'package:uuid/uuid.dart';

class Constant {
  static String projectName = "SCANEATS";
  static String projectLogo = "";

  static const String phoneLoginType = "phone";
  static const String googleLoginType = "google";
  static const String appleLoginType = "apple";
  static String customerWebSite = "https://New_customer_domain.com/";
  static String serverKey = "";
  static BranchModel selectedBranch = BranchModel();
  static CurrenciesModel currency = CurrenciesModel();
  static RestaurantModel restaurantModel = RestaurantModel();
  static List<TaxModel> taxList = [];

  static String tableNo = '';
  static String branchId = '';
  static String? paymentStatus = "";

  static List<String> rateTypeList = ['Fix', 'Percentage'];
  static List<bool> booleanList = [true, false];
  static String placeHolderImage = 'assets/images/photos.png';
  static String userPlaceholderURL =
      'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/profileImage%2FplaceHolder.jpeg?alt=media&token=b5c83bc3-f919-4bd7-a025-efb0b8db39ad';
  static String placeholderURL = 'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/placeholder.png?alt=media&token=6627a0eb-a45e-4de5-a78a-e07a64817760';

  //Item show Per Page
  static int itemPerPage = 7;
  static String statusOrderPlaced = "Order Placed";
  static String statusDelivered = "Delivered";
  static String statusAccept = "Accepted";
  static String statusPending = "Pending";
  static String orderTypeTable = "table";
  static String statusRejected = "Rejected";
  static String statusTakeaway = "Takeaway";

  static PaymentMethodModel? paymentModel;

  static List<String> foodType = ["All", "No Veg", "Veg"];

  static String customerRole = "customer";
  static String employeeRole = "employee";
  static String administratorRole = "administrator";

  static String foodVeg = 'Veg';
  static String foodNonVeg = 'Non Veg';

  static String senderId = '';
  static String jsonNotificationFileURL = '';

  static String amountShow({String amount = ''}) {
    if (Constant.currency.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))}${Constant.currency.symbol.toString()}";
    } else {
      return "${Constant.currency.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))}";
    }
  }

  static String percentageAmountShow({String amount = ''}) {
    return "${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))} %";
  }

  double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.isActive == true) {
      if (taxModel.isFix == true) {
        taxAmount = double.parse(taxModel.rate.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.rate!.toString())) / 100;
      }
    }
    return taxAmount;
  }

  double calculateDiscount({String? amount, OfferModel? offerModel}) {
    double taxAmount = 0.0;
    if (offerModel != null && offerModel.isActive == true) {
      if (offerModel.isFix == true) {
        taxAmount = double.parse(offerModel.rate.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(offerModel.rate!.toString())) / 100;
      }
    }
    return taxAmount;
  }

  static Widget loader(context, {Color? color, double? size = 20}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 3.0, color: color ?? (themeChange.getThem() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood500)),
      ),
    );
  }

  static Widget loaderWithNoFound(context, {Color? color, double? size = 130, bool isLoading = true, bool isNotFound = false}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      height: size,
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              visible: isLoading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loader(size: 25, context),
                  spaceW(width: 15),
                  TextCustom(title: 'Loading...', fontSize: 18, color: themeChange.getThem() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood500),
                ],
              )),
          Visibility(visible: isNotFound && !isLoading, child: const TextCustom(title: 'Data Not Found', fontSize: 16)),
        ],
      ),
    );
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM dd,yyyy').format(dateTime);
  }

  static String timestampToDateAndTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – HH:mm a').format(dateTime);
  }

  bool hasValidUrl(String value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  String getUuid() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  Future<DateTime?> selectDate({required BuildContext context, required DateTime date}) async {
    return await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: DateTime(2200),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppThemeData.crusta400, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
              background: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppThemeData.crusta400, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> selectTime({required BuildContext context}) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppThemeData.crusta400, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
              background: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppThemeData.crusta400, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<DateTime?> selectDateAndTime({required BuildContext context, required DateTime date}) async {
    DateTime? finalDate;
    await Constant().selectDate(context: context, date: date).then((newDate) async {
      if (newDate != null) {
        await Constant().selectTime(context: context).then((time) {
          if (time != null) {
            finalDate = DateTime(newDate.year, newDate.month, newDate.day, time.hour, time.minute);
          }
        });
      }
    });
    return finalDate;
  }

  DateTime stringToDate(String dateTime) {
    return DateFormat("yyyy-MM-dd – HH:mm a").parse(dateTime);
    // return DateTime.parse(dateTime);
  }

  Future<String> crateWithEmailOrPassword(String? email, String? password, String appName) async {
    var userId = '';
    try {
      FirebaseApp secondaryApp;
      secondaryApp = await Firebase.initializeApp(name: appName, options: Firebase.app().options);
      var result = await FirebaseAuth.instanceFor(app: secondaryApp).createUserWithEmailAndPassword(email: email!.toLowerCase().trim(), password: password!.trim());
      userId = result.user!.uid.toString();
      await secondaryApp.delete();
      return userId;
    } on auth.FirebaseAuthException catch (error) {
      printLog("Auth Error :: $error");
      switch (error.code) {
        case 'email-already-in-use':
          ShowToastDialog.showToast('Email already in use, Please pick another email!');
          break;
        case 'invalid-email':
          ShowToastDialog.showToast('Enter valid e-mail');
          break;
        case 'operation-not-allowed':
          ShowToastDialog.showToast('Email/password accounts are not enabled');
          break;
        case 'weak-password':
          ShowToastDialog.showToast('Password must be more than 5 characters');
          break;
        case 'too-many-requests':
          ShowToastDialog.showToast('Too many requests, Please try again later.');
          break;
        case 'firebase_auth/unknown':
          ShowToastDialog.showToast('Email Already Exist.');
          break;
        case 'unknown':
          ShowToastDialog.showToast('Email Already Exist.');
          break;
        default:
          ShowToastDialog.showToast('notSignUp');
      }
    }

    return userId;
  }

  Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  static OrderModel getOrderData() {
    final String order = Preferences.getString(Preferences.orderData);
    if (order.isEmpty) {
      return OrderModel();
    }
    Map<String, dynamic> userMap = jsonDecode(order);
    return OrderModel.fromJson(userMap);
  }

  static Future<void> setOrderData(OrderModel model) async {
    await Preferences.setString(Preferences.orderData, jsonEncode(model.toStringData()));
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  static String showOrderId({String orderId = ''}) {
    return "#${(orderId).substring(orderId.length > 6 ? (orderId.length - 6) : orderId.length)}";
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
