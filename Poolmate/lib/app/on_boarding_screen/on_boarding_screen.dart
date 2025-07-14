import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poolmate/app/on_boarding_screen/get_started_screen.dart';
import 'package:poolmate/controller/on_boarding_controller.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/themes/round_button_fill.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:poolmate/utils/network_image_widget.dart';
import 'package:poolmate/utils/preferences.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading.value
              ? Constant.loader()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: NetworkImageWidget(
                          imageUrl: controller.onBoardingList[controller.selectedPageIndex.value].image.toString(),
                          width: 300,
                          height: 300,
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                            controller: controller.pageController,
                            onPageChanged: controller.selectedPageIndex.call,
                            itemCount: controller.onBoardingList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.onBoardingList[index].title.toString().tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                        fontSize: 28,
                                        fontFamily: AppThemeData.bold,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      controller.onBoardingList[index].description.toString().tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppThemeData.grey700,
                                        fontSize: 16,
                                        fontFamily: AppThemeData.regular,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.onBoardingList.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: controller.selectedPageIndex.value == index ? 38 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: controller.selectedPageIndex.value == index
                                  ? themeChange.getThem()
                                      ? AppThemeData.primary300
                                      : AppThemeData.primary300
                                  : AppThemeData.primary50,
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          controller.selectedPageIndex.value == 2
                              ? const SizedBox()
                              : Expanded(
                                  child: RoundedButtonFill(
                                    title: "Skip".tr,
                                    color: AppThemeData.grey200,
                                    textColor: AppThemeData.grey800,
                                    onPress: () {
                                      if (controller.selectedPageIndex.value == 2) {
                                        Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                        Get.offAll(const GetStartedScreen());
                                      } else {
                                        controller.pageController.jumpToPage(controller.selectedPageIndex.value + 1);
                                      }
                                    },
                                  ),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RoundedButtonFill(
                              title: controller.selectedPageIndex.value == 2 ? "Get Started".tr : "Next".tr,
                              color: AppThemeData.primary300,
                              textColor: AppThemeData.grey50,
                              onPress: () {
                                if (controller.selectedPageIndex.value == 2) {
                                  Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                  Get.offAll(const GetStartedScreen());
                                } else {
                                  controller.pageController.jumpToPage(controller.selectedPageIndex.value + 1);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
