import 'dart:async';

import 'package:ebasket_driver/app/ui/home_screen/home_screen.dart';
import 'package:ebasket_driver/app/ui/login_screen/login_screen.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';

import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    bool isLogin = await FireStoreUtils.isLogin();
    if (isLogin == true) {
      Get.offAll(const HomeScreen(),
          transition: Transition.rightToLeftWithFade);
    } else {
      Get.offAll(const LoginScreen(),
          transition: Transition.rightToLeftWithFade);
    }
  }
}
