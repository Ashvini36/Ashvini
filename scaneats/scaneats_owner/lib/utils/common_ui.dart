import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaneats_owner/app/controller/dash_board_controller.dart';
import 'package:scaneats_owner/app/model/language_model.dart';
import 'package:scaneats_owner/app/ui/login_screen/login_screen.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/service/localization_service.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/Preferences.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/network_image_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

PopupMenuItem iconButton({String? image, bool selected = false, required bool isDarkmode, dynamic model}) {
  return PopupMenuItem(
    height: 30,
    value: model,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(visible: image == null, child: selected ? const Icon(Icons.radio_button_checked_outlined, size: 20) : const Icon(Icons.circle_outlined, size: 20)),
        Visibility(visible: image != null, child: ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.asset(image ?? '', width: 20, height: 20))),
        const SizedBox(width: 10),
        Text(model.title ?? '', style: TextStyle(color: isDarkmode ? AppThemeData.white : AppThemeData.black)),
      ],
    ),
  );
}

class CommonUI {
  static AppBar appBarUI(BuildContext context, {Color? backgroundColor}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      backgroundColor: themeChange.getThem() ? backgroundColor ?? AppThemeData.black : backgroundColor ?? AppThemeData.white,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      centerTitle: false,
      titleSpacing: 16,
      title: SizedBox(
        child: GetBuilder<DashBoardController>(
            init: DashBoardController(),
            builder: (controller) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          controller.setThme(themeChange: themeChange);
                        },
                        child: themeChange.getThem()
                            ? const Icon(Icons.light_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500)
                            : const Icon(Icons.dark_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500)),
                    spaceW(width: 40),
                  ],
                ),
              );
            }),
      ),
      actions: [
        spaceW(width: 15),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: LanguagePopUp(),
        ),
        spaceW(width: 15),
        const ProfilePopUp(),
        spaceW(width: 15),
      ],
    );
  }

  static AppBar appBarMobileUI(BuildContext context, {Color? backgroundColor}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      backgroundColor: themeChange.getThem() ? backgroundColor ?? AppThemeData.black : backgroundColor ?? AppThemeData.white,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 100,
      actions: [
        spaceW(width: Responsive.isMobile(context) ? 10 : 15),
        GetBuilder(
            init: DashBoardController(),
            builder: (controller) {
              return GestureDetector(
                  onTap: () {
                    controller.setThme(themeChange: themeChange);
                  },
                  child: themeChange.getThem()
                      ? const Icon(Icons.light_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500)
                      : const Icon(Icons.dark_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500));
            }),
        spaceW(width: Responsive.isMobile(context) ? 10 : 15),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: LanguagePopUp(),
        ),
        spaceW(width: Responsive.isMobile(context) ? 10 : 15),
        const ProfilePopUp(),
        spaceW(width: 15),
      ],
    );
  }

  static Widget appMoblieUI(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    return const SizedBox();
  }
}

class ProfilePopUp extends StatelessWidget {
  const ProfilePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: DashBoardController(),
        builder: (controller) {
          return SizedBox(
            child: Row(
              children: [
                if (Responsive.isMobile(context)) spaceW(width: 16),
                ClipRRect(borderRadius: BorderRadius.circular(50), child: NetworkImageWidget(imageUrl: Constant.placeholderURL, height: 40, width: 40)),
                if (!Responsive.isMobile(context)) spaceW(),
                if (!Responsive.isMobile(context))
                  Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const TextCustom(title: 'Hello', fontSize: 12, fontFamily: AppThemeData.bold),
                    PopupMenuButton(
                        position: PopupMenuPosition.under,
                        child: SizedBox(
                          width: Responsive.isMobile(context) ? 120 : 140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: TextCustom(title: controller.ownerModel.value.name ?? '', fontSize: 15, fontFamily: AppThemeData.bold, maxLine: 1)),
                              SvgPicture.asset('assets/icons/down.svg',
                                  height: 20, width: 20, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                            ],
                          ),
                        ),
                        onSelected: (value) {
                          if (value == "Logout") {
                            Preferences.clearKeyData(Preferences.isLogin);
                            Preferences.clearKeyData(Preferences.order);
                            Get.offAll(const LoginScreen());
                          }
                        },
                        itemBuilder: (BuildContext bc) {
                          return ['Logout']
                              .map((e) => PopupMenuItem(
                                    height: 30,
                                    value: e,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(e, style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black, fontFamily: AppThemeData.medium)),
                                      ],
                                    ),
                                  ))
                              .toList();
                        }),
                  ]),
              ],
            ),
          );
        });
  }
}

class LanguagePopUp extends StatelessWidget {
  const LanguagePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          return ContainerBorderCustom(
            color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100,
            child: PopupMenuButton<LanguageModel>(
                position: PopupMenuPosition.under,
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(30), child: Image.network(controller.selectedLng.value.image ?? '', height: 25, width: 25, fit: BoxFit.cover)),
                      TextCustom(title: controller.selectedLng.value.name ?? '', fontSize: 15, fontFamily: AppThemeData.bold),
                      SvgPicture.asset(
                        'assets/icons/down.svg',
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100,
                      ),
                    ],
                  ),
                ),
                onSelected: (LanguageModel value) {
                  printLog("Select Language${value.name}");
                  controller.selectedLng.value = value;
                  LocalizationService().changeLocale(controller.selectedLng.value.code.toString());
                  Preferences.setString(Preferences.languageCodeKey, jsonEncode(controller.selectedLng.value));
                },
                itemBuilder: (BuildContext bc) {
                  return Constant.lngList
                      .map((LanguageModel e) => PopupMenuItem<LanguageModel>(
                            height: 30,
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                    visible: e.image != null,
                                    child: ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.network(e.image ?? '', width: 20, height: 20))),
                                const SizedBox(width: 10),
                                Text(e.name ?? '', style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black)),
                              ],
                            ),
                          ))
                      .toList();
                }),
          );
        });
  }
}
