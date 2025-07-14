import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/ui/otp_verification_screen/otp_verification_screen.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LoginController extends GetxController {
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCode =
      TextEditingController(text: "+91").obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  sendCode() async {
    ShowToastDialog.showLoader("Please Wait".tr);

    await auth.FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCode.value.text + mobileNumberController.value.text,
      verificationCompleted: (auth.PhoneAuthCredential credential) {},
      verificationFailed: (auth.FirebaseAuthException e) {
        debugPrint("FirebaseAuthException--->${e.message}");
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("Invalid Phone Number");
        } else {
          ShowToastDialog.showToast(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();

        Get.to(const OTPVerificationScreen(), arguments: {
          "countryCode": countryCode.value.text,
          "phoneNumber": mobileNumberController.value.text,
          "verificationId": verificationId,
          "fromSignup": false,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple Time Request".tr);
    });
  }
}
