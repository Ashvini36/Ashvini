import 'dart:convert';

import 'package:ebasket_customer/app/controller/language_controller.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/localization_service.dart';
import 'package:ebasket_customer/services/preferences.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LanguageController>(
      init: LanguageController(),
      builder: (controller) {
        return Scaffold(
          appBar: CommonUI.customAppBar(context,
              title:  Text("Choose language".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
          body: controller.isLoading.value
              ? Constant.loader()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: controller.languageList.length,
                        itemBuilder: (context, int index) {
                          return Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.languageList[index].name.toString(),
                                    style: const TextStyle(fontSize: 16, fontFamily: AppThemeData.medium, color: AppThemeData.grey10),
                                  ),
                                  Radio(
                                      value: controller.languageList[index],
                                      groupValue: controller.selectedLanguage.value,
                                      activeColor: AppThemeData.groceryAppDarkBlue,
                                      onChanged: (value) {
                                        controller.selectedLanguage.value = controller.languageList[index];
                                      })
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            color:AppThemeData.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RoundedButtonFill(
                title: "Save".tr,
                color: AppThemeData.groceryAppDarkBlue,
                onPress: () {
                  LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                  Preferences.setString(Preferences.languageCodeKey, jsonEncode(controller.selectedLanguage.value));
                  Get.back(result: true);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
