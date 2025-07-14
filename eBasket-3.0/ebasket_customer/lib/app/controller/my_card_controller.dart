import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/my_card.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';


class CardController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<CardData> cardList = <CardData>[].obs;
  RxString cardType = ''.obs;
  Rx<GlobalKey<FormState>> globalKey = GlobalKey<FormState>().obs;
  RxString cardNumber = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cvv = ''.obs;

  @override
  void onInit() {
    getCardData();
    super.onInit();
  }

  getCardData() async {
    await FireStoreUtils.getCardList(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        cardList.value = value;
      }
      update();
    });
    isLoading.value = false;
  }

}
