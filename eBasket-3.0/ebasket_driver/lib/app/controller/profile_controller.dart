import 'package:flutter/material.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<DriverModel> userModel = DriverModel().obs;
  RxBool isLoading = true.obs;

  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> businessNameController =
      TextEditingController().obs;
  Rx<TextEditingController> businessAddressController =
      TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> emailAddressController =
      TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        userModel.value = value;

        isLoading.value = false;
      }
    });
  }
}
