import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressController extends GetxController {
  Rx<TextEditingController> address = TextEditingController().obs;
  Rx<TextEditingController> landmark = TextEditingController().obs;
  Rx<TextEditingController> locality = TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;
  RxList saveAsList = ['Home', 'Work', 'Hotel', 'other'].obs;
  RxString selectedSaveAs = "Home".obs;

  Rx<UserLocation> userLocation = UserLocation().obs;
  Rx<UserModel> userModel = UserModel().obs;

  RxList<AddressModel> shippingAddress = <AddressModel>[].obs;
  Rx<AddressModel> addressModel = AddressModel().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxInt index = 0.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  dynamic argumentData = Get.arguments;

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;

        update();
      }
    });
    shippingAddress.value = userModel.value.shippingAddress!;
    if (argumentData != null) {
      index.value = argumentData['index'];
      addressModel.value = shippingAddress[index.value];
      address.value.text = addressModel.value.address.toString();
      landmark.value.text = addressModel.value.landmark.toString();
      locality.value.text = addressModel.value.locality.toString();
      pinCodeController.value.text = addressModel.value.pinCode.toString();
      selectedSaveAs.value = addressModel.value.addressAs.toString();
      userLocation.value = addressModel.value.location!;
    }
    update();
  }
}
