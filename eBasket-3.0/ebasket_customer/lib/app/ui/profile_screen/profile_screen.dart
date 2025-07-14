import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/profile_controller.dart';
import 'package:ebasket_customer/app/ui/order_screen/order_screen.dart';
import 'package:ebasket_customer/app/ui/profile_screen/edit_profile_screen.dart';
import 'package:ebasket_customer/app/ui/termsAndCondition/terms_and_codition.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.white,
          appBar: CommonUI.customAppBar(context,
              title: Text("My Profile".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
          body: controller.isLoading.value
              ? Constant.loader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: controller.userModel.value.id != null,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  (controller.userModel.value.image!.isNotEmpty)
                                      ? Container(
                                          width: Responsive.width(25, context),
                                          height: Responsive.height(12, context),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(controller.userModel.value.image.toString()),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: const BorderRadius.all(Radius.circular(70.0)),
                                            border: Border.all(
                                              color: AppThemeData.groceryAppDarkBlue,
                                              width: 4.0,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: Responsive.width(25, context),
                                          height: Responsive.height(12, context),
                                          decoration: BoxDecoration(
                                            color: AppThemeData.groceryAppDarkBlue,
                                            // image: const DecorationImage(
                                            //   image: AssetImage("assets/icons/ic_logo.png"),
                                            //   fit: BoxFit.cover,
                                            // ),
                                            borderRadius: const BorderRadius.all(Radius.circular(70.0)),
                                            border: Border.all(
                                              color: AppThemeData.groceryAppDarkBlue,
                                              width: 4.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Image.asset(
                                              "assets/icons/ic_logo.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.userModel.value.fullName.toString().tr,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
                                        ),
                                        if (controller.userModel.value.email.toString().isNotEmpty)
                                          const SizedBox(
                                            height: 4,
                                          ),
                                        if (controller.userModel.value.email.toString().isNotEmpty)
                                          Text(
                                            controller.userModel.value.email.toString().tr,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                                          ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          controller.userModel.value.countryCode.toString() + controller.userModel.value.phoneNumber.toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (controller.userModel.value.id != null) {
                                Get.to(const EditProfileScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                                  controller.getData();
                                });
                              } else {
                                Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                              }
                            },
                            child: profileView(title: "Edit Profile".tr, image: "assets/icons/ic_edit_profile.svg")),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () {
                              if (controller.userModel.value.id != null) {
                                Get.to(const MyOrderListScreen(), transition: Transition.rightToLeftWithFade);
                              } else {
                                Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                              }
                            },
                            child: profileView(title: "My Orders".tr, image: "assets/icons/ic_my_orders.svg")),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(const TermsAndCondition(
                                type: "refund",
                              ));
                            },
                            child: profileView(title: "Refund Policy".tr, image: "assets/icons/ic_refund_policy.svg")),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(const TermsAndCondition(
                                type: "privacy",
                              ));
                            },
                            child: profileView(title: "Privacy Policy", image: "assets/icons/ic_privacy_policy.svg")),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(const TermsAndCondition(
                                type: "terms",
                              ));
                            },
                            child: profileView(title: "Terms & Conditions", image: "assets/icons/ic_terms_condition.svg")),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget profileView({required String title, image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image,
                  width: 54,
                  height: 54,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppThemeData.black,
                      fontSize: 14,
                      fontFamily: AppThemeData.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset("assets/icons/ic_right.svg"),
        ],
      ),
    );
  }
}
