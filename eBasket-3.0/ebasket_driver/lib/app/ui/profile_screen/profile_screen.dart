import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_driver/app/controller/profile_controller.dart';
import 'package:ebasket_driver/app/ui/login_screen/login_screen.dart';
import 'package:ebasket_driver/app/ui/profile_screen/edit_profile_screen.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/theme/responsive.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:get/get.dart';

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
              title:  Text("My Profile".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
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
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: Responsive.height(14, context),
                                      height: Responsive.height(14, context),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                                        border: Border.all(
                                          color: AppThemeData.groceryAppDarkBlue,
                                          width: 4.0,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: controller.userModel.value.profilePictureURL.toString(),
                                          fit: BoxFit.cover,
                                          height: Responsive.width(14, context),
                                          width: Responsive.width(14, context),
                                          placeholder: (context, url) => Constant.loader(),
                                          errorWidget: (context, url, error) => Image.network(Constant.placeHolder,    fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ClipOval(
                                  //   child: Container(
                                  //     width: Responsive.height(14, context),
                                  //     height: Responsive.height(14, context),
                                  //     decoration: BoxDecoration(
                                  //       image: DecorationImage(
                                  //         image: NetworkImage(
                                  //           controller.userModel.value
                                  //                           .profilePictureURL
                                  //                           .toString() !=
                                  //                       "null" &&
                                  //                   controller.userModel.value
                                  //                       .profilePictureURL
                                  //                       .toString()
                                  //                       .isNotEmpty
                                  //               ? controller.userModel.value
                                  //                   .profilePictureURL
                                  //                   .toString()
                                  //               : "https://firebasestorage.googleapis.com/v0/b/gbest-2519a.appspot.com/o/user-placeholder.jpeg?alt=media&token=82247f0a-5a56-4321-98ea-decd5437f51e",
                                  //         ),
                                  //         fit: BoxFit.cover,
                                  //       ),
                                  //       borderRadius: const BorderRadius.all(
                                  //           Radius.circular(80.0)),
                                  //       border: Border.all(
                                  //         color: AppThemeData.groceryAppDarkBlue,
                                  //         width: 4.0,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Positioned(
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_circle.svg",
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                controller.userModel.value.name.toString().tr,
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: AppThemeData.black, fontSize: 20, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                controller.userModel.value.email.toString().tr,
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: AppThemeData.black, fontSize: 16, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                controller.userModel.value.countryCode.toString() + controller.userModel.value.phoneNumber.toString(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: AppThemeData.black, fontSize: 16, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(const EditProfileScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                                controller.getData();
                              });
                            },
                            child: profileView(title: "Edit Profile", image: "assets/icons/ic_edit_profile.svg")),
                        InkWell(
                            onTap: () {
                              logoutBottomSheet(context);
                            },
                            child: profileView(title: "Logout", image: "assets/icons/ic_logout.svg")),
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
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Logout'.tr,
                      style: const TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 24, color: AppThemeData.black),
                    ),
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Are you sure you want to Logout?".tr,
                          maxLines: 2, style: const TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
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
                              side: const BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 2),
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
                                style: const TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
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
                              side: const BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 0.4),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.offAll(const LoginScreen());
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
}
