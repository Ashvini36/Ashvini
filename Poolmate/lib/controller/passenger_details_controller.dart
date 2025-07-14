import 'package:get/get.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/model/booking_model.dart';
import 'package:poolmate/model/review_model.dart';
import 'package:poolmate/model/user_model.dart';
import 'package:poolmate/utils/fire_store_utils.dart';

class PassengerDetailsController extends GetxController {
  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<BookedUserModel> bookingUserModel = BookedUserModel().obs;
  RxBool isLoading = true.obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      bookingUserModel.value = argumentData['bookingUserModel'];
    }
    await getReview();
    isLoading.value = false;
  }

  double calculateAmount() {
    RxString taxAmount = "0.0".obs;
    if (bookingUserModel.value.taxList != null) {
      for (var element in bookingUserModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) + Constant().calculateTax(amount: bookingUserModel.value.subTotal.toString(), taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(bookingUserModel.value.subTotal.toString())) + double.parse(taxAmount.value);
  }

  Rx<ReviewModel> reviewModel = ReviewModel().obs;

  getReview() async {
    print("${bookingModel.value.id}-${bookingUserModel.value.id}");
    await FireStoreUtils.getReview("${bookingModel.value.id}-${bookingUserModel.value.id}").then((value) {
      if (value != null) {
        reviewModel.value = value;
      }
    });
    print("========>========>");

  }
}
