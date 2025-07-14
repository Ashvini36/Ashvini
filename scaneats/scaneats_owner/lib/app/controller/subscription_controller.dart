import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/day_model.dart';
import 'package:scaneats_owner/app/model/subscription_model.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class SubscriptionController extends GetxController {
  RxString title = 'Subscription'.obs;

  Rx<TextEditingController> planNameTextFiledController = TextEditingController().obs;

  Rx<TextEditingController> noOfItemTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> noOfBranchTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> noOfEmployeeTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> noOfOrdersTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> noOfAdminTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> noOfTablePerBranchTextFiledController = TextEditingController().obs;
  RxString status = 'Active'.obs;

  @override
  void onInit() {
    getRestaurant();
    super.onInit();
  }

  RxBool isAddItemLoading = false.obs;
  Rx<SubscriptionModel> editSubscriptionModel = SubscriptionModel().obs;
  RxList<SubscriptionModel> subscriptionList = <SubscriptionModel>[].obs;
  RxBool isRestaurantLoading = true.obs;

  Future<void> getRestaurant() async {
    isRestaurantLoading.value = true;
    subscriptionList.clear();
    await FireStoreUtils.getAllSubscription().then((value) async {
      subscriptionList.addAll(value!);
    });
    isRestaurantLoading.value = false;
  }

  editRestaurantData(SubscriptionModel model) {
    editSubscriptionModel.value = model;
    planNameTextFiledController.value = TextEditingController(text: model.planName);

    noOfItemTextFiledController.value = TextEditingController(text: model.noOfItem);
    noOfBranchTextFiledController.value = TextEditingController(text: model.noOfBranch);
    noOfEmployeeTextFiledController.value = TextEditingController(text: model.noOfEmployee);
    noOfOrdersTextFiledController.value = TextEditingController(text: model.noOfOrders);
    noOfAdminTextFiledController.value = TextEditingController(text: model.noOfAdmin);
    noOfTablePerBranchTextFiledController.value = TextEditingController(text: model.noOfTablePerBranch);
    // if(model.planName == "Trial"){
    //   setTrailDayList.value = model.durations!;
    // }else{
    //   setDayList.value = model.durations!;
    // }
    dayList.value = model.durations!;

    status.value = model.isActive == true ? 'Active' : 'Inactive';
    update();
  }

  Future<void> subscriptionData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;

    SubscriptionModel model = SubscriptionModel(
        id: itemCategoryId,
        isActive: status.value == "Active" ? true : false,
        planName: planNameTextFiledController.value.text,
        noOfItem: noOfItemTextFiledController.value.text,
        noOfBranch: noOfBranchTextFiledController.value.text,
        noOfEmployee: noOfEmployeeTextFiledController.value.text,
        noOfOrders: noOfOrdersTextFiledController.value.text,
        noOfAdmin: noOfAdminTextFiledController.value.text,
        noOfTablePerBranch: noOfTablePerBranchTextFiledController.value.text,
        durations: dayList);

    await FireStoreUtils.setSubscriptionTable(model).then((value) async {
      Get.back();
      isAddItemLoading.value = false;
      await getRestaurant();
    });
  }

  deleteRestaurant(SubscriptionModel model) async {
    await FireStoreUtils.deleteSubscriptionById(model).then((value) {
      getRestaurant();
      ShowToastDialog.showToast("The subscription plan has been successfully deleted.");
    });
  }

  RxList<DayModel> dayList = <DayModel>[].obs;
  List<DayModel> setDayList = <DayModel>[
    DayModel(name: 'Monthly Plan', enable: true, planPrice: "0", strikePrice: "0"),
    DayModel(name: '3-Month Plan', enable: true, planPrice: "0", strikePrice: "0"),
    DayModel(name: '6-Month Plan', enable: true, planPrice: "0", strikePrice: "0"),
    DayModel(name: '1-Year Plan', enable: true, planPrice: "0", strikePrice: "0"),
  ];

  List<DayModel> setTrailDayList = <DayModel>[
    DayModel(name: 'Trial Plan', enable: true, planPrice: "0", strikePrice: "0"),
  ];

  updateList(int index, DayModel dayModel) {
    dayList.removeAt(index);
    dayList.insert(index, dayModel);
    print(dayModel.toJson());
    update();
  }
  //
  // updateTrailList(int index, DayModel dayModel) {
  //   setTrailDayList.removeAt(index);
  //   setTrailDayList.insert(index, dayModel);
  //   update();
  // }

  resetSetting() {
    editSubscriptionModel.value = SubscriptionModel();
    planNameTextFiledController.value.clear();
    noOfItemTextFiledController.value.clear();
    noOfBranchTextFiledController.value.clear();
    noOfEmployeeTextFiledController.value.clear();
    noOfOrdersTextFiledController.value.clear();
    noOfAdminTextFiledController.value.clear();
    noOfTablePerBranchTextFiledController.value.clear();
  }
}
