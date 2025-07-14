import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_driver/app/model/admin_commission_model.dart';
import 'package:ebasket_driver/app/model/currency_model.dart';
import 'package:ebasket_driver/app/model/delievery_charge_model.dart';
import 'package:ebasket_driver/app/model/location_lat_lng.dart';
import 'package:ebasket_driver/app/model/tax_model.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class Constant {
  static String placeHolder = "https://firebasestorage.googleapis.com/v0/b/ebasket-85209.appspot.com/o/images%2Foriginal_1712908816828.png?alt=media&token=1d21d7b8-7df5-4f77-a426-41c84ba8b012";

  static String senderId = '';
  static String jsonNotificationFileURL = '';
  static const String inProcess = "InProcess";
  static const String inTransit = "InTransit";
  static const String delivered = "Delivered";
  static const String orderComplete = "Completed";
  static const String orderCanceled = "Canceled";
  static CurrencyModel? currencyModel;
  static String currency = "₹";
  static LocationLatLng? currentLocation = LocationLatLng(latitude: 23.0225, longitude: 72.5714);
  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String refundPolicy = "";
  static String help = "";
  static String aboutUs = "";
  static String minorderAmount = "";
  static String mapKey = "";
  static AdminCommission? adminCommission;
  static DeliveryChargeModel? deliveryChargeModel;
  static String USER_ROLE_CUSTOMER = 'customer';
  static String USER_ROLE_DRIVER = 'driver';

  static String selectedMapType = 'google';

  static String getUuid() {
    return const Uuid().v4();
  }

  static Future<Map<String, dynamic>> loadJson({required String path}) async {
    String data = await rootBundle.loadString(path);
    return json.decode(data);
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(description,
                  textAlign: TextAlign.center, style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 12, fontWeight: FontWeight.w400, color: AppThemeData.black)),
            ),
        ],
      ),
    );
  }

  static Widget loader() {
    return const Center(
      child: CircularProgressIndicator(color: AppThemeData.groceryAppDarkBlue),
    );
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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

  static Future<String> uploadUserImageToFireStorage(File image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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
