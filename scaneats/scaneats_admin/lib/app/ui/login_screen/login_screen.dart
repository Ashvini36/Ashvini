import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/login_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: GetX(
          init: LoginController(),
          builder: (controller) {
            return Align(
                alignment: kIsWeb ? Alignment.topCenter : Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        spaceH(height: 30),
                        SizedBox(
                          width: 400,
                          child: ContainerCustom(
                              padding: paddingEdgeInsets(horizontal: 32, vertical: 20),
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    spaceH(height: 10),
                                    kIsWeb
                                        ? NetworkImageWidget(
                                            imageUrl: Constant.projectLogo,
                                            placeHolderUrl: Constant.placeholderURL,
                                            fit: BoxFit.fill,
                                            height: 100,
                                            width: 180,
                                          )
                                        : const SizedBox(),
                                    spaceH(height: 40),
                                    TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                    spaceH(height: 30),
                                    kIsWeb
                                        ? const SizedBox()
                                        : TextFieldWidget(
                                            hintText: '',
                                            controller: controller.slugController.value,
                                            title: 'Website Slug (Private Key)',
                                          ),
                                    TextFieldWidget(
                                      hintText: '',
                                      controller: controller.emailController.value,
                                      title: 'Email',
                                      onSubmitted: (value) async {
                                        if (kIsWeb) {
                                          controller.login();
                                        } else {
                                          await controller.loginForMobile();
                                        }
                                      },
                                    ),
                                    TextFieldWidget(
                                      hintText: '',
                                      controller: controller.passwordController.value,
                                      title: 'Password',
                                      obscureText: !controller.isPasswordVisible.value,
                                      onSubmitted: (value) async {
                                        if (kIsWeb) {
                                          controller.login();
                                        } else {
                                          await controller.loginForMobile();
                                        }
                                      },
                                      suffix: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                        ),
                                        onPressed: () {
                                          controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(context: context, builder: (ctxt) => const ForgotPasswordDialog());
                                          },
                                          child: const TextCustom(
                                            title: 'Forget Password',
                                            color: AppThemeData.blue,
                                            fontFamily: AppThemeData.semiBold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    spaceH(height: 40),
                                    RoundedButtonFill(
                                      icon: controller.isLoading.value ? Constant.loader(context, color: AppThemeData.pickledBluewood50) : const SizedBox(),
                                      radius: 20,
                                      height: 45,
                                      title: " Login ".tr,
                                      fontSizes: 17,
                                      color: AppThemeData.blue,
                                      textColor: AppThemeData.white,
                                      isRight: false,
                                      onPress: () async {
                                        if (kIsWeb) {
                                          controller.login();
                                        } else {
                                          await controller.loginForMobile();
                                        }
                                      },
                                    ),
                                    spaceH(height: 30),
                                  ],
                                ),
                              )),
                        ),
                        spaceH(height: 20),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LoginController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Forgot Password', fontSize: 18),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 1,
                    child: ContainerCustom(
                      color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood50,
                    ),
                  ),
                  spaceH(),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: TextFieldWidget(hintText: '', controller: controller.forgotPasswordController.value, title: 'Email address')),
                    spaceW(width: 20),
                  ]),
                ],
              ),
            ),
            actions: <Widget>[
              RoundedButtonFill(
                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Close",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    Get.back();
                  }),
              RoundedButtonFill(
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Save",
                  icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                  color: AppThemeData.crusta500,
                  textColor: AppThemeData.white,
                  isRight: false,
                  onPress: () async {
                    if (Constant.isDemo()) {
                      ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                    } else {
                      if (controller.forgotPasswordController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please Enter Email");
                      } else {
                        ShowToastDialog.showLoader("Please wait.");
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: controller.forgotPasswordController.value.text.trim()).then((value) {
                            Get.back();
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("Please check ${controller.forgotPasswordController.value.text.trim()} email. password reset link sent.");
                          });
                        } on FirebaseAuthException catch (e) {
                          ShowToastDialog.closeLoader();
                          ShowToastDialog.showToast(e.message);
                        }
                      }
                    }
                  }),
            ],
          );
        });
  }
}
