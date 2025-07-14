import 'package:flutter/material.dart';
import 'package:scaneats/app/model/item_attributes_model.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingsItemAttributesController extends GetxController {
  RxString title = 'Item Attributes'.obs;

  var nameController = TextEditingController().obs;
  RxString status = "Active".obs;
  RxBool isgetItemLoading = false.obs;
  RxList<ItemAttributeModel> itemAttributeList = <ItemAttributeModel>[].obs;

  Future<void> getItemAttributeData() async {
    isgetItemLoading.value = true;
    await FireStoreUtils.getItemAttribute().then((value) {
      if (value!.isNotEmpty) {
        itemAttributeList.value = value;
        isgetItemLoading.value = false;
      } else {
        isgetItemLoading.value = false;
      }
    });
  }

  RxBool isaddItemLoading = false.obs;
  Future<void> addItemAttributesData({String itemCategoryId = '', bool isEdit = false}) async {
    isaddItemLoading.value = true;
    ItemAttributeModel model = ItemAttributeModel(id: itemCategoryId, isActive: status.value == "Active" ? true : false, name: nameController.value.text.trim());

    await FireStoreUtils.addItemAttribute(model).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          itemAttributeList.add(model);
          isaddItemLoading.value = false;
        } else {
          for (int i = 0; i < itemAttributeList.length; i++) {
            if (itemAttributeList[i].id == itemCategoryId) {
              itemAttributeList[i] = value;
            }
          }
          isaddItemLoading.value = false;
        }
        update();
        Get.back();
        ShowToastDialog.showToast("Attribute successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  Future<void> deleteByItemAttributeId(String itemId) async {
    await FireStoreUtils.deleteByItemAttributeId(itemId).then((value) {
      if (value) {
        for (int i = 0; i < itemAttributeList.length; i++) {
          if (itemAttributeList[i].id == itemId) {
            itemAttributeList.removeAt(i);
          }
        }
        ShowToastDialog.showToast("Item Attribute Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getItemAttributeData();
  }

  reset() {
    nameController.value = TextEditingController();
    status.value = "Active";
    isgetItemLoading.value = false;
    isaddItemLoading.value = false;
  }
}
