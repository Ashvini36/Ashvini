import 'package:flutter/material.dart';
import 'package:scaneats/app/model/currencies_model.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var forgotPasswordController = TextEditingController().obs;
  var slugController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  RxString title = 'Welcome Back'.obs;
  RxBool activeRemember = false.obs;
  RxBool isLoading = false.obs;

  RxBool isPasswordVisible = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    if (emailController.value.text.trim().isEmpty || passwordController.value.text.trim().isEmpty) {
      isLoading.value = false;
      ShowToastDialog.showToast("Please Enter Email Or password");
    } else {
      await FireStoreUtils.loginWithEmailAndPassword(emailController.value.text, passwordController.value.text).then((value) {
        if (value.id != null) {
          isLoading.value = false;
          print("======>${value.id.toString()}");
          Preferences.setString(Preferences.user, value.id.toString());
          Get.offAll(const DashBoardScreen());
        } else {
          isLoading.value = false;
          ShowToastDialog.showToast("Invalid Email Or password");
        }
      });
    }
  }

  Future<void> loginForMobile() async {
    isLoading.value = true;
    if (emailController.value.text.trim().isEmpty || passwordController.value.text.trim().isEmpty || slugController.value.text.isEmpty) {
      isLoading.value = false;
      ShowToastDialog.showToast("Please Enter Email Or password or Website slug");
    } else {
      await FireStoreUtils.getRestaurantBySlug(slugController.value.text.trim()).then((value) async {
        if (value != null) {
          if (value.isNotEmpty) {
            Preferences.setString(Preferences.restaurantSlug, slugController.value.text.trim());
            CollectionName.restaurantId = value.first.id.toString();
            await FireStoreUtils.loginWithEmailAndPassword(emailController.value.text, passwordController.value.text).then((value) async {
              if (value.id != null) {
                isLoading.value = false;
                Preferences.setString(Preferences.user, value.id.toString());
                await getBranchData();
                Get.offAll(const DashBoardScreen());
              } else {
                isLoading.value = false;
                ShowToastDialog.showToast("Invalid Email Or password");
              }
            });
          } else {
            isLoading.value = false;
            ShowToastDialog.showToast("Website slug (Private Key) is Invalid");
          }
        } else {
          isLoading.value = false;
          ShowToastDialog.showToast("Website slug (Private Key) is Invalid");
        }
      });
    }
  }

  Future<void> getBranchData() async {
    isLoading.value = true;
    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Constant.currency = value.first;
        } else {
          Constant.currency = CurrenciesModel(id: "", isActive: true, name: "Dollar", code: "US", symbol: "\$", decimalDigits: "2", symbolAtRight: false);
        }
      }
    });

    await FireStoreUtils.getActiveCurrenciesOfOwner().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Constant.ownerCurrency = value.first;
        } else {
          Constant.ownerCurrency = CurrenciesModel(id: "", isActive: true, name: "Dollar", code: "US", symbol: "\$", decimalDigits: "2", symbolAtRight: false);
        }
      }
    });

    await FireStoreUtils.getThem().then((value) {
      if (value != null) {
        if (value.color != null && value.color!.isNotEmpty) {
          AppThemeData.crusta500 = HexColor.fromHex(value.color.toString());
        }
        Constant.projectName = value.name.toString();
        Constant.projectLogo = value.logo.toString();
      }
    });

    await FireStoreUtils.getActiveTax().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });

    await FireStoreUtils.getActiveLanguage().then((value) {
      if (value!.isNotEmpty) {
        Constant.lngList = value;
      } else {
        Constant.lngList.add(LanguageModel(
          id: "1234",
          isActive: true,
          name: "English",
          code: "en",
          image:
              "https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/languages%2F836784ec-cba6-40c6-84a0-bb3f4d9f0434?alt=media&token=3f71379b-9898-432f-92ca-9c047e457382",
        ));
      }
    });
    isLoading.value = false;
  }
}
