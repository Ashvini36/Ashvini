import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:poolmate/app/accessibility/accessibility_screen.dart';
import 'package:poolmate/app/add_vehicle/vehicle_list_screen.dart';
import 'package:poolmate/app/edit_profile/edit_profile_screen.dart';
import 'package:poolmate/app/on_boarding_screen/get_started_screen.dart';
import 'package:poolmate/app/travel_preference/travel_preference_screen.dart';
import 'package:poolmate/app/verification_screen/verification_screen.dart';
import 'package:poolmate/app/withdraw_payment_setup_screen/payment_setup_screen.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/controller/profile_controller.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/themes/custom_dialog_box.dart';
import 'package:poolmate/themes/responsive.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:poolmate/utils/network_image_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
           backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Text(
                "Profile".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: NetworkImageWidget(
                              fit: BoxFit.cover,
                              imageUrl: controller.userModel.value.profilePic.toString(),
                              height: Responsive.width(24, context),
                              width: Responsive.width(24, context),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${controller.userModel.value.fullName()}",
                            style: TextStyle(fontSize: 20, fontFamily: AppThemeData.medium, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const EditProfileScreen())!.then((value) {
                                if (value == true) {
                                  controller.getData();
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Edit Profile".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.bold,
                                      color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppThemeData.primary300),
                                ),
                                 Icon(
                                  Icons.chevron_right,
                                  color: AppThemeData.primary300,
                                  fill: 1,
                                  size: 22,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),

                          menuItemWidget(
                            onTap: () {
                              Get.to(const VerificationScreen());
                            },
                            title: "Account Verification".tr,
                            subTitle: 'Verify your account and update the documents'.tr,
                            svgImage: "assets/icons/ic_account_setting.svg",
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            onTap: () {
                              Get.to(const PaymentSetupScreen());
                            },
                            title: "Withdraw Methods".tr,
                            subTitle: 'Manage your transaction via bank account details'.tr,
                            svgImage: "assets/icons/ic_bank_account.svg",
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            onTap: () {
                              Get.to(const VehicleListScreen());
                            },
                            title: "Vehicles".tr,
                            subTitle: 'Manage your traveling vehicle'.tr,
                            svgImage: "assets/icons/ic_car.svg",
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            onTap: () {
                              Get.to(const TravelPreferenceScreen());
                            },
                            title: "Travel Preference".tr,
                            subTitle: 'Discover Your Ideal Travel Destination Based on Personal Preferences'.tr,
                            svgImage: "assets/icons/ic_wallet.svg",
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            onTap: () {
                              Get.to(const AccessibilityScreen());
                            },
                            title: "Accessibility".tr,
                            subTitle: 'Language, mode change and more'.tr,
                            svgImage: "assets/icons/ic_settings.svg",
                            themeChange: themeChange,
                          ),
                          InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                      title: "Log out".tr,
                                      descriptions: "You will be signed out of the app. Tap Log Out to confirm.".tr,
                                      positiveString: "Log out".tr,
                                      negativeString: "Cancel".tr,
                                      positiveClick: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Get.offAll(const GetStartedScreen());
                                      },
                                      negativeClick: () {
                                        Get.back();
                                      },
                                      img: Image.asset('assets/images/ic_logout_dialog.png',height: 40,width: 40,),
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                      color: themeChange.getThem() ? AppThemeData.warning50 : AppThemeData.warning50, borderRadius: const BorderRadius.all(Radius.circular(30))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_logout.svg',
                                      color: themeChange.getThem() ? AppThemeData.warning300 : AppThemeData.warning300,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Log out".tr,
                                  style: TextStyle(fontSize: 16, fontFamily: AppThemeData.bold, color: themeChange.getThem() ? AppThemeData.warning300 : AppThemeData.warning300),
                                ),
                              ],
                            ),
                          )
                          // menuItemWidget(
                          //   onTap: () {},
                          //   title: "Account Verification",
                          //   subTitle: 'Verify your account and update the documents',
                          //   svgImage: "assets/icons/ic_account_setting.svg",
                          //   themeChange: themeChange,
                          // ),
                          // menuItemWidget(
                          //   onTap: () {},
                          //   title: "Ride Statics",
                          //   subTitle: 'Ratting, reviews and more',
                          //   svgImage: "assets/icons/ic_account_setting.svg",
                          //   themeChange: themeChange,
                          // ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  Widget menuItemWidget({
    required String svgImage,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
    required themeChange,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, borderRadius: const BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: SvgPicture.asset(
                    svgImage,
                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontFamily: AppThemeData.bold, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800),
                    ),
                    Text(
                      subTitle,
                      maxLines: 2,
                      style: TextStyle(fontSize: 12, fontFamily: AppThemeData.regular, color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppThemeData.grey500,
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Divider(),
        ),
      ],
    );
  }
}
