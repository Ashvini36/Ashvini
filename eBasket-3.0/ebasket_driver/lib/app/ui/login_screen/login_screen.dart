import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_driver/app/controller/login_controller.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/widgets/round_button_gradiant.dart';
import 'package:ebasket_driver/widgets/text_field_widget.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.white,
          appBar: AppBar(
            title: const Text("Login",
                style: TextStyle(
                    color: AppThemeData.black,
                    fontFamily: AppThemeData.semiBold,
                    fontSize: 20)),
            backgroundColor: AppThemeData.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
            centerTitle: true,
            surfaceTintColor: AppThemeData.white,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: controller.formKey.value,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFieldWidget(
                              controller: controller.userIdController.value,
                              textInputType: TextInputType.text,
                              hintText: "Email",
                              title: "Enter Email *",
                              // inputFormatters: [
                              //   LengthLimitingTextInputFormatter(10),
                              // ],
                              validation: (value) {
                                String pattern = r'(^\+?[0-9]*$)';
                                RegExp regExp = RegExp(pattern);
                                if (value!.isEmpty) {
                                  return 'Email is required'.tr;
                                }
                                return null;
                              },
                              prefix: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                    "assets/icons/ic_user.svg",
                                    height: 22,
                                    width: 22),
                              ),
                            ),
                            TextFieldWidget(
                              controller: controller.passwordController.value,
                              hintText: "Password".tr,
                              title: "Enter Password *".tr,
                              obscureText: !controller.passwordVisible.value,
                              suffix: InkWell(
                                  onTap: () {
                                    controller.passwordVisible.value =
                                        !controller.passwordVisible.value;
                                    controller.update();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                        controller.passwordVisible.value
                                            ? "assets/icons/ic_visibility_on.png"
                                            : "assets/icons/ic_visibility_off.png",
                                        height:  24,
                                        width:  24),
                                  )),
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is empty'.tr;
                                }
                                return null;
                              },
                              prefix: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset(
                                    "assets/icons/ic_password.svg",
                                    height: 22,
                                    width: 22),
                              ),
                            ),
                            TextFieldWidget(
                              controller:
                                  controller.confirmPasswordController.value,
                              hintText: "Confirm Password".tr,
                              title: "Enter Confirm Password *".tr,
                              obscureText:
                                  !controller.confirmPasswordVisible.value,
                              suffix: InkWell(
                                  onTap: () {
                                    controller.confirmPasswordVisible.value =
                                        !controller
                                            .confirmPasswordVisible.value;
                                    controller.update();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                        controller.confirmPasswordVisible.value
                                            ? "assets/icons/ic_visibility_on.png"
                                            : "assets/icons/ic_visibility_off.png",
                                        height:  24,
                                        width:  24),
                                  )),
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return 'Confirm Password is empty'.tr;
                                } else if (value !=
                                    controller.passwordController.value.text) {
                                  return 'Password does not match.';
                                }
                                return null;
                              },
                              prefix: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset(
                                    "assets/icons/ic_password.svg",
                                    height: 22,
                                    width: 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20,top: 20),
                    child: RoundedButtonGradiant(
                      title: "Continue",
                      icon: true,
                      onPress: () {
                        if (controller.formKey.value.currentState!.validate()) {
                          controller.loginUser();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
