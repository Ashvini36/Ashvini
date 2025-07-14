import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/constant/send_notification.dart';
import 'package:poolmate/constant/show_toast_dialog.dart';
import 'package:poolmate/model/booking_model.dart';
import 'package:poolmate/model/user_model.dart';
import 'package:poolmate/model/wallet_transaction_model.dart';
import 'package:poolmate/utils/fire_store_utils.dart';

import '../constant/collection_name.dart';
import '../model/review_model.dart';

class BookedDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<BookedUserModel> bookingUserModel = BookedUserModel().obs;
  Rx<String> paymentType = "".obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<UserModel> publisherUserModel = UserModel().obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      bookingUserModel.value = argumentData['bookingUserModel'];
    }
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      userModel.value = value!;
    });
    FireStoreUtils.fireStore.collection(CollectionName.booking).doc(bookingModel.value.id).snapshots().listen(
      (event) {
        bookingModel.value = BookingModel.fromJson(event.data()!);
      },
    );
    await getUserData();
    await getReview();
    isLoading.value = false;
  }

  getReview() async {
    await FireStoreUtils.getReview("${bookingModel.value.id}-${userModel.value.id}").then((value) {
      if (value != null) {
        reviewModel.value = value;
      }
    });
  }
  getUserData() async {
    await FireStoreUtils.getUserProfile(bookingModel.value.createdBy.toString()).then((value) {
      publisherUserModel.value = value!;
    });
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

  paymentCompleted() async {
    ShowToastDialog.showLoader("Please wait..");
    bookingUserModel.value.paymentStatus = true;
    bookingUserModel.value.paymentType = paymentType.value;

    if(paymentType.value.toLowerCase() != "cash"){
      WalletTransactionModel transactionModel = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: calculateAmount().toString(),
          createdDate: Timestamp.now(),
          paymentType: paymentType.value,
          transactionId: bookingModel.value.id,
          isCredit: true,
          type: "publisher",
          userId: bookingModel.value.createdBy.toString(),
          note: "Amount credited for ${userModel.value.fullName()} ride");

      await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOtherUserWallet(amount: calculateAmount().toString(), id: bookingModel.value.createdBy.toString());
        }
      });
    }

    if(bookingUserModel.value.adminCommission != null && bookingUserModel.value.adminCommission!.enable == true){
      WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          id: Constant.getUuid(),
          amount:
          "-${Constant.calculateOrderAdminCommission(amount: double.parse(bookingUserModel.value.subTotal.toString()).toString(), adminCommission: bookingUserModel.value.adminCommission)}",
          createdDate: Timestamp.now(),
          paymentType: "wallet",
          isCredit: false,
          type: "publisher",
          transactionId: bookingModel.value.id,
          userId: bookingModel.value.createdBy.toString(),
          note: "Admin commission debited for  ${userModel.value.fullName()}");

      await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOtherUserWallet(
              amount: "-${Constant.calculateOrderAdminCommission(amount: bookingUserModel.value.subTotal.toString(), adminCommission: bookingUserModel.value.adminCommission)}",
              id: bookingModel.value.createdBy.toString());
        }
      });
    }


    await FireStoreUtils.setUserBooking(bookingModel.value, bookingUserModel.value);
    await SendNotification.sendOneNotification(type: Constant.payment_successful, token: publisherUserModel.value.fcmToken.toString(), payload: {});


    await FireStoreUtils.setBooking(bookingModel.value).then((value) {
      ShowToastDialog.closeLoader();
      Get.back(result: true);
    });
  }
}
