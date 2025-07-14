import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebasket_customer/app/model/currency_model.dart';
import 'package:ebasket_customer/constant/collection_name.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/services/notification_service.dart';

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
      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getUserProfile(FirebaseAuth.instance.currentUser!.uid).then((value) {
          if (value != null) {
            Constant.currentUser = value;
            Constant.currentUser.fcmToken = token;
            FireStoreUtils.updateCurrentUser( Constant.currentUser);
          }
        });
      }

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
