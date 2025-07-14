import 'dart:async';
import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/page/pos_screen/navigate_pos_screen.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen()  {
    Get.offAll(const NavigatePosScreen());
    getCurrencyData();
  }


  Future<void> getCurrencyData() async {
    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        Constant.currency = value.first;
      }
    });

    await FireStoreUtils.getActiveTax().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });
  }

}
