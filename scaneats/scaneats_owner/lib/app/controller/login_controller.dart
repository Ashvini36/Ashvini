import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/ui/dashboard_screen.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/utils/Preferences.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  RxString title = 'Welcome Back'.obs;
  RxBool activeRemember = false.obs;
  RxBool isLoading = false.obs;

  RxBool isPasswordVisible = false.obs;

  void login() {
    isLoading.value = true;
    if (emailController.value.text.trim().isEmpty || passwordController.value.text.trim().isEmpty) {
      isLoading.value = false;
      ShowToastDialog.showToast("Please Enter Email Or password");
    } else {
      FireStoreUtils.loginWithEmailAndPassword(emailController.value.text, passwordController.value.text).then((value) {
        isLoading.value = false;
        if (value == true) {
          Preferences.setBoolean(Preferences.isLogin,true);
          Get.offAll(const DashBoardScreen());
        } else {
          ShowToastDialog.showToast("Invalid Email Or password");
        }
      });
    }
  }
}
