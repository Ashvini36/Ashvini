import 'package:flutter/material.dart';
import 'package:scaneats/app/model/lat_lng_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

import '../model/branch_model.dart';

class SettingsBranchesController extends GetxController {
  RxString title = 'Branches'.obs;


  Rx<TextEditingController> nameTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> emailTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> phoneTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> cityTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> stateTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> zipCodeTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> addressCodeTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> latitudeTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> longLatitudeTextFiledController = TextEditingController().obs;

  RxString status = "Active".obs;
  RxBool isGetItemLoading = false.obs;
  RxList<BranchModel> branchList = <BranchModel>[].obs;

  Future<void> getItemAttributeData() async {
    isGetItemLoading.value = true;
    await FireStoreUtils.getAllBranch().then((value) {
      if (value!.isNotEmpty) {
        branchList.value = value;
        isGetItemLoading.value = false;
      } else {
        isGetItemLoading.value = false;
      }
    });
  }

  setEditValue(BranchModel currenciesModel) {
    nameTextFiledController.value.text = currenciesModel.name.toString();
    emailTextFiledController.value.text = currenciesModel.email.toString();
    phoneTextFiledController.value.text = currenciesModel.phoneNumber.toString();
    cityTextFiledController.value.text = currenciesModel.city.toString();
    stateTextFiledController.value.text = currenciesModel.state.toString();
    zipCodeTextFiledController.value.text = currenciesModel.zipCode.toString();
    addressCodeTextFiledController.value.text = currenciesModel.address.toString();
    status.value = currenciesModel.isActive == true ? "Active" : "Inactive";
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addBranchesData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;
    BranchModel model = BranchModel(
        id: itemCategoryId,
        isActive: status.value == "Active" ? true : false,
        name: nameTextFiledController.value.text.trim(),
        email: emailTextFiledController.value.text.trim(),
        phoneNumber: phoneTextFiledController.value.text.trim(),
        city: cityTextFiledController.value.text.trim(),
        state: stateTextFiledController.value.text.trim(),
        zipCode: zipCodeTextFiledController.value.text.trim(),
        address: addressCodeTextFiledController.value.text.trim(),
        latLng: LatLngModel(latitude: latitudeTextFiledController.value.text, longLatitude: longLatitudeTextFiledController.value.text));

    await FireStoreUtils.addBranch(model).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          branchList.add(model);
          isAddItemLoading.value = false;
        } else {
          for (int i = 0; i < branchList.length; i++) {
            if (branchList[i].id == itemCategoryId) {
              branchList.removeAt(i);
              branchList.insert(i, value);
            }
          }
          isAddItemLoading.value = false;
        }
        update();
        Get.back();
        ShowToastDialog.showToast("Branch successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
    await getBranch();
  }

  getBranch() async {
    await FireStoreUtils.getAllBranch().then((value) {
      if (value != null) {
        Constant.allBranch =value;
      }
    });
  }

  Future<void> deleteByItemAttributeId(String itemId) async {
    await FireStoreUtils.deleteBranch(itemId).then((value) {
      if (value) {
        for (int i = 0; i < branchList.length; i++) {
          if (branchList[i].id == itemId) {
            branchList.removeAt(i);
          }
        }
        ShowToastDialog.showToast("Branch has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
    getBranch();
  }

  @override
  void onInit() {
    super.onInit();
    getItemAttributeData();
  }

  reset() {
    nameTextFiledController.value.clear();
    emailTextFiledController.value.clear();
    phoneTextFiledController.value.clear();
    cityTextFiledController.value.clear();
    stateTextFiledController.value.clear();
    zipCodeTextFiledController.value.clear();
    addressCodeTextFiledController.value.clear();
    status.value = "Active";
  }
}
