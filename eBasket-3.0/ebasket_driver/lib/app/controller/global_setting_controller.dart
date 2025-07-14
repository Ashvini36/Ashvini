import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebasket_driver/app/model/currency_model.dart';
import 'package:ebasket_driver/constant/collection_name.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/services/notification_service.dart';
import 'package:get/get.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    notificationInit();
    getCurrentCurrency();

    super.onInit();
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {}
    });
  }

  getCurrentCurrency() async {
    FireStoreUtils.fireStore.collection(CollectionName.currency).where("isActive", isEqualTo: true).snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        Constant.currencyModel = CurrencyModel.fromJson(event.docs.first.data());
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "INR", decimal: 2, isactive: true, name: "Indian Rupee", symbol: "₹", symbolatright: false);
      }
    });
    await FireStoreUtils().getSettings();
  }
}
