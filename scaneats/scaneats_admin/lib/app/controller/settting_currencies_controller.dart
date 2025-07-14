import 'package:flutter/material.dart';
import 'package:scaneats/app/model/currencies_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingsCurrenciesController extends GetxController {
  RxString title = 'Currencies'.obs;

  var nameController = TextEditingController().obs;

  Rx<TextEditingController> symbolController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  Rx<TextEditingController> decimalDigitController = TextEditingController().obs;

  RxString status = "Active".obs;
  RxBool isgetItemLoading = false.obs;
  RxList<CurrenciesModel> currenciesList = <CurrenciesModel>[].obs;

  RxBool selectedSymbolAtRight = true.obs;

  Future<void> getItemAttributeData() async {
    isgetItemLoading.value = true;
    await FireStoreUtils.getCurrencies().then((value) {
      if (value!.isNotEmpty) {
        currenciesList.value = value;
        isgetItemLoading.value = false;
      } else {
        isgetItemLoading.value = false;
      }
    });
  }

  setEditValue(CurrenciesModel currenciesModel) {
    nameController.value.text = currenciesModel.name.toString();
    decimalDigitController.value.text = currenciesModel.decimalDigits.toString();
    codeController.value.text = currenciesModel.code.toString();
    symbolController.value.text = currenciesModel.symbol.toString();
    status.value = currenciesModel.isActive == true ? "Active" : "Inactive";
    if (currenciesModel.symbolAtRight != null) {
      selectedSymbolAtRight.value = currenciesModel.symbolAtRight!;
    }
  }

  RxBool isaddItemLoading = false.obs;

  Future<void> addCurrenciesData({String itemCategoryId = '', bool isEdit = false}) async {
    isaddItemLoading.value = true;
    if (status.value == "Active") {
      await changeStatus();
    }
    CurrenciesModel model = CurrenciesModel(
        id: itemCategoryId,
        isActive: status.value == "Active" ? true : false,
        name: nameController.value.text.trim(),
        code: codeController.value.text,
        decimalDigits: decimalDigitController.value.text,
        symbolAtRight: selectedSymbolAtRight.value,
        symbol: symbolController.value.text);

    await FireStoreUtils.addCurrencies(model).then((value) {
      if (value.id != null) {
        // if (isEdit == false) {
        //   currenciesList.add(model);
        //   isaddItemLoading.value = false;
        // } else {
        //   for (int i = 0; i < currenciesList.length; i++) {
        //     if (currenciesList[i].id == itemCategoryId) {
        //       currenciesList.removeAt(i);
        //       currenciesList.insert(i, value);
        //     }
        //   }
        //   isaddItemLoading.value = false;
        // }
        isaddItemLoading.value = false;
        getItemAttributeData();
        update();
        Get.back();
        ShowToastDialog.showToast("Currency ${isEdit == true?"Edit":"added"} successfully!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });

    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        Constant.currency = value.first;
      }
    });
  }

  changeStatus() async {
    await FireStoreUtils.getCurrencies().then((value) {
      if (value != null) {
        value.forEach((element) async {
          CurrenciesModel currenciesModel = element;
          currenciesModel.isActive = false;
          await FireStoreUtils.addCurrencies(currenciesModel);
        });
      }
    });
  }

  Future<void> deleteByItemAttributeId(String itemId) async {
    await FireStoreUtils.deleteCurrenciesById(itemId).then((value) {
      if (value) {
        for (int i = 0; i < currenciesList.length; i++) {
          if (currenciesList[i].id == itemId) {
            currenciesList.removeAt(i);
          }
        }
        ShowToastDialog.showToast("Currency item has been Removed");
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
    codeController.value = TextEditingController();
    decimalDigitController.value = TextEditingController();
    symbolController.value = TextEditingController();
    isgetItemLoading.value = false;
    isaddItemLoading.value = false;
  }
}
