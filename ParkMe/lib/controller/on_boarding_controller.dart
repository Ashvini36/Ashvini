import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkMe/model/on_boarding_model.dart';
import 'package:parkMe/utils/fire_store_utils.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  @override
  void onInit() {
    getOnBoardingData();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<OnBoardingModel> onBoardingList = <OnBoardingModel>[].obs;

  getOnBoardingData() async {
    await FireStoreUtils.getOnBoardingList().then((value) {
      onBoardingList.value = value;
      isLoading.value = false;
    });
    update();
  }
}
