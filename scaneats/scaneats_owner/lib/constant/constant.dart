import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/model/currencies_model.dart';
import 'package:scaneats_owner/app/model/day_model.dart';
import 'package:scaneats_owner/app/model/language_model.dart';
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/app/model/subscription_model.dart';
import 'package:scaneats_owner/app/model/subscription_transaction.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/Preferences.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

class Constant {
  static String projectName = "SCANEATS";
  static String projectLogo = "";

  static const String phoneLoginType = "phone";
  static const String googleLoginType = "google";
  static const String appleLoginType = "apple";
  static String adminWebSite = "https://New_customer_domain.com?restaurant=";
  static CurrenciesModel currency = CurrenciesModel();

  static String customerRole = "customer";
  static String employeeRole = "employee";
  static String administratorRole = "administrator";

  static String serverKey = "";

  static List<String> rateTypeList = ['Fix', 'Percentage'];
  static List<bool> booleanList = [true, false];
  static String placeholderURL =
      'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/profileImage%2FplaceHolder.jpeg?alt=media&token=b5c83bc3-f919-4bd7-a025-efb0b8db39ad';

  static List<LanguageModel> lngList = <LanguageModel>[];
  static List<String> exportList = ["PDF", "XLSX", "CSV"];
  static List<String> restaurantSubscriptionList = ["All", "Active", "Expired"];
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

  static bool checkSubscription(SubscribedModel? subscriptionModel) {
    bool isSubscribe = false;
    if (subscriptionModel != null) {
      if (subscriptionModel.endDate != null) {
        if (DateTime.now().isBefore(subscriptionModel.endDate!.toDate())) {
          isSubscribe = true;
        } else {
          isSubscribe = false;
        }
      }
    }

    return isSubscribe;
  }

  static bool checkSubscriptionOfTraction(SubscriptionTransaction? subscriptionModel) {
    bool isSubscribe = false;
    if (subscriptionModel != null) {
      if (subscriptionModel.endDate != null) {
        if (DateTime.now().isBefore(subscriptionModel.endDate!.toDate())) {
          isSubscribe = true;
        } else {
          isSubscribe = false;
        }
      }
    }

    return isSubscribe;
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

  static String demoAppMsg = 'This is for demo, you are not allow to update this content.';
  static int toastDuration = 2;

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

  static String orderId({String orderId = ''}) {
    return "#${(orderId).substring(orderId.length - 6)}";
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

  static String amountShow({String amount = ''}) {
    if (Constant.currency.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))}${Constant.currency.symbol.toString()}";
    } else {
      return "${Constant.currency.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(int.parse(Constant.currency.decimalDigits!))}";
    }
  }

  static bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  String getUuid() {
    var uuid = const Uuid();
    return uuid.v4();
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
      switch (error.code) {
        case 'email-already-in-use':
          ShowToastDialog.showToast('Admin Email already in use, Please pick another email!');
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

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    return LanguageModel.fromJson(userMap);
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
