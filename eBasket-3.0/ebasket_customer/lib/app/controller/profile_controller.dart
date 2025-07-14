import 'package:ebasket_customer/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/user_model.dart';

class ProfileController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  RxBool isLoading = true.obs;

  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> businessNameController = TextEditingController().obs;
  Rx<TextEditingController> businessAddressController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailAddressController = TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    if (Constant.currentUser.id != null) {
      await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
        if (value != null) {
          userModel.value = value;
        }
      });
    }
    isLoading.value = false;
  }
}
