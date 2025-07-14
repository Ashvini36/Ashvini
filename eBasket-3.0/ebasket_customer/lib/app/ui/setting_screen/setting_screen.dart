import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/ui/choose_language/choose_language_screen.dart';
import 'package:ebasket_customer/app/ui/wallet/wallet_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/ui/termsAndCondition/terms_and_codition.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:ebasket_customer/app/ui/notification_screen/notification_screen.dart';
import 'package:ebasket_customer/app/ui/profile_screen/profile_screen.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData.white,
      appBar: CommonUI.customAppBar(
        context,
        title: Text("Settings".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
        isBack: true,
        onBackTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Get.to(const ProfileScreen(), transition: Transition.rightToLeftWithFade);
                  },
                  child: settingView(
                    title: "My Profile".tr,
                    image: "assets/icons/ic_my_profile.svg",
                  )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    if (Constant.currentUser.id != null) {
                      Get.to(const WalletScreen(), transition: Transition.rightToLeftWithFade);
                    } else {
                      Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                    }
                  },
                  child: settingView(
                    title: "My Wallet".tr,
                    image: "assets/icons/ic_wallet_settings.svg",
                  )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Get.to(const ChooseLanguageScreen(), transition: Transition.rightToLeftWithFade);
                  },
                  child: settingView(
                    title: "Language".tr,
                    image: "assets/icons/ic_translate.svg",
                  )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Get.to(const TermsAndCondition(
                      type: "support",
                    ));
                  },
                  child: settingView(
                    title: "Help".tr,
                    image: "assets/icons/ic_support.svg",
                  )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Get.to(const NotificationScreen(), transition: Transition.rightToLeftWithFade);
                  },
                  child: settingView(title: "Notification".tr, image: "assets/icons/ic_notification.svg")),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () async {
                    ShowToastDialog.showLoader("Please wait".tr);
                    share();
                  },
                  child: settingView(title: "Share the App".tr, image: "assets/icons/ic_share.svg")),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Get.to(const TermsAndCondition(
                      type: "aboutUs",
                    ));
                  },
                  child: settingView(title: "About Us".tr, image: "assets/icons/ic_about_us.svg")),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    if (Constant.currentUser.id == null) {
                      Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                    } else {
                      logoutBottomSheet(context);
                    }
                  },
                  child: settingView(title: Constant.currentUser.id == null ? "Login" : "Logout".tr, image: "assets/icons/ic_logout.svg")),
            ],
          ),
        ),
      ),
    );
  }

  logoutBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: Get.height * 0.30,
            decoration: const BoxDecoration(
              color: AppThemeData.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'Logout'.tr,
                      style: TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 24, color: AppThemeData.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Are you sure you want to Logout?".tr,
                          maxLines: 2, style: TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppThemeData.white,
                              padding: const EdgeInsets.all(8),
                              side: BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 2),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'No'.tr,
                                style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppThemeData.groceryAppDarkBlue,
                              padding: const EdgeInsets.all(8),
                              side: BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 0.4),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Provider.of<CartDatabase>(context, listen: false).deleteAllProducts();
                              await FirebaseAuth.instance.signOut();
                              Constant.currentUser = UserModel();
                              Constant.selectedPosition = AddressModel();
                              Get.to(const LoginScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'Yes'.tr,
                                style: const TextStyle(color: AppThemeData.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget settingView({required String title, image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image,
                  width: 32,
                  height: 32,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
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

  Future<void> share() async {
    ShowToastDialog.closeLoader();

    await Share.share(
       'eBasket Customer'.tr,
      subject:  'https://app.eBasket.com',
    );
  }
}
