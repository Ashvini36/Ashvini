import 'dart:async';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/app/ui/login_screen/login_screen.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    var userId = Preferences.getString(Preferences.user);
    if (userId.isEmpty) {
      Get.offAll(const LoginScreen());
    } else {
      Get.offAll(const DashBoardScreen());
    }
  }

}
