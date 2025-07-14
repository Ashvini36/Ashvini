import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/day_model.dart';
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/app/model/subscription_model.dart';
import 'package:scaneats_owner/app/model/subscription_transaction.dart';
import 'package:scaneats_owner/app/model/user_model.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';

class RestaurantController extends GetxController {
  RxString title = 'Restaurant'.obs;

  RxString selectedType = "Fix".obs;

  Rx<TextEditingController> nameTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> emailTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> phoneTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> cityTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> stateTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> countryTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> zipcodeTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> addressTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> slugTextFiledController = TextEditingController().obs;

  Rx<TextEditingController> adminNameTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminEmailTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminPhoneNumberTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminPasswordTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminConformPasswordTextFiledController = TextEditingController().obs;

  RxString domainURL = Constant.adminWebSite.obs;

  RxBool isPasswordVisible = false.obs;
  RxBool isConformationPasswordVisible = false.obs;

  @override
  void onInit() {
    getRestaurant();
    super.onInit();
  }

  RxBool isAddItemLoading = false.obs;
  Rx<RestaurantModel> editRestaurantModel = RestaurantModel().obs;
  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;
  RxList<RestaurantModel> tempList = <RestaurantModel>[].obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxBool isRestaurantLoading = true.obs;
  RxList<SubscriptionModel> subscriptionList = <SubscriptionModel>[].obs;

  Future<void> getRestaurant() async {
    isRestaurantLoading.value = true;
    restaurantList.clear();
    subscriptionList.clear();
    await FireStoreUtils.getAllSubscription().then((value) async {
      subscriptionList.addAll(value!);
    });
    await FireStoreUtils.getAllRestaurant().then((value) async {
      restaurantList.addAll(value!);
      tempList.addAll(value);
    });
    setPagition(totalItemPerPage.value);
  }

  RxString status = 'Active'.obs;

  editRestaurantData(RestaurantModel model) async {
    editRestaurantModel.value = model;
    nameTextFiledController.value = TextEditingController(text: model.name);
    emailTextFiledController.value = TextEditingController(text: model.email);
    phoneTextFiledController.value = TextEditingController(text: model.phoneNumber);
    cityTextFiledController.value = TextEditingController(text: model.city);
    stateTextFiledController.value = TextEditingController(text: model.state);
    countryTextFiledController.value = TextEditingController(text: model.countryCode);
    zipcodeTextFiledController.value = TextEditingController(text: model.zipCode);
    addressTextFiledController.value = TextEditingController(text: model.address);
    slugTextFiledController.value = TextEditingController(text: model.slug);
    domainURL.value = model.webSiteUrl.toString();
    status.value = 'Active';
    await getOwner(model);
  }

  Future addRestaurant() async {
    try {
      if (!emailTextFiledController.value.text.isEmail) {
        ShowToastDialog.showToast("Please Enter the Valid Email.");
        return null;
      } else if (adminPasswordTextFiledController.value.text.length <= 5) {
        ShowToastDialog.showToast("Please Enter Minimum 6 Character Password");
        return null;
      } else if (adminPasswordTextFiledController.value.text != adminConformPasswordTextFiledController.value.text) {
        ShowToastDialog.showToast("Your password and confirmation password do not match.");
        return null;
      } else if (restaurantList.where((p0) => p0.slug == slugTextFiledController.value.text).isNotEmpty) {
        ShowToastDialog.showToast("Restaurant slug already available.");
        return null;
      } else if (adminNameTextFiledController.value.text.trim().isNotEmpty && adminEmailTextFiledController.value.text.trim().isNotEmpty) {
        isAddItemLoading.value = true;

        RestaurantModel restaurantModel = RestaurantModel(
            name: nameTextFiledController.value.text,
            email: emailTextFiledController.value.text,
            phoneNumber: phoneTextFiledController.value.text,
            city: cityTextFiledController.value.text,
            state: stateTextFiledController.value.text,
            zipCode: zipcodeTextFiledController.value.text,
            countryCode: countryTextFiledController.value.text,
            address: addressTextFiledController.value.text,
            slug: slugTextFiledController.value.text,
            webSiteUrl: domainURL.value,
            id: Constant().getUuid(),
            createdAt: Timestamp.now(),
            updateAt: Timestamp.now(),
            isActive: true);

        await FireStoreUtils.setRestaurant(model: restaurantModel);

        String? roleId = "";
        String? userId = await Constant().crateWithEmailOrPassword(adminEmailTextFiledController.value.text, adminPasswordTextFiledController.value.text, Constant().getUuid());
        printLog("Email Data :: $userId");
        if (userId.isEmpty) {
          isAddItemLoading.value = false;
          return null;
        }

        await FireStoreUtils.setRole(restaurantId: restaurantModel.id.toString()).then((value) {
          print('======>$value');
          if (value != null) {
            roleId = value;
          }
        });

        UserModel userModel = UserModel(
            id: userId,
            branchId: '',
            restaurantId: restaurantModel.id,
            name: adminNameTextFiledController.value.text.trim(),
            email: adminEmailTextFiledController.value.text.toLowerCase().trim(),
            mobileNo: adminPhoneNumberTextFiledController.value.text.toLowerCase().trim(),
            password: adminPasswordTextFiledController.value.text.trim(),
            profileImage: '',
            isActive: true,
            role: 'administrator',
            roleId: roleId,
            notificationReceive: false,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now());

        await setCustomerData(userModel, restaurantModel.id.toString());
      } else {
        isAddItemLoading.value = false;
        ShowToastDialog.showToast("All field must be completed. Please provide the necessary information.");
      }
    } catch (e) {
      ShowToastDialog.showToast('notSignUp');
    }
  }

