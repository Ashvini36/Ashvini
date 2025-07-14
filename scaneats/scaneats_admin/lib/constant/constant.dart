import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/currencies_model.dart';
import 'package:scaneats/app/model/day_model.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/app/model/offer_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/restaurant_model.dart';
import 'package:scaneats/app/model/role_model.dart';
import 'package:scaneats/app/model/subscription_model.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

class Constant {
  static String projectName = "SCANEATS";
  static String projectLogo = "";

  static const String phoneLoginType = "phone";
  static const String googleLoginType = "google";
  static const String appleLoginType = "apple";
  static String adminWebSite = "https://New_admin_domain/";
  static String customerWebSite = "https://New_customer_domain/";
  static String? paymentStatus = "";

  static String adminPermissionID = "";
  static String customerPermissionID = "ZRU7aMje5MAVdaH8cfNZ";

  static String customerRole = "customer";
  static String employeeRole = "employee";
  static String administratorRole = "administrator";

  static String serverKey = "";

  static RoleModel selectedRole = RoleModel();

  static List<BranchModel> allBranch = <BranchModel>[];
  static List<LanguageModel> lngList = <LanguageModel>[];
  static List<String> exportList = ["PDF", "XLSX", "CSV"];

  static BranchModel selectedBranch = BranchModel();
  static CurrenciesModel currency = CurrenciesModel();
  static CurrenciesModel ownerCurrency = CurrenciesModel();
  static RestaurantModel restaurantModel = RestaurantModel();
  static List<TaxModel> taxList = [];

  static List<String> rateTypeList = ['Fix', 'Percentage'];
  static List<bool> booleanList = [true, false];
  static String userPlaceholderURL =
      'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/profileImage%2FplaceHolder.jpeg?alt=media&token=b5c83bc3-f919-4bd7-a025-efb0b8db39ad';
  static String placeholderURL = 'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/placeholder.png?alt=media&token=6627a0eb-a45e-4de5-a78a-e07a64817760';

  //Item show Per Page
  // static int itemPerPage = 7;
  static String statusOrderPlaced = "Order Placed";
  static String statusDelivered = "Delivered";
  static String statusAccept = "Accepted";
  static String statusPending = "Pending";
  static String statusRejected = "Rejected";
  static String statusTakeaway = "Takeaway";

  static String paidPayment = "Paid";
  static String unPaidPayment = "Unpaid";

  static String orderTypeTable = "table";
  static String orderTypePos = "pos";
  static String orderTypeCustomer = "customer";

  static String foodVeg = 'Veg';
  static String foodNonVeg = 'Non Veg';

  static String paymentTypeCash = 'Cash';
  static String paymentTypeCard = 'Card';
  static String paymentTypeDegital = 'Digital Payment';

  static List<String> numofpageitemList = ['10', '20', '50', 'All'];

  static String senderId = '';
  static String jsonNotificationFileURL = '';

  static bool isDemo() {
    return false;
  }

  static String demoAppMsg = 'This is for demo, you are not allow to update this content.';
  static int toastDuration = 2;

  static selectBranch(BranchModel selectBranch) {
    Constant.selectedBranch = selectBranch;
  }

  static List<DayModel>? enableSubscriptionList(SubscriptionModel selectBranch) {
    List<DayModel>? durations;
    if (selectBranch.durations != null) {
      durations = selectBranch.durations!.where((element) => element.enable == true).toList();
    }
    return durations;
  }

  static bool? checkCurrentPlanActive(SubscribedModel? selectBranch) {
    bool? durations;
    if (selectBranch != null && selectBranch.durations != null) {
      durations = DateTime.now().isBefore(selectBranch.endDate!.toDate());
    }
    return durations;
  }

  static bool? checkCurrentPlanName(SubscriptionModel selectBranch, RestaurantModel restaurantModel) {
    bool? durations = false;
    if (restaurantModel.subscription != null) {
      if (selectBranch.planName == restaurantModel.subscription!.planName) {
        durations = true;
      }
    }
    return durations;
  }

  static String durationName(DayModel dayModel) {
    String type = "";
    if (dayModel.name == "Monthly Plan") {
      type = "Month";
    } else if (dayModel.name == "3-Month Plan") {
      type = "Quarterly";
    } else if (dayModel.name == "6-Month Plan") {
      type = "Six Month";
    } else if (dayModel.name == "1-Year Plan") {
      type = "Year";
    } else if (dayModel.name == "Trial Plan") {
      type = "${dayModel.planPrice.toString()} days";
    }
    return type;
  }

