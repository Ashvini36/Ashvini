import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_driver/app/model/location_lat_lng.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/constant.dart';

class EditProfileController extends GetxController {
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
  Rx<TextEditingController> countryCode =
      TextEditingController(text: "+91").obs;
  Rx<TextEditingController> emailAddressController =
      TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;
  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;

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

        fullNameController.value.text = userModel.value.name.toString();

        pinCodeController.value.text = userModel.value.pinCode.toString();
        mobileNumberController.value.text =
            userModel.value.phoneNumber.toString();
        countryCode.value.text = userModel.value.countryCode.toString();
        emailAddressController.value.text = userModel.value.email.toString();
        profileImage.value = userModel.value.profilePictureURL.toString();
        locationLatLng.value = LocationLatLng(  latitude:userModel.value.location!.latitude, longitude:userModel.value.location!.longitude);

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
    if (Constant().hasValidUrl(profileImage.value) == false &&
        profileImage.value.isNotEmpty) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }

    DriverModel user = userModel.value;
    user.name = fullNameController.value.text;
    user.pinCode = pinCodeController.value.text;
    user.phoneNumber = mobileNumberController.value.text;
    user.email = emailAddressController.value.text;
    user.profilePictureURL = profileImage.value.toString();
    user.countryCode = countryCode.value.text;

    user.location = locationLatLng.value;


    FireStoreUtils.updateCurrentUser(user).then(
      (value) {
        Constant.currentLocation = LocationLatLng(
            latitude: locationLatLng.value.latitude,
            longitude: locationLatLng.value.latitude);
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
