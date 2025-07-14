import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/controller/login_controller.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/network_image_widget.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

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
                          child: Column(
                            children: [
                              spaceH(height: 10),
                              kIsWeb
                                  ? NetworkImageWidget(
                                      imageUrl: Constant.projectLogo,
                                      fit: BoxFit.contain,
                                      height: 100,
                                      width: 200,
                                    )
                                  : const SizedBox(),
                              spaceH(height: 40),
                              TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                              spaceH(height: 30),
                              TextFieldWidget(
                                hintText: '',
                                controller: controller.emailController.value,
                                title: 'Email',
                                onSubmitted: (value) async {
                                  controller.login();
                                },
                              ),
                              TextFieldWidget(
                                hintText: '',
                                controller: controller.passwordController.value,
                                title: 'Password',
                                obscureText: !controller.isPasswordVisible.value,
                                onSubmitted: (value) async {
                                  controller.login();
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
                                  controller.login();
                                },
                              ),
                              spaceH(height: 30),
                            ],
                          )),
                    ),
                    spaceH(height: 20),
                    Constant.isDemo() == true
                        ? SizedBox(
                            width: 400,
                            child: ContainerCustom(
                                alignment: Alignment.topCenter,
                                padding: paddingEdgeInsets(horizontal: 10, vertical: 16),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const TextCustom(title: "For quick demo click below", fontSize: 18, fontFamily: AppThemeData.bold),
                                  spaceH(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(title: "Email : owner@scaneat.com", fontSize: 16, fontFamily: AppThemeData.medium),
                                            spaceH(),
                                            const TextCustom(title: "Password : 123456", fontSize: 16, fontFamily: AppThemeData.medium)
                                          ],
                                        ),
                                      ),
                                      RoundedButtonFill(
                                          width: 24,
                                          radius: 8,
                                          height: 24,
                                          title: "".tr,
                                          color: AppThemeData.white,
                                          textColor: AppThemeData.white,
                                          isRight: false,
                                          icon: Icon(
                                            Icons.copy,
                                            color: AppThemeData.crusta500,
                                          ),
                                          onPress: () {
                                            controller.emailController.value.text = 'owner@scaneat.com';
                                            controller.passwordController.value.text = '123456';
                                          }),
                                      spaceW(),
                                    ],
                                  ),
                                  spaceH(height: 20),
                                ])),
                          )
                        : const SizedBox()
                  ],
                ),
              ));
          // return Align(
          //   alignment: Alignment.topCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Column(
          //       children: [
          //         spaceH(height: 30),
          //         SizedBox(
          //           width: 400,
          //           child: ContainerCustom(
          //               padding: paddingEdgeInsets(horizontal: 32, vertical: 20),
          //               alignment: Alignment.topCenter,
          //               child: SingleChildScrollView(
          //                 child: Column(
          //                   children: [
          //                     spaceH(height: 10),
          //                     Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         NetworkImageWidget(imageUrl: Constant.projectLogo, height: 40, width: 40),
          //                         spaceW(width: 5),
          //                         TextCustom(title: Constant.projectName, color: AppThemeData.crusta500, fontSize: 24),
          //                       ],
          //                     ),
          //                     spaceH(height: 40),
          //                     TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
          //                     spaceH(height: 30),
          //                     TextFieldWidget(
          //                       hintText: '',
          //                       controller: controller.emailController.value,
          //                       title: 'Email',
          //                       onSubmitted: (value) async {
          //                         controller.login();
          //                       },
          //                     ),
          //                     spaceH(height: 20),
          //                     TextFieldWidget(
          //                       hintText: '',
          //                       controller: controller.passwordController.value,
          //                       title: 'Password',
          //                       obscureText: !controller.isPasswordVisible.value,
          //                       onSubmitted: (value) async {
          //                         controller.login();
          //                       },
          //                       suffix: IconButton(
          //                         icon: Icon(
          //                           controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
          //                           color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
          //                         ),
          //                         onPressed: () {
          //                           controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
          //                         },
          //                       ),
          //                     ),
          //                     spaceH(height: 40),
          //                     RoundedButtonFill(
          //                       icon: controller.isLoading.value ? Constant.loader(context, color: AppThemeData.pickledBluewood50) : const SizedBox(),
          //                       radius: 20,
          //                       height: 45,
          //                       title: " Login ".tr,
          //                       fontSizes: 17,
          //                       color: AppThemeData.blue,
          //                       textColor: AppThemeData.white,
          //                       isRight: false,
          //                       onPress: () {
          //                         controller.login();
          //                       },
          //                     ),
          //                     spaceH(height: 30),
          //                     // Constant.isDemo()
          //                     //     ? SizedBox(
          //                     //         width: 400,
          //                     //         child: ContainerCustom(
          //                     //             alignment: Alignment.topCenter,
          //                     //             padding: paddingEdgeInsets(horizontal: 16, vertical: 16),
          //                     //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //                     //               const TextCustom(title: "For quick demo click below", fontSize: 18, fontFamily: AppThemeData.bold),
          //                     //               spaceH(height: 20),
          //                     //               Expanded(
          //                     //                 child: RoundedButtonFill(
          //                     //                     width: 140,
          //                     //                     radius: 8,
          //                     //                     height: 45,
          //                     //                     title: "Owner".tr,
          //                     //                     color: AppThemeData.crusta500,
          //                     //                     textColor: AppThemeData.white,
          //                     //                     isRight: false,
          //                     //                     onPress: () {
          //                     //                       controller.emailController.value.text = 'owner@scaneat.com';
          //                     //                       controller.passwordController.value.text = '123456';
          //                     //                     }),
          //                     //               ),
          //                     //               spaceH(height: 20),
          //                     //             ])),
          //                     //       )
          //                     //     : const SizedBox()
          //                     SizedBox(
          //                       width: 400,
          //                       child: ContainerCustom(
          //                           alignment: Alignment.topCenter,
          //                           padding: paddingEdgeInsets(horizontal: 16, vertical: 16),
          //                           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //                             const TextCustom(title: "For quick demo click below", fontSize: 18, fontFamily: AppThemeData.bold),
          //                             spaceH(height: 20),
          //                             Expanded(
          //                               child: RoundedButtonFill(
          //                                   width: 140,
          //                                   radius: 8,
          //                                   height: 45,
          //                                   title: "Owner".tr,
          //                                   color: AppThemeData.crusta500,
          //                                   textColor: AppThemeData.white,
          //                                   isRight: false,
          //                                   onPress: () {
          //                                     controller.emailController.value.text = 'owner@scaneat.com';
          //                                     controller.passwordController.value.text = '123456';
          //                                   }),
          //                             ),
          //                             spaceH(height: 20),
          //                           ])),
          //                     )
          //                   ],
          //                 ),
          //               )),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
