import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:get/get.dart';

class SettingsItemCategoriesController extends GetxController {
  RxString title = 'Item Categories'.obs;

  var nameController = TextEditingController().obs;
  var descController = TextEditingController().obs;
  var imageUrl = ''.obs;
  Rx<Uint8List> imageUin8List = Uint8List(100).obs;
  RxString status = "Active".obs;
  RxBool isgetItemLoading = false.obs;
  RxList<ItemCategoryModel> itemCategoryList = <ItemCategoryModel>[].obs;

  Future<void> getItemCategoriesData() async {
    isgetItemLoading.value = true;
    await FireStoreUtils.getItemCategory().then((value) {
      if (value!.isNotEmpty) {
        itemCategoryList.value = value;
        isgetItemLoading.value = false;
      } else {
        isgetItemLoading.value = false;
      }
    });
  }

  RxBool isaddItemLoading = false.obs;

  Future<void> addItemCategoriesData({String itemCategoryId = '', bool isEdit = false}) async {
    printLog("Image :: ${imageUrl.value}");
    isaddItemLoading.value = true;
    if (!imageUrl.value.contains("firebasestorage.googleapis.com")) {
      imageUrl.value = await FireStoreUtils.uploadUserImageToFireStorage(imageUin8List.value, "Item/categories/", File(imageUrl.value).path.split('/').last);
    }
    ItemCategoryModel model = ItemCategoryModel(
        id: itemCategoryId,
        isActive: status.value == "Active" ? true : false,
        name: nameController.value.text.trim(),
        description: descController.value.text.trim(),
        image: imageUrl.value);

    await FireStoreUtils.addItemCategory(model).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          itemCategoryList.add(model);
          isaddItemLoading.value = false;
        } else {
          for (int i = 0; i < itemCategoryList.length; i++) {
            if (itemCategoryList[i].id == itemCategoryId) {
              itemCategoryList[i] = value;
            }
          }
          isaddItemLoading.value = false;
        }

        update();
        Get.back();
        ShowToastDialog.showToast("Category successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  Future<void> deleteByItemCategoryId(String itemId) async {
    await FireStoreUtils.deleteByItemCategoryId(itemId).then((value) {
      if (value) {
        for (int i = 0; i < itemCategoryList.length; i++) {
          if (itemCategoryList[i].id == itemId) {
            itemCategoryList.removeAt(i);
          }
        }
        ShowToastDialog.showToast("Categories item has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getItemCategoriesData();
  }

  reset() {
    nameController.value = TextEditingController();
    descController.value = TextEditingController();
    imageUrl.value = '';
    imageUin8List.value = Uint8List(100);
    status.value = "Active";
    isgetItemLoading.value = false;
    isaddItemLoading.value = false;
  }
}
