import 'package:flutter/material.dart';
import 'package:scaneats/app/model/restaurant_model.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingsDetailsController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> websiteController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  Rx<TextEditingController> zipCodeController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  RxBool isLoading =true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getCompanyDetails().then((value) {
      if (value != null) {
        nameController.value.text = value.name.toString();
        emailController.value.text = value.email.toString();
        phoneController.value.text = value.phoneNumber.toString();
        websiteController.value.text = value.webSiteUrl.toString();
        cityController.value.text = value.city.toString();
        stateController.value.text = value.state.toString();
        codeController.value.text = value.countryCode.toString();
        zipCodeController.value.text = value.zipCode.toString();
        addressController.value.text = value.address.toString();
      }
      isLoading.value = false;
      update();
    });
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addCompanyData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;
    RestaurantModel model = RestaurantModel(
      name: nameController.value.text.trim(),
      email: emailController.value.text.trim(),
      phoneNumber: phoneController.value.text,
      webSiteUrl: websiteController.value.text,
      city: cityController.value.text,
      state: stateController.value.text,
      countryCode: codeController.value.text,
      zipCode: zipCodeController.value.text,
      address: addressController.value.text,
    );

    await FireStoreUtils.addUpdateCompanyDetails(model).then((value) {
      update();
      isAddItemLoading.value = false;
      ShowToastDialog.showToast("Company details updated successfully.");
    });
  }
}
