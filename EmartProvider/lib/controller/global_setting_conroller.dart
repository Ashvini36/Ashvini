import 'dart:developer';
import 'package:emartprovider/constant/constants.dart';
import 'package:emartprovider/model/currency_model.dart';
import 'package:emartprovider/services/firebase_helper.dart';
import 'package:emartprovider/services/notification_service.dart';
import 'package:get/get.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    notificationInit();
    getCurrentCurrency();
    super.onInit();
  }

  getCurrentCurrency() async {
    await FireStoreUtils().getCurrency().then((value) {
      if (value != null) {
        currencyData = value;
      } else {
        currencyData = CurrencyModel(id: "", code: "USD", decimal: 2, isactive: true, name: "US Dollar", symbol: "\$", symbolatright: false);
      }
    });
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
    });
  }
}