  editRestaurant() async {
    isAddItemLoading.value = true;

    editRestaurantModel.value.name = nameTextFiledController.value.text;
    editRestaurantModel.value.email = emailTextFiledController.value.text;
    editRestaurantModel.value.phoneNumber = phoneTextFiledController.value.text;
    editRestaurantModel.value.city = cityTextFiledController.value.text;
    editRestaurantModel.value.state = stateTextFiledController.value.text;
    editRestaurantModel.value.zipCode = zipcodeTextFiledController.value.text;
    editRestaurantModel.value.countryCode = countryTextFiledController.value.text;
    editRestaurantModel.value.address = addressTextFiledController.value.text;
    editRestaurantModel.value.slug = slugTextFiledController.value.text;
    editRestaurantModel.value.webSiteUrl = domainURL.value;
    editRestaurantModel.value.updateAt = Timestamp.now();

    await FireStoreUtils.setRestaurant(model: editRestaurantModel.value);
    Get.back();
    await getRestaurant();
    isAddItemLoading.value = false;
  }

  Future<void> setCustomerData(UserModel model, String restaurantId) async {
    FireStoreUtils.setUserModel(model: model, restaurantId: restaurantId).then((value) async {
      if (value?.id != null) {
        isAddItemLoading.value = false;
        Get.back();
        getRestaurant();
        ShowToastDialog.showToast("Restaurant create successfully ");
      } else {
        ShowToastDialog.showToast("Something Went Wrong...");
        isAddItemLoading.value = false;
      }
    });
    update();
  }

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<RestaurantModel> currentPageUser = <RestaurantModel>[].obs;

  setPagition(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (restaurantList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > restaurantList.length ? restaurantList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagition(page);
      update();
    } else {
      currentPageUser.value = restaurantList.sublist(startIndex.value, endIndex.value);
    }
    isRestaurantLoading.value = false;
  }

  RxString totalItemPerPage = '10'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return restaurantList.length;
    } else {
      return int.parse(data);
    }
  }

  deleteRestaurant(RestaurantModel model) async {
    await FireStoreUtils.deleteRestaurantById(model).then((value) async {
      await getRestaurant();
      ShowToastDialog.showToast("Restaurant delete Successfully!");
    });
  }

  filter(String type) {
    isRestaurantLoading.value = true;
    restaurantList.clear();
    restaurantList.value = tempList.where(
      (e) {
        return type.toLowerCase() == "Active".toLowerCase()
            ? Constant.checkSubscription(e.subscribed) == true
            : type.toLowerCase() == "Expired".toLowerCase()
                ? Constant.checkSubscription(e.subscribed) == false
                : true;
      },
    ).toList();

    setPagition(totalItemPerPage.value);
    isRestaurantLoading.value = false;
  }

  reset() {
    nameTextFiledController.value.clear();
    emailTextFiledController.value.clear();
    phoneTextFiledController.value.clear();
    cityTextFiledController.value.clear();
    stateTextFiledController.value.clear();
    countryTextFiledController.value.clear();
    zipcodeTextFiledController.value.clear();
    addressTextFiledController.value.clear();
    slugTextFiledController.value.clear();

    adminNameTextFiledController.value.clear();
    adminEmailTextFiledController.value.clear();
    adminPhoneNumberTextFiledController.value.clear();
    adminPasswordTextFiledController.value.clear();
    adminConformPasswordTextFiledController.value.clear();

    domainURL.value = Constant.adminWebSite;
  }

  Rx<DayModel> selectedDuration = DayModel().obs;

  setSubscription(SubscriptionModel subscriptionModel, RestaurantModel restaurantModel) async {
    ShowToastDialog.showLoader("Please wait...");

    SubscriptionTransaction subscriptionTransaction = SubscriptionTransaction(
        id: Constant().getUuid(),
        durations: selectedDuration.value,
        subscriptionId: subscriptionModel.id,
        startDate: Timestamp.now(),
        endDate: subscriptionModel.planName == "Trial"
            ? Timestamp.fromDate(DateTime.now().add(Duration(days: int.parse(selectedDuration.value.planPrice.toString()))))
            : Timestamp.fromDate(DateTime.now().add(Duration(days: Constant.dayCalculationOfSubscription(selectedDuration.value)))),
        restaurantId: restaurantModel.id,
        paymentType: "Cash",
        subscription: subscriptionModel);

    SubscribedModel subScribeModel = SubscribedModel(
      subscriptionId: subscriptionModel.id,
      durations: selectedDuration.value,
      startDate: Timestamp.now(),
      endDate: subscriptionModel.planName == "Trial"
          ? Timestamp.fromDate(DateTime.now().add(Duration(days: int.parse(selectedDuration.value.planPrice.toString()))))
          : Timestamp.fromDate(DateTime.now().add(Duration(days: Constant.dayCalculationOfSubscription(selectedDuration.value)))),
    );
    if (subscriptionModel.planName == "Trial") {
      restaurantModel.isTrail = true;
    }
    restaurantModel.subscription = subscriptionModel;
    restaurantModel.subscribed = subScribeModel;

    await FireStoreUtils.setSubscriptionTraction(model: subscriptionTransaction);
    await FireStoreUtils.setRestaurant(model: restaurantModel).then((value) {
      ShowToastDialog.closeLoader();
      getRestaurant();
      Get.back();
    });
  }

  getOwner(RestaurantModel restaurantModel) async {
    await FireStoreUtils.getUser(restaurantId: restaurantModel.id.toString()).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
  }
}
