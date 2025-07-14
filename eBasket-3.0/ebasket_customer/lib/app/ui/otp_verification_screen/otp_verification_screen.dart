import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/otp_verification_controller.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OtpVerificationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title:  Text(
                  "OTP Verification".tr,
                  style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20),
                ),
                isBack: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/login_image.svg"),
                    const SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text(
                        "Enter Verification Code".tr,
                        style: const TextStyle(color: AppThemeData.black, fontSize: 20, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "We have sent sms to:".tr,
                            style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${controller.countryCode.toString()}××××××××××",
                            style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: Pinput(
                        keyboardType: TextInputType.number,
                        length: 6,
                        controller: controller.pinController.value,
                       // androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                        defaultPinTheme: PinTheme(
                          width: 46,
                          height: 46,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: AppThemeData.assetColorGrey600,
                          ),
                          decoration:
                              BoxDecoration(color: AppThemeData.colorLightWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppThemeData.groceryAppDarkBlue)),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 46,
                          height: 46,
                          decoration:
                              BoxDecoration(color: AppThemeData.colorLightWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppThemeData.groceryAppDarkBlue)),
                        ),
                        separatorBuilder: (index) => const SizedBox(width: 8),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    InkWell(
                      onTap: () {
                        controller.pinController.value.clear();
                        controller.sendOTP();
                      },
                      child: Center(
                        child: Text(
                          "Resend OTP".tr,
                          style: const TextStyle(
                            height: 1.2,
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppThemeData.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: RoundedButtonGradiant(
                        title: "Continue".tr,
                        icon: true,
                        onPress: () {
                          if (controller.pinController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter otp".tr);
                          } else {
                            if (controller.pinController.value.text.length == 6) {
                              controller.submitCode();
                              // Get.to(const ProfileReadySuccessfullyScreen());
                            } else {
                              ShowToastDialog.showToast("Enter valid otp".tr);
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
