import 'dart:convert';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/login_conroller.dart';
import 'package:cabme/page/auth_screens/forgot_password.dart';
import 'package:cabme/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/widget/permission_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  static final _phoneController = TextEditingController();
  static final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginController(),
        initState: (state) async {
          try{
            PermissionStatus location = await Location().hasPermission();
            print("=========>");
            print(location);
            if(PermissionStatus.granted != location){
              showDialogPermission(context);
            }
          }on PlatformException catch (e) {
            ShowToastDialog.showToast("${e.message}");
          }
        },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login with Email".tr,
                        style: const TextStyle(letterSpacing: 0.60, fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                          width: 80,
                          child: Divider(
                            color: ConstantColors.yellow1,
                            thickness: 3,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Form(
                          key: _loginFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldThem.boxBuildTextField(
                                hintText: 'email'.tr,
                                controller: _phoneController,
                                textInputType: TextInputType.emailAddress,
                                contentPadding: EdgeInsets.zero,
                                validators: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'required'.tr;
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextFieldThem.boxBuildTextField(
                                  hintText: 'password'.tr,
                                  controller: _passwordController,
                                  textInputType: TextInputType.text,
                                  obscureText: false,
                                  contentPadding: EdgeInsets.zero,
                                  validators: (String? value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'required'.tr;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: ButtonThem.buildButton(
                                    context,
                                    title: 'log in'.tr,
                                    btnHeight: 50,
                                    btnColor: ConstantColors.primary,
                                    txtColor: Colors.white,
                                    onPress: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_loginFormKey.currentState!.validate()) {
                                        Map<String, String> bodyParams = {
                                          'email': _phoneController.text.trim(),
                                          'mdp': _passwordController.text,
                                          'user_cat': "customer",
                                        };
                                        await controller.loginAPI(bodyParams).then((value) {
                                          if (value != null) {
                                            if (value.success == "Success") {
                                              Preferences.setInt(Preferences.userId, int.parse(value.data!.id.toString()));
                                              Preferences.setString(Preferences.user, jsonEncode(value));
                                              _phoneController.clear();
                                              _passwordController.clear();
                                              Preferences.setBoolean(Preferences.isLogin, true);
                                              Get.offAll(DashBoard(), duration: const Duration(milliseconds: 400), transition: Transition.rightToLeft);
                                              // if (value.data!.photo == null || value.data!.photoPath.toString().isEmpty) {
                                              //   Get.to(() => AddProfilePhotoScreen());
                                              // } else {
                                              //
                                              // }
                                            } else {
                                              ShowToastDialog.showToast(value.error);
                                            }
                                          }
                                        });
                                      }
                                    },
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ForgotPasswordScreen(),
                                      duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                      transition: Transition.rightToLeft);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: Text(
                                      "forgot".tr,
                                      style: TextStyle(color: ConstantColors.primary, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: ButtonThem.buildBorderButton(
                                    context,
                                    title: 'Login With Phone Number'.tr,
                                    btnHeight: 50,
                                    btnColor: Colors.white,
                                    txtColor: ConstantColors.primary,
                                    onPress: () {
                                      FocusScope.of(context).unfocus();
                                      Get.to(MobileNumberScreen(isLogin: true),
                                          duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                          transition: Transition.rightToLeft);
                                    },
                                    btnBorderColor: ConstantColors.primary,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'You don’t have an account yet? '.tr,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(MobileNumberScreen(isLogin: false),
                                duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                transition: Transition.rightToLeft); //transition effect);
                          },
                      ),
                      TextSpan(
                        text: 'SIGNUP'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold, color: ConstantColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                                MobileNumberScreen(
                                  isLogin: false,
                                ),
                                duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                transition: Transition.rightToLeft); //transition effect);
                          },
                      ),
                    ],
                  ),
                )),
          ),
        );
      }
    );
  }

  showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }

}
