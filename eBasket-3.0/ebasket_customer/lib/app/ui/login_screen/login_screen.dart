import 'package:ebasket_customer/app/ui/location_permission_screen/location_permission_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_customer/app/ui/signup_screen/signup_screen.dart';
import 'package:ebasket_customer/widgets/mobile_number_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/login_controller.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:provider/provider.dart';

import '../dashboard_screen/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: LoginController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
           Get.back();
           return true;
          },
          child: Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: AppBar(
              title: Text("Login".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              backgroundColor: AppThemeData.white,
              automaticallyImplyLeading: false,
              elevation: 0,
              titleSpacing: 0,
              centerTitle: true,
              surfaceTintColor: AppThemeData.white,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Form(
                key: controller.formKey.value,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/login_image.svg"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Welcome Back to eBasket".tr, style: TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Log in to access exclusive deals and a personalized shopping experience.".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: AppThemeData.assetColorGrey600, fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: MobileNumberTextField(
                          title: "Enter Mobile Number *".tr,
                          read: false,
                          controller: controller.mobileNumberController.value,
                          countryCodeController: controller.countryCode.value,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validation: (value) {
                            String pattern = r'(^\+?[0-9]*$)';
                            RegExp regExp = RegExp(pattern);
                            if (value!.isEmpty) {
                              return 'Mobile Number is required'.tr;
                            } else if (!regExp.hasMatch(value)) {
                              return 'Mobile Number must be digits'.tr;
                            }
                            return null;
                          },
                          onPress: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: RoundedButtonGradiant(
                          title: "Continue".tr,
                          icon: true,
                          onPress: () {
                            if (controller.formKey.value.currentState!.validate()) {
                              controller.sendCode();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: "${'Not a member ?'.tr} ",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: AppThemeData.medium,
                              color: AppThemeData.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(const SignupScreen());
                                  },
                                text: 'Signup'.tr,
                                style: TextStyle(
                                  color: AppThemeData.groceryAppDarkBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  fontFamily: AppThemeData.medium,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: RoundedButtonGradiant(
                          width: Responsive.width(5, context),
                          title: "Skip".tr,
                          onPress: () async {
                            LocationPermission permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                              if (Constant.currentUser.shippingAddress == null) {
                                Get.to(LocationPermissionScreen(), transition: Transition.rightToLeftWithFade);
                              } else {
                                Get.offAll(const DashBoardScreen());
                              }
                            } else {
                              Get.to(LocationPermissionScreen(), transition: Transition.rightToLeftWithFade);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
