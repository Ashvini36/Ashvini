import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/theme_model.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class SettingsThemController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> colourCodeController = TextEditingController().obs;

  RxString logoImage = "".obs;
  Rx<Uint8List> logoImageUin8List = Uint8List(100).obs;
  RxString favImage = "".obs;
  Rx<Uint8List> favImageUin8List = Uint8List(100).obs;
  Rx<Color> selectedColor  = HexColor.fromHex('#aabbcc').obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getThem().then((value) {
      if (value != null) {
        colourCodeController.value.text = value.color.toString();
        nameController.value.text = value.name.toString();
        selectedColor.value = HexColor.fromHex(colourCodeController.value.text);
        logoImage.value = value.logo.toString();
      }
      update();
    });
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addCompanyData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;

    if (Constant().hasValidUrl(logoImage.value) != true) {
      logoImage.value = await FireStoreUtils.uploadUserImageToFireStorage(logoImageUin8List.value, "logo/", File(logoImage.value).path.split('/').last);
    }

    if (Constant().hasValidUrl(favImage.value) != true) {
      favImage.value = await FireStoreUtils.uploadUserImageToFireStorage(favImageUin8List.value, "logo/", File(favImage.value).path.split('/').last);
    }
    ThemeModel model = ThemeModel(
      logo: logoImage.value.toString(),
      color: colourCodeController.value.text.toString(),
      name: nameController.value.text.toString(),
    );

    await FireStoreUtils.addUpdateThem(model).then((value) {
      update();
      isAddItemLoading.value = false;
      AppThemeData.crusta500 = HexColor.fromHex(colourCodeController.value.text.toString());
      Constant.projectName = nameController.value.text.toString();
      Constant.projectLogo = logoImage.value.toString();
      ShowToastDialog.showToast("Theme successfully set!!");
    });
  }
}