  static int dayCalculationOfSubscription(DayModel dayModel) {
    int day = 0;
    if (dayModel.name == "Monthly Plan") {
      day = 30;
    } else if (dayModel.name == "3-Month Plan") {
      day = 90;
    } else if (dayModel.name == "6-Month Plan") {
      day = 180;
    } else if (dayModel.name == "1-Year Plan") {
      day = 365;
    }
    return day;
  }

  static String qrCodeLink({required String branchId, required String tableId}) {
    return "${Constant.customerWebSite}?table=$tableId&branchId=$branchId&restaurantId=${CollectionName.restaurantId}";
  }

  static String amountShow({String amount = ''}) {
    if (Constant.currency.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))}${Constant.currency.symbol.toString()}";
    } else {
      return "${Constant.currency.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))}";
    }
  }

  static String amountOwnerShow({String amount = ''}) {
    if (Constant.ownerCurrency.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.ownerCurrency.decimalDigits!))}${Constant.ownerCurrency.symbol.toString()}";
    } else {
      return "${Constant.ownerCurrency.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.ownerCurrency.decimalDigits!))}";
    }
  }

  static String percentageAmountShow({String amount = ''}) {
    return "${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))} %";
  }

  static String orderId({String orderId = ''}) {
    return "#${(orderId).substring(orderId.length - 6)}";
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

  static Widget loaderWithNoFound(context, {Color? color, bool isLoading = true, bool isNotFound = false}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Visibility(visible: isNotFound && !isLoading, child: const Center(child: TextCustom(title: 'Data Not Found', fontSize: 16))),
      ],
    );
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM dd,yyyy').format(dateTime);
  }

  static String timestampToDateAndTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd, HH:mm a').format(dateTime);
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

  static bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
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

  static Future<DateTimeRange?> selectDateAndTimeRange({required BuildContext context, required DateTime date}) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final themeChange = Provider.of<DarkThemeProvider>(context);
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black),
            ),
            colorScheme: ColorScheme.light(
              primary: AppThemeData.crusta400,
              // header background color
              secondary: AppThemeData.crusta400.withOpacity(0.50),
              onPrimary: themeChange.getThem() ? Colors.white : Colors.black,
              // header text color
              onSurface: Colors.black,
              // body text color
              background: Colors.white,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppThemeData.crusta400, // button text color
              ),
            ),
          ),
          child: Column(
            children: [
              Container(constraints: const BoxConstraints(maxWidth: 400.0, maxHeight: 600.0), child: child!),
            ],
          ),
        );
      },
    );
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
    final String order = Preferences.getString(Preferences.order);
    if (order.isEmpty) {
      return OrderModel();
    }
    Map<String, dynamic> userMap = jsonDecode(order);
    return OrderModel.fromJson(userMap);
  }

  static void setOrderData(OrderModel model) {
    OrderModel modelData = model;
    modelData.updatedAt = null;
    modelData.createdAt = null;
    Preferences.setString(Preferences.order, jsonEncode(modelData.toStringData()));
  }

  static Future<void> setSubscription(SubscriptionModel model, DayModel dayModel, String paymentType) async {
    await Preferences.setString(Preferences.subscription, jsonEncode(model.toJson()));
    await Preferences.setString(Preferences.dayModel, jsonEncode(dayModel.toJson()));
    await Preferences.setString(Preferences.paymentType, paymentType);
  }

  static Future<void> clearSubscription() async {
    await Preferences.clearKeyData(Preferences.subscription);
    await Preferences.clearKeyData(Preferences.dayModel);
    await Preferences.clearKeyData(Preferences.paymentType);
  }

  static SubscriptionModel getSubscription() {
    final String user = Preferences.getString(Preferences.subscription);
    Map<String, dynamic> userMap = jsonDecode(user);
    return SubscriptionModel.fromJson(userMap);
  }

  static DayModel getSubscriptionDayModel() {
    final String user = Preferences.getString(Preferences.dayModel);
    Map<String, dynamic> userMap = jsonDecode(user);
    return DayModel.fromJson(userMap);
  }

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    return LanguageModel.fromJson(userMap);
  }

  static String getCurrentTimeString({required DateTime date}) {
    log("getCurrentTimeString :: ${date.toString()}");
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? "Min" : "Mins"}";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${difference.inHours == 1 ? "Hr" : "Hrs"} ${difference.inMinutes.remainder(60)} Min";
    } else {
      int days = difference.inDays;
      int hours = difference.inHours.remainder(24);
      return hours == 0 ? "$days ${days == 1 ? "Day" : "Days"}" : "$days ${days == 1 ? "Day" : "Days"} $hours ${hours == 1 ? "Hr" : "Hrs"}";
    }
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
