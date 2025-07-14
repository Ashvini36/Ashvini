import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
import 'package:ebasket_customer/app/ui/signup_screen/signup_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/notification_service.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class OtpVerificationController extends GetxController {
  Rx<TextEditingController> pinController = TextEditingController().obs;
  Rx<UserModel> user = UserModel().obs;
  RxString verificationId = "".obs;
  RxBool isLoading = true.obs;
  RxInt resendToken = 0.obs;
  RxString countryCode = "".obs;
  RxString mobileNumber = "".obs;
  RxBool fromSignup = false.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      if (argumentData['user'] != null) {
        user.value = argumentData['user'];
      }
      countryCode.value = argumentData['countryCode'];
      mobileNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
      fromSignup.value = argumentData['fromSignup'];
    }
    isLoading.value = false;
    update();
  }

  void submitCode() async {
    ShowToastDialog.showLoader("Verify OTP".tr);

    auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: pinController.value.text);
    String fcmToken = await NotificationService.getToken();
    await auth.FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      if (!value.additionalUserInfo!.isNewUser) {
        FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
          if (userExit == true) {
            ShowToastDialog.closeLoader();

            UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);

            if (userModel!.active == true) {
              userModel.fcmToken = await NotificationService.getToken();
              await FireStoreUtils.updateCurrentUser(userModel);
              Constant.currentUser = userModel;
              Get.offAll(const DashBoardScreen());
            } else {
              await auth.FirebaseAuth.instance.signOut();
              ShowToastDialog.showToast("This user is disable please contact administrator".tr);
            }
          } else {
            ShowToastDialog.closeLoader();
            Get.offAll(const SignupScreen(), transition: Transition.rightToLeftWithFade, arguments: {
              "countryCode": countryCode.value,
              "phoneNumber": mobileNumber.value,
              "fromOTP": true,
              "userCredentials": value,
            });
          }
        });
      } else if (fromSignup.value) {
        UserModel userModel = UserModel(
            fullName: user.value.fullName,
            countryCode: user.value.countryCode,
            phoneNumber: user.value.phoneNumber,
            email: user.value.email,
            fcmToken: fcmToken,
            role: Constant.USER_ROLE_CUSTOMER,
            shippingAddress: user.value.shippingAddress,
            id: value.user?.uid ?? '',
            active: true,
            createdAt: Timestamp.now());
        String? errorMessage = await FireStoreUtils.firebaseCreateNewUser(userModel);

        if (errorMessage == null) {
          Constant.currentUser = userModel;

          Get.offAll(const DashBoardScreen());
          ShowToastDialog.closeLoader();
        } else {
          return 'Couldn\'t create new user with phone number.'.tr;
        }
      } else {
        ShowToastDialog.closeLoader();
        Get.offAll(const SignupScreen(), transition: Transition.rightToLeftWithFade, arguments: {
          "countryCode": countryCode.value,
          "phoneNumber": mobileNumber.value,
          "fromOTP": true,
          "userCredentials": value,
        });
      }
    }).catchError((error) {
      print(error.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Invalid code".tr);
    });
  }

  Future<bool> sendOTP() async {
    //ShowToastDialog.showLoader("Please Wait".tr);
    await auth.FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCode.toString() + mobileNumber.toString(),
      verificationCompleted: (auth.PhoneAuthCredential credential) {
        // ShowToastDialog.closeLoader();
      },
      verificationFailed: (auth.FirebaseAuthException e) {
        // ShowToastDialog.closeLoader();
      },
      codeSent: (String verificationId0, int? resendToken0) async {
        // ShowToastDialog.closeLoader();
        verificationId.value = verificationId0;
        resendToken.value = resendToken0!;
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: resendToken.value,
      codeAutoRetrievalTimeout: (String verificationId0) {
        // ShowToastDialog.closeLoader();
        verificationId0 = verificationId.value;
      },
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple Time Request".tr);
    });

    return true;
  }
}
