import 'dart:io';

import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/constant.dart';

class EditProfileController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  RxBool isLoading = true.obs;

  Rx<TextEditingController> fullNameController = TextEditingController().obs;

  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCode = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> emailAddressController = TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;
  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  RxList<AddressModel>? shippingAddressList = <AddressModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;

        fullNameController.value.text = userModel.value.fullName.toString();

        mobileNumberController.value.text = userModel.value.phoneNumber.toString();
        countryCode.value.text = userModel.value.countryCode.toString();
        emailAddressController.value.text = userModel.value.email.toString();
        profileImage.value = userModel.value.image.toString();
        // locationLatLng.value = LocationLatLng(latitude: userModel.value.location!.latitude, longitude: userModel.value.location!.longitude);
        for (var e in userModel.value.shippingAddress!) {
          shippingAddressList!.add(e);
        }
        isLoading.value = false;
      }
    });
  }

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }

  updateProfile() async {
    ShowToastDialog.showLoader("Please Wait".tr);
    if (Constant().hasValidUrl(profileImage.value) == false && profileImage.value.isNotEmpty) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }

    UserModel user = userModel.value;
    user.fullName = fullNameController.value.text;

    user.phoneNumber = mobileNumberController.value.text;
    user.email = emailAddressController.value.text;
    user.countryCode = countryCode.value.text;
    user.image = profileImage.value;

    FireStoreUtils.updateCurrentUser(user).then(
      (value) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
          "Profile updated successfully".tr,
        );
        Get.back();
        update();
      },
    );
  }
}
