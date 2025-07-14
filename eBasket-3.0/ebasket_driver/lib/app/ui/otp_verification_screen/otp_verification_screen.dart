import 'package:flutter/material.dart';
import 'package:ebasket_driver/app/controller/otp_verification_controller.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:ebasket_driver/widgets/round_button_fill.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: OtpVerificationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title:  Text(
                  "OTP Verification".tr,
                  style: const TextStyle(
                      color: AppThemeData.black,
                      fontFamily: AppThemeData.semiBold,
                      fontSize: 20),
                ),
                isBack: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text(
                      "Enter Code".tr,
                      style: const TextStyle(
                          color: AppThemeData.black,
                          fontSize: 20,
                          fontFamily: AppThemeData.medium,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  /*  const SizedBox(
                    height: 8,
                  ),
               Center(
                    child:
                    Column(
                      children: [
                        Text(
                          "We have sent sms to:".tr,
                          style: const TextStyle(
                              color: AppThemeData.black,
                              fontSize: 14,
                              fontFamily: AppThemeData.medium,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${controller.orderModel.value.user!.countryCode.toString()}××××××××××",
                          style: const TextStyle(
                              color: AppThemeData.black,
                              fontSize: 14,
                              fontFamily: AppThemeData.medium,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),*/
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Pinput(
                      keyboardType: TextInputType.number,
                      length: 6,
                      controller: controller.pinController.value,
                      //androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: AppThemeData.assetColorGrey600,
                        ),
                        decoration: BoxDecoration(
                            color: AppThemeData.colorLightWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppThemeData.groceryAppDarkBlue)),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                            color: AppThemeData.colorLightWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppThemeData.groceryAppDarkBlue)),
                      ),
                      separatorBuilder: (index) => const SizedBox(width: 8),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: RoundedButtonFill(
                title: "Submit".tr,
                color: AppThemeData.groceryAppDarkBlue,
                textColor: AppThemeData.white,
                fontFamily: AppThemeData.bold,
                onPress: () async {
                  controller.updateOrder();
                },
              ),
            ),
          );
        });
  }
}
