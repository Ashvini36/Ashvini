import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/model/day_model.dart';
import 'package:scaneats/app/model/payment_method_model.dart';
import 'package:scaneats/app/model/restaurant_model.dart';
import 'package:scaneats/app/model/subscription_model.dart';
import 'package:scaneats/app/model/subscription_transaction.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

class SubscriptionController extends GetxController {
  RxList<SubscriptionModel> subscriptionList = <SubscriptionModel>[].obs;
  RxList<SubscriptionTransaction> subscriptionTransactionList = <SubscriptionTransaction>[].obs;
  RxBool isItemLoading = true.obs;

  Rx<DayModel> selectedDuration = DayModel().obs;

  @override
  void onInit() {
    getAllPlan();
    super.onInit();
  }

  Rx<PaymentMethodModel> paymentModel = PaymentMethodModel().obs;
  Rx<String> selectedPaymentMethod = "".obs;

  getAllPlan() async {
    isItemLoading.value = true;

    await FireStoreUtils.getAllSubscription().then((value) {
      if (value != null) {
        subscriptionList.clear();
        subscriptionList.value = value;
      }
    });
    await FireStoreUtils.getAdminPaymentData().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });

    await getRestaurant();

    update();
  }

  reset() {
    selectedDuration.value = DayModel();
  }

  Rx<RestaurantModel> restaurantModel = RestaurantModel().obs;

  getRestaurant() async {
    await FireStoreUtils.getRestaurantById(restaurantId: CollectionName.restaurantId).then((value) {
      if (value != null) {
        restaurantModel.value = value;
      }
    });

    await FireStoreUtils.getTractionByRestaurantId().then((value) {
      if (value != null) {
        subscriptionTransactionList.value = value;
      }
    });

    isItemLoading.value = false;
  }

  setSubscription({required SubscriptionModel subscriptionModel, required DayModel dayModel, required String paymentType}) async {
    print("========>$paymentType");
    print("========>${subscriptionModel.planName}");
    print("========>${dayModel.name}");
    await FireStoreUtils.getRestaurantById(restaurantId: CollectionName.restaurantId).then((value) {
      if (value != null) {
        restaurantModel.value = value;
      }
    });

    SubscriptionTransaction subscriptionTransaction = SubscriptionTransaction(
        id: Constant().getUuid(),
        durations: dayModel,
        subscriptionId: subscriptionModel.id,
        startDate: Timestamp.now(),
        endDate: subscriptionModel.planName == "Trial"
            ? Timestamp.fromDate(DateTime.now().add(Duration(days: int.parse(dayModel.planPrice.toString()))))
            : Timestamp.fromDate(DateTime.now().add(Duration(days: Constant.dayCalculationOfSubscription(dayModel)))),
        restaurantId: restaurantModel.value.id,
        paymentType: paymentType,
        subscription: subscriptionModel);

    SubscribedModel subScribeModel = SubscribedModel(
      subscriptionId: subscriptionModel.id,
      durations: dayModel,
      startDate: Timestamp.now(),
      endDate: subscriptionModel.planName == "Trial"
          ? Timestamp.fromDate(DateTime.now().add(Duration(days: int.parse(dayModel.planPrice.toString()))))
          : Timestamp.fromDate(DateTime.now().add(Duration(days: Constant.dayCalculationOfSubscription(dayModel)))),
    );
    if (subscriptionModel.planName == "Trial") {
      restaurantModel.value.isTrail = true;
    }
    restaurantModel.value.subscription = subscriptionModel;
    restaurantModel.value.subscribed = subScribeModel;

    await FireStoreUtils.setSubscriptionTraction(model: subscriptionTransaction);
    await FireStoreUtils.setRestaurant(model: restaurantModel.value).then((value) {
      if (subscriptionModel.planName == "Trial") {
        getRestaurant();
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
