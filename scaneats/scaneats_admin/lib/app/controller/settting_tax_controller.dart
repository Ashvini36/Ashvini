import 'package:flutter/material.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingsTaxController extends GetxController {
  RxString title = 'Taxes'.obs;

  var nameController = TextEditingController().obs;
  var rateController = TextEditingController().obs;
  RxString status = "Active".obs;
  RxBool isgetTaxLoading = false.obs;
  RxList<TaxModel> taxList = <TaxModel>[].obs;

  RxString selectedType = "Fix".obs;

  Future<void> getTaxData() async {
    isgetTaxLoading.value = true;
    await FireStoreUtils.getTax().then((value) {
      if (value!.isNotEmpty) {
        taxList.value = value;
        isgetTaxLoading.value = false;
      } else {
        isgetTaxLoading.value = false;
      }
    });
  }

  setEditValue(TaxModel currenciesModel) {
    nameController.value.text = currenciesModel.name.toString();
    rateController.value.text = currenciesModel.rate.toString();
    status.value = currenciesModel.isActive == true ? "Active" : "Inactive";
    selectedType.value = currenciesModel.isFix == true ? "Fix" : "Percentage";
  }

  RxBool isaddTaxLoading = false.obs;

  Future<void> addTaxData({String itemCategoryId = '', bool isEdit = false}) async {
    isaddTaxLoading.value = true;
    TaxModel model = TaxModel(
        id: itemCategoryId,
        isActive: status.value == "Active" ? true : false,
        isFix: selectedType.value == "Fix" ? true : false,
        name: nameController.value.text.trim(),
        rate: rateController.value.text.trim());
    await FireStoreUtils.addTax(model).then((value) async {
      if (value.id != null) {
        if (isEdit == false) {
          taxList.add(model);
          isaddTaxLoading.value = false;
        } else {
          for (int i = 0; i < taxList.length; i++) {
            if (taxList[i].id == itemCategoryId) {
              taxList[i] = value;
            }
          }
          isaddTaxLoading.value = false;
        }
        await getActiveTax();
        update();
        Get.back();
        ShowToastDialog.showToast("Tax successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  getActiveTax() async {
    await FireStoreUtils.getActiveTax().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });
  }
  Future<void> deleteTaxById(String taxId) async {
    await FireStoreUtils.deleteTaxById(taxId).then((value) async {
      if (value) {
        for (int i = 0; i < taxList.length; i++) {
          if (taxList[i].id == taxId) {
            taxList.removeAt(i);
          }
        }
        await getActiveTax();
        ShowToastDialog.showToast("Tax has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getTaxData();
  }

  reset() {
    nameController.value = TextEditingController();
    rateController.value = TextEditingController();
    status.value = "Active";
    isgetTaxLoading.value = false;
    isaddTaxLoading.value = false;
  }
}
