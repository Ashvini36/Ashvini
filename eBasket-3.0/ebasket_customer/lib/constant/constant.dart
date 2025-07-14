import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/language_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/services/preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_customer/app/model/currency_model.dart';
import 'package:ebasket_customer/app/model/delivery_charge_model.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/app/model/tax_model.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

class Constant {
  static String searchHistoryJson = "assets/json/gbest_search_history.json";

  static String USER_ROLE_CUSTOMER = 'customer';
  static String USER_ROLE_DRIVER = 'driver';
  static String senderId = '';
  static String jsonNotificationFileURL = '';

  static String placeholderImage = '';
  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String refundPolicy = "";
  static String help = "";
  static String aboutUs = "";

  static String globalUrl = "https://ebasket.siswebapp.com/";

  static String vendorRadius = "0";
  static String distance = "0";
  static String selectedMapType = 'osm';

  static String minorderAmount = "";
  static String minimumAmountToDeposit = "0.0";
  static String mapKey = "";

  static DeliveryChargeModel? deliveryChargeModel;

  static CurrencyModel? currencyModel;
  static List<TaxModel>? taxList;
  static String? country;


  static const String inProcess = "InProcess";
  static const String inTransit = "InTransit";
  static const String delivered = "Delivered";

  static AddressModel selectedPosition = AddressModel();

  static UserModel currentUser = UserModel();

  static String getUuid() {
    return const Uuid().v4();
  }

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    log(userMap.toString());
    return LanguageModel.fromJson(userMap);
  }

  static String getKm(LocationLatLng pos1, LocationLatLng pos2) {
    double distanceInMeters = Geolocator.distanceBetween(pos1.latitude!, pos1.longitude!, pos2.latitude!, pos2.longitude!);
    double kilometer = distanceInMeters / 1000;
    debugPrint("KiloMeter$kilometer");
    return kilometer.toStringAsFixed(2).toString();
  }

  static String amountShow({required String? amount}) {
    if (currencyModel!.symbolatright == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(currencyModel!.decimal)}${currencyModel!.symbol.toString()}";
    } else {
      return "${currencyModel!.symbol.toString()}${double.parse(amount.toString()).toStringAsFixed(currencyModel!.decimal)}";
    }
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.enable == true) {
      if (taxModel.type == "fix") {
        taxAmount = double.parse(taxModel.tax.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.tax!.toString())) / 100;
      }
    }
    return taxAmount;
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

  static Future<Map<String, dynamic>> loadJson({required String path}) async {
    String data = await rootBundle.loadString(path);
    return json.decode(data);
  }

  static Widget loader() {
    return Center(
      child: CircularProgressIndicator(color: AppThemeData.groceryAppDarkBlue),
    );
  }

  static Future<String> uploadUserImageToFireStorage(File image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Widget showEmptyView({required String message}) {
    return Center(
      child: Text(message, style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 18)),
    );
  }

  static Widget emptyView({required String image, required String text, String? description = ''}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SvgPicture.asset(image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(image),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 18, fontWeight: FontWeight.w600, color: AppThemeData.black)),
          const SizedBox(
            height: 10,
          ),
          if (description! != '')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(description,
                  textAlign: TextAlign.center, style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 12, fontWeight: FontWeight.w400, color: AppThemeData.black)),
            ),
        ],
      ),
    );
  }

  static double calculateDiscount({String? amount, String? discount}) {
    double discountAmount = 0.0;

    discountAmount = double.parse(amount.toString()) - ((double.parse(amount.toString()) * double.parse(discount.toString())) / 100);

    return discountAmount;
  }

  static String dateFormatTimestamp(Timestamp? timestamp) {
    var format = DateFormat('EEEE, dd MMM, yyyy');
    return format.format(timestamp!.toDate());
  }

  static String getOtpCode() {
    var rng = math.Random();
    return (rng.nextInt(900000) + 100000).toString();
  }
}

const String dateFormatter = 'dd-MMM-y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}
