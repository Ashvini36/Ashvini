import 'package:flutter/material.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/app/ui/home_screen/home_screen.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> userIdController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;

  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;

  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  loginUser() async {
    ShowToastDialog.showLoader("Please Wait".tr);
    dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
        userIdController.value.text.trim(),
        passwordController.value.text.trim());
    ShowToastDialog.closeLoader();
    if (result != null && result is DriverModel && result.role == "driver") {
      result.fcmToken = await FireStoreUtils.firebaseMessaging.getToken() ?? '';
      await FireStoreUtils.updateCurrentUser(result).then((value) {
        if (result.active!) {
          Get.offAll(const HomeScreen(),
              transition: Transition.rightToLeftWithFade);
        } else {
          ShowToastDialog.showToast(
              "This user is disable please contact administrator".tr);
        }
      });
    } else if (result != null && result is String) {
      ShowToastDialog.showToast(result);
    } else {
      ShowToastDialog.showToast("Login failed.".tr);
    }
  }
}
