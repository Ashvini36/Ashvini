import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingsLanguageController extends GetxController {
  RxString title = 'Languages'.obs;


  Rx<TextEditingController> nameTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> codeTextFiledController = TextEditingController().obs;
  RxString image = "".obs;
  Rx<Uint8List> profileImageUin8List = Uint8List(100).obs;

  RxString status = "Active".obs;
  RxBool isGetItemLoading = false.obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;

  Future<void> getItemAttributeData() async {
    isGetItemLoading.value = true;
    await FireStoreUtils.getLanguage().then((value) {
      if (value!.isNotEmpty) {
        languageList.value = value;
        isGetItemLoading.value = false;
      } else {
        isGetItemLoading.value = false;
      }
    });
  }

  setEditValue(LanguageModel currenciesModel) {
    nameTextFiledController.value.text = currenciesModel.name.toString();
    codeTextFiledController.value.text = currenciesModel.code.toString();
    image.value = currenciesModel.image.toString();
    status.value = currenciesModel.isActive == true ? "Active" : "Inactive";
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addBranchesData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;

    if (!image.value.contains("firebasestorage.googleapis.com")) {
      image.value = await FireStoreUtils.uploadUserImageToFireStorage(profileImageUin8List.value, "languages/", File(image.value).path.split('/').last);
    }

    LanguageModel model = LanguageModel(
      id: itemCategoryId,
      isActive: status.value == "Active" ? true : false,
      name: nameTextFiledController.value.text.trim(),
      code: codeTextFiledController.value.text.trim(),
      image: image.value,
    );

    await FireStoreUtils.addLanguage(model).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          languageList.add(model);
          isAddItemLoading.value = false;
        } else {
          for (int i = 0; i < languageList.length; i++) {
            if (languageList[i].id == itemCategoryId) {
              languageList.removeAt(i);
              languageList.insert(i, value);
            }
          }
          isAddItemLoading.value = false;
        }
        Constant.lngList = languageList;
        update();
        Get.back();
        ShowToastDialog.showToast("Language successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
    await FireStoreUtils.getActiveLanguage().then((value) {
      if (value != null) {
        Constant.lngList = value;
      }
    });
  }

  Future<void> deleteByItemAttributeId(LanguageModel languageModel) async {
    await FireStoreUtils.deleteLanguageId(languageModel).then((value) {
      if (value != null) {
        for (int i = 0; i < languageList.length; i++) {
          if (languageList[i].id == languageModel.id) {
            languageList.removeAt(i);
          }
        }
        Constant.lngList = languageList;
        ShowToastDialog.showToast("Branch has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
    await FireStoreUtils.getActiveLanguage().then((value) {
      if (value != null) {
        Constant.lngList = value;
      }else {
        Constant.lngList.add(LanguageModel(
          id: "1234",
          isActive: true,
          name: "English",
          code: "en",
          image: "",
        ));
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getItemAttributeData();
  }

  reset() {
    nameTextFiledController.value.clear();
    codeTextFiledController.value.clear();
    image.value = "";
    status.value = "Active";
  }
}
