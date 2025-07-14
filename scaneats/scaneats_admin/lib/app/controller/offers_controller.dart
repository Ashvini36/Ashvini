import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scaneats/app/model/offer_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OffersController extends GetxController {
  RxString title = 'Offers'.obs;

  RxString selectedType = "Fix".obs;


  Rx<TextEditingController> nameTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> rateTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> codeTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> startDateTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> endDateTextFiledController = TextEditingController().obs;
  RxString image = "".obs;
  Rx<Uint8List> profileImageUin8List = Uint8List(100).obs;

  RxString status = "Active".obs;
  RxBool isGetItemLoading = false.obs;
  RxList<OfferModel> offerList = <OfferModel>[].obs;

  Future<void> getItemAttributeData() async {
    isGetItemLoading.value = true;
    await FireStoreUtils.getAllOffer().then((value) {
      if (value!.isNotEmpty) {
        offerList.value = value;
        isGetItemLoading.value = false;
      } else {
        isGetItemLoading.value = false;
      }
    });
  }

  setEditValue(OfferModel currenciesModel) {
    nameTextFiledController.value.text = currenciesModel.name.toString();
    rateTextFiledController.value.text = currenciesModel.rate.toString();
    codeTextFiledController.value.text = currenciesModel.code.toString();
    startDateTextFiledController.value.text = DateFormat('yyyy-MM-dd – HH:mm a').format(currenciesModel.startDate!.toDate());
    endDateTextFiledController.value.text = DateFormat('yyyy-MM-dd – HH:mm a').format(currenciesModel.endDate!.toDate());
    selectedType.value = currenciesModel.isFix == true ? "Fix" : "Percentage";

    image.value = currenciesModel.image.toString();
    status.value = currenciesModel.isActive == true ? "Active" : "Inactive";
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addOfferData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;

    if (!image.value.contains("firebasestorage.googleapis.com")) {
      image.value = await FireStoreUtils.uploadUserImageToFireStorage(profileImageUin8List.value, "offer/", File(image.value).path.split('/').last);
    }

    OfferModel model = OfferModel(
      id: itemCategoryId,
      isActive: status.value == "Active" ? true : false,
      name: nameTextFiledController.value.text.trim(),
      rate: rateTextFiledController.value.text.trim(),
      code: codeTextFiledController.value.text.trim(),
      isFix: selectedType.value == "Fix"?true:false,
      startDate: Timestamp.fromDate(Constant().stringToDate(startDateTextFiledController.value.text)),
      endDate: Timestamp.fromDate(Constant().stringToDate(endDateTextFiledController.value.text)),
      image: image.value,
    );

    await FireStoreUtils.setOffer(model).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          offerList.add(model);
          isAddItemLoading.value = false;
        } else {
          for (int i = 0; i < offerList.length; i++) {
            if (offerList[i].id == itemCategoryId) {
              offerList.removeAt(i);
              offerList.insert(i, value);
            }
          }
          isAddItemLoading.value = false;
        }
        update();
        Get.back();
        ShowToastDialog.showToast("Offer successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  Future<void> deleteByItemAttributeId(OfferModel languageModel) async {
    await FireStoreUtils.deleteOfferById(languageModel.id.toString()).then((value) {
      if (value == true) {
        for (int i = 0; i < offerList.length; i++) {
          if (offerList[i].id == languageModel.id) {
            offerList.removeAt(i);
          }
        }
        ShowToastDialog.showToast("Branch has been Removed");
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
    nameTextFiledController.value.clear();
    rateTextFiledController.value.clear();
    startDateTextFiledController.value.clear();
    endDateTextFiledController.value.clear();
    image.value = "";
    status.value = "Active";
  }

}
