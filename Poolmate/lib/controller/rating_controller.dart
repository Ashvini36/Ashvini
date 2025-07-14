import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poolmate/model/booking_model.dart';
import 'package:poolmate/model/review_model.dart';
import 'package:poolmate/model/user_model.dart';
import 'package:poolmate/utils/fire_store_utils.dart';

class RatingController extends GetxController {
  RxBool isLoading = true.obs;
  RxDouble rating = 0.0.obs;
  Rx<TextEditingController> commentController = TextEditingController().obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<UserModel> createdByUserModel = UserModel().obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getArgument();
  }



  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
    }
    await FireStoreUtils.getUserProfile(bookingModel.value.createdBy.toString()).then((value) {
      if (value != null) {
        createdByUserModel.value = value;
      }
    });
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
    await FireStoreUtils.getReview("${bookingModel.value.id}-${userModel.value.id}").then((value) {
      if (value != null) {
        reviewModel.value = value;
        rating.value = double.parse(reviewModel.value.rating.toString());
        commentController.value.text = reviewModel.value.comment.toString();
      }
    });
    isLoading.value = false;
    update();
  }
}
