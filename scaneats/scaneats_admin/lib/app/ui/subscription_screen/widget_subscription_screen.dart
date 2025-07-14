import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/subscription_controller.dart';
import 'package:scaneats/app/model/day_model.dart';
import 'package:scaneats/app/model/subscription_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/payment/paypal/Model/accesstokenmodel.dart';
import 'package:scaneats/payment/paypal/Model/paymentmodel.dart';
import 'package:scaneats/payment/paypal/paypalservice.dart';
import 'package:scaneats/payment/paystack/paystack.dart';
import 'package:scaneats/payment/razorpay/razorpay.dart';
import 'package:scaneats/payment/stripe/stripe_service.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_widget.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionController(),
        builder: (controller) {
          return Padding(
            padding: paddingEdgeInsets(vertical: 10),
            child: controller.isItemLoading.value
                ? Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.restaurantModel.value.subscription == null
                          ? const SizedBox()
                          : Responsive.isMobile(context)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: ContainerCustom(
                                    radius: 10,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(
                                          title: '${controller.restaurantModel.value.subscription!.planName}',
                                          fontSize: 18,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        ),
                                        spaceH(height: 4),
                                        TextCustom(
                                          title: 'Renews ${Constant.timestampToDateAndTime(controller.restaurantModel.value.subscribed!.endDate!)}',
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood500,
                                        ),
                                        spaceH(),
                                        controller.subscriptionTransactionList.isNotEmpty
                                            ? RoundedButtonFill(
                                                isRight: true,
                                                width: 160,
                                                radius: 40,
                                                height: 40,
                                                fontSizes: 14,
                                                title: "View Transaction",
                                                color: AppThemeData.crusta500,
                                                textColor: AppThemeData.pickledBluewood50,
                                                onPress: () {
                                                  showDialog(context: context, builder: (ctxt) => const SubscriptionTransactionDialog());
                                                })
                                            : const SizedBox(),
                                        spaceH(),
                                        RoundedButtonFill(
                                            isRight: true,
                                            width: 180,
                                            radius: 40,
                                            height: 40,
                                            fontSizes: 14,
                                            title: "Cancel Subscription",
                                            color: AppThemeData.crusta800,
                                            textColor: AppThemeData.pickledBluewood50,
                                            onPress: () async {
                                              ShowToastDialog.showLoader("Please wait.");
                                              controller.restaurantModel.value.subscription = null;
                                              controller.restaurantModel.value.subscribed = null;
                                              await FireStoreUtils.setRestaurant(model: controller.restaurantModel.value).then((value) {
                                                ShowToastDialog.closeLoader();
                                                Get.back();
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                )
                              : ContainerCustom(
                                radius: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_subscriptionImage.svg",
                                      height: 60,
                                      width: 60,
                                    ),
                                    spaceW(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: '${controller.restaurantModel.value.subscription!.planName}',
                                            fontSize: 18,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                          ),
                                          spaceH(height: 4),
                                          TextCustom(
                                            title: 'Renews ${Constant.timestampToDateAndTime(controller.restaurantModel.value.subscribed!.endDate!)}',
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    controller.subscriptionTransactionList.isNotEmpty
                                        ? RoundedButtonFill(
                                            isRight: true,
                                            width: 160,
                                            radius: 40,
                                            height: 40,
                                            fontSizes: 14,
                                            title: "View Transaction",
                                            color: AppThemeData.crusta500,
                                            textColor: AppThemeData.pickledBluewood50,
                                            onPress: () {
                                              showDialog(context: context, builder: (ctxt) => const SubscriptionTransactionDialog());
                                            })
                                        : const SizedBox(),
                                    spaceW(),
                                    RoundedButtonFill(
                                        isRight: true,
                                        width: 180,
                                        radius: 40,
                                        height: 40,
                                        fontSizes: 14,
                                        title: "Cancel Subscription",
                                        color: AppThemeData.crusta800,
                                        textColor: AppThemeData.pickledBluewood50,
                                        onPress: () async {
                                          ShowToastDialog.showLoader("Please wait.");
                                          controller.restaurantModel.value.subscription = null;
                                          controller.restaurantModel.value.subscribed = null;
                                          await FireStoreUtils.setRestaurant(model: controller.restaurantModel.value).then((value) {
                                            ShowToastDialog.closeLoader();
                                            Get.back();
                                          });
                                        })
                                  ],
                                ),
                              ),
                      spaceH(height: 20),
                      SizedBox(
                        height: 600,
                        child: controller.subscriptionList.isEmpty
                            ? SizedBox(
                                width: Responsive.width(100, context),
                                height: Responsive.height(90, context),
                                child: Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value, isNotFound: controller.subscriptionList.isEmpty))
                            : ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: controller.subscriptionList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  SubscriptionModel model = controller.subscriptionList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: SizedBox(
                                      width: 360,
                                      child: ContainerCustom(
                                        radius: 10,
                                        borderColor: AppThemeData.pickledBluewood300,
                                        padding: EdgeInsets.zero,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2),
                                              child: SizedBox(
                                                height: 4,
                                                child: ContainerCustom(
                                                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Constant.checkCurrentPlanName(model, controller.restaurantModel.value) == false ||
                                                          Constant.checkCurrentPlanActive(controller.restaurantModel.value.subscribed!) == false
                                                      ? const SizedBox()
                                                      : Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: RoundedButtonFill(
                                                            icon: const SizedBox(),
                                                            radius: 20,
                                                            height: 30,
                                                            width: 80,
                                                            title: "Active".tr,
                                                            fontSizes: 14,
                                                            color: AppThemeData.forestGreen,
                                                            textColor: AppThemeData.white,
                                                            isRight: false,
                                                            onPress: () async {},
                                                          ),
                                                        ),
                                                  TextCustom(
                                                    title: model.planName ?? '',
                                                    fontSize: 20,
                                                    color: AppThemeData.crusta500,
                                                  ),
                                                  const TextCustom(
                                                    title: 'Best for personal use',
                                                    fontSize: 14,
                                                    color: AppThemeData.pickledBluewood700,
                                                  ),
                                                  spaceH(height: 4),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                                    child: Constant.enableSubscriptionList(model)!.first.strikePrice!.isEmpty ||
                                                            Constant.enableSubscriptionList(model)!.first.strikePrice == "0" ||
                                                            model.planName == "Trial"
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              TextCustom(
                                                                title: Constant.amountOwnerShow(
                                                                    amount: model.planName == "Trial" ? "0" : Constant.enableSubscriptionList(model)!.first.planPrice.toString()),
                                                                fontSize: 24,
                                                                fontFamily: AppThemeData.bold,
                                                              ),
                                                              TextCustom(
                                                                title:
                                                                    ' / ${model.planName == "Trial" ? "${Constant.enableSubscriptionList(model)!.first.planPrice} days" : Constant.durationName(Constant.enableSubscriptionList(model)!.first)}',
                                                                fontSize: 16,
                                                                fontFamily: AppThemeData.bold,
                                                                color: AppThemeData.pickledBluewood500,
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  TextCustom(
                                                                    title: Constant.amountOwnerShow(
                                                                        amount:
                                                                            model.planName == "Trial" ? "0" : Constant.enableSubscriptionList(model)!.first.strikePrice.toString()),
                                                                    fontSize: 24,
                                                                    fontFamily: AppThemeData.bold,
                                                                  ),
                                                                  TextCustom(
                                                                    title:
                                                                        ' / ${model.planName == "Trial" ? "${Constant.enableSubscriptionList(model)!.first.planPrice} days" : Constant.durationName(Constant.enableSubscriptionList(model)!.first)}',
                                                                    fontSize: 16,
                                                                    fontFamily: AppThemeData.bold,
                                                                    color: AppThemeData.pickledBluewood500,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  TextCustom(
                                                                    title: Constant.amountOwnerShow(
                                                                        amount:
                                                                            model.planName == "Trial" ? "0" : Constant.enableSubscriptionList(model)!.first.planPrice.toString()),
                                                                    fontSize: 14,
                                                                    fontFamily: AppThemeData.bold,
                                                                    islineThrough: true,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_check.svg",
                                                            colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: TextCustom(
                                                              title: 'Number of Items Access to manage up to ${model.noOfItem} items within your inventory!',
                                                              fontSize: 14,
                                                              fontFamily: AppThemeData.regular,
                                                              maxLine: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_check.svg",
                                                            colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: TextCustom(
                                                              title: 'Number of Branches Capability to oversee operations across ${model.noOfBranch} branches or locations.',
                                                              fontSize: 14,
                                                              fontFamily: AppThemeData.regular,
                                                              maxLine: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_check.svg",
                                                            colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: TextCustom(
                                                              title:
                                                                  'Number of Employees Ability to assign roles and responsibilities to ${model.noOfEmployee} employees within your organization.',
                                                              fontSize: 14,
                                                              fontFamily: AppThemeData.regular,
                                                              maxLine: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_check.svg",
                                                            colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: TextCustom(
                                                              title: 'Number of Orders Track and process orders efficiently ${model.noOfOrders} orders placed.',
                                                              fontSize: 14,
                                                              fontFamily: AppThemeData.regular,
                                                              maxLine: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_check.svg",
                                                            colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: TextCustom(
                                                              title: 'Admin Accounts You can create up to ${model.noOfAdmin} admin accounts to manage your system.',
                                                              fontSize: 14,
                                                              fontFamily: AppThemeData.regular,
                                                              maxLine: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_check.svg",
                                                            colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: TextCustom(
                                                              title:
                                                                  'Tables per Branch Each branch can accommodate up to ${model.noOfTablePerBranch} tables for efficient organization',
                                                              fontSize: 14,
                                                              fontFamily: AppThemeData.regular,
                                                              maxLine: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                                child: Constant.checkCurrentPlanName(model, controller.restaurantModel.value) == false
                                                    ? RoundedButtonFill(
                                                        icon: const SizedBox(),
                                                        radius: 10,
                                                        height: 40,
                                                        width: Responsive.height(100, context),
                                                        title: "Buy".tr,
                                                        fontSizes: 16,
                                                        color: AppThemeData.crusta500,
                                                        textColor: AppThemeData.white,
                                                        isRight: false,
                                                        onPress: () async {
                                                          if (model.planName == "Trial") {
                                                            if (controller.restaurantModel.value.isTrail == true) {
                                                              ShowToastDialog.showToast("Your trial is already subscribed, you can't subscribe it multiple times.");
                                                            } else {
                                                              controller.selectedDuration.value = model.durations!.first;
                                                              controller.setSubscription(dayModel:controller.selectedDuration.value,subscriptionModel: model,paymentType: "Free" );
                                                            }
                                                          } else {
                                                            controller.reset();
                                                            controller.selectedDuration.value = model.durations!.first;
                                                            showDialog(context: context, builder: (ctxt) => SubscriptionDialog(subscriptionModel: model));
                                                          }
                                                        },
                                                      )
                                                    : RoundedButtonFill(
                                                        icon: const SizedBox(),
                                                        radius: 10,
                                                        height: 40,
                                                        width: Responsive.height(100, context),
                                                        title: "Renew".tr,
                                                        fontSizes: 16,
                                                        borderColor: AppThemeData.crusta500,
                                                        textColor: AppThemeData.crusta500,
                                                        isRight: false,
                                                        onPress: () async {
                                                          if (model.planName == "Trial") {
                                                            if (controller.restaurantModel.value.isTrail == true) {
                                                              ShowToastDialog.showToast("Your trial is already subscribed, you can't subscribe it multiple times.");
                                                            } else {
                                                              controller.selectedDuration.value = model.durations!.first;
                                                              controller.setSubscription(dayModel:controller.selectedDuration.value,subscriptionModel: model,paymentType: "Free" );
                                                            }
                                                          } else {
                                                            controller.reset();
                                                            controller.selectedDuration.value = model.durations!.first;
                                                            showDialog(context: context, builder: (ctxt) => SubscriptionDialog(subscriptionModel: model));
                                                          }
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          );
        });
  }
}

class SubscriptionDialog extends StatelessWidget {
  final SubscriptionModel subscriptionModel;

  const SubscriptionDialog({super.key, required this.subscriptionModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: SubscriptionController(),
      builder: (controller) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          title: TextCustom(title: '${subscriptionModel.planName}', fontSize: 18),
          content: SizedBox(
            width: 800,
            child: SizedBox(
              height: 160,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Constant.enableSubscriptionList(subscriptionModel)!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DayModel model = Constant.enableSubscriptionList(subscriptionModel)![index];
                  return InkWell(
                    onTap: () {
                      controller.selectedDuration.value = model;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 200,
                        child: Obx(
                          () => ContainerCustom(
                            radius: 10,
                            borderColor: controller.selectedDuration.value.name == model.name ? AppThemeData.crusta500 : AppThemeData.pickledBluewood300,
                            padding: EdgeInsets.zero,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: SizedBox(
                                    height: 4,
                                    child: ContainerCustom(
                                      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            controller.selectedDuration.value.name == model.name
                                                ? Icon(Icons.radio_button_checked, color: AppThemeData.crusta500, size: 18)
                                                : Icon(Icons.circle_outlined,
                                                    color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood950, size: 18),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: TextCustom(
                                                title: model.name.toString(),
                                                fontSize: 16,
                                                fontFamily: AppThemeData.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: model.strikePrice == null || model.strikePrice.toString() == "0" || model.strikePrice!.isEmpty
                                              ? Center(
                                                  child: TextCustom(
                                                    title: Constant.amountOwnerShow(amount: model.planPrice.toString()),
                                                    fontSize: 18,
                                                    fontFamily: AppThemeData.bold,
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      TextCustom(
                                                        title: Constant.amountOwnerShow(amount: model.strikePrice.toString()),
                                                        fontSize: 18,
                                                        fontFamily: AppThemeData.bold,
                                                      ),
                                                      TextCustom(
                                                        title: Constant.amountOwnerShow(amount: model.planPrice.toString()),
                                                        fontSize: 12,
                                                        fontFamily: AppThemeData.bold,
                                                        islineThrough: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextCustom(
                                  title:
                                      "Plan renews at\n${Constant.timestampToDate(Timestamp.fromDate(DateTime.now().add(Duration(days: Constant.dayCalculationOfSubscription(model)))))}",
                                  fontSize: 14,
                                  fontFamily: AppThemeData.medium,
                                ),
                                const SizedBox(
                                  height: 14,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
              width: 100,
              radius: 8,
              height: 40,
              fontSizes: 14,
              title: "Subscribe",
              icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
              color: AppThemeData.crusta500,
              textColor: AppThemeData.white,
              isRight: false,
              onPress: () async {
                if (controller.selectedDuration.value.name == null) {
                  ShowToastDialog.showToast("Please select plan duration.");
                } else {
                  showDialog(context: context, builder: (ctxt) => PaymentDialog(dayModel: controller.selectedDuration.value,subscriptionModel: subscriptionModel,));
                  // controller.setSubscription(subscriptionModel);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class SubscriptionTransactionDialog extends StatelessWidget {
  const SubscriptionTransactionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: SubscriptionController(),
      builder: (controller) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          title: const TextCustom(title: 'Subscription Transaction', fontSize: 18),
          content: SizedBox(
            width: 1200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: DataTable(
                    horizontalMargin: 20,
                    columnSpacing: 30,
                    dataRowMaxHeight: 70,
                    border: TableBorder.all(
                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                    columns: const [
                      DataColumn(
                        label: SizedBox(
                          width: 200,
                          child: TextCustom(title: 'Subscription Plan'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 140,
                          child: TextCustom(title: 'Price'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 160,
                          child: TextCustom(title: 'Plan Duration'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 160,
                          child: TextCustom(title: 'Payment Type'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 240,
                          child: TextCustom(title: 'Purchase Date'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 240,
                          child: TextCustom(title: 'Renew Date'),
                        ),
                      ),
                    ],
                    rows: controller.subscriptionTransactionList
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                TextCustom(
                                  title: e.subscription!.planName.toString(),
                                ),
                              ),
                              DataCell(
                                TextCustom(
                                  title: Constant.amountOwnerShow(amount: e.durations!.planPrice.toString()),
                                ),
                              ),
                              DataCell(
                                TextCustom(
                                  title: Constant.durationName(e.durations!),
                                ),
                              ),
                              DataCell(
                                TextCustom(
                                  title: e.paymentType.toString(),
                                ),
                              ),
                              DataCell(
                                TextCustom(
                                  title: Constant.timestampToDateAndTime(e.startDate!),
                                ),
                              ),
                              DataCell(
                                TextCustom(
                                  title: Constant.timestampToDateAndTime(e.endDate!),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList()),
              ),
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
          ],
        );
      },
    );
  }
}

class PaymentDialog extends StatelessWidget {
  final SubscriptionModel subscriptionModel;
  final DayModel dayModel;

  const PaymentDialog({super.key, required this.subscriptionModel, required this.dayModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: SubscriptionController(),
      builder: (controller) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          title: const TextCustom(title: 'Payment', fontSize: 18),
          content: SizedBox(
            width: 500,
            child: Column(
              children: [
                Visibility(
                  visible: controller.paymentModel.value.strip != null && controller.paymentModel.value.strip!.enable == true,
                  child: cardDecoration(controller, controller.paymentModel.value.strip!.name.toString(), themeChange, "assets/images/strip.png"),
                ),
                Visibility(
                  visible: controller.paymentModel.value.paypal != null && controller.paymentModel.value.paypal!.enable == true,
                  child: cardDecoration(controller, controller.paymentModel.value.paypal!.name.toString(), themeChange, "assets/images/paypal.png"),
                ),
                Visibility(
                  visible: controller.paymentModel.value.payStack != null && controller.paymentModel.value.payStack!.enable == true,
                  child: cardDecoration(controller, controller.paymentModel.value.payStack!.name.toString(), themeChange, "assets/images/paystack.png"),
                ),
                Visibility(
                  visible: controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.enable == true,
                  child: cardDecoration(controller, controller.paymentModel.value.razorpay!.name.toString(), themeChange, "assets/images/rezorpay.png"),
                ),
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
              width: 100,
              radius: 8,
              height: 40,
              fontSizes: 14,
              title: "Subscribe",
              icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
              color: AppThemeData.crusta500,
              textColor: AppThemeData.white,
              isRight: false,
              onPress: () async {
                await Constant.setSubscription(subscriptionModel, dayModel, controller.selectedPaymentMethod.value);
                if (controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name) {
                  StripeService.createPrice(secretKey: controller.paymentModel.value.strip!.stripeSecret.toString(), amount: controller.selectedDuration.value.planPrice.toString())
                      .then((value) {
                    if (value != '') {
                      StripeService.makeStripeCheckoutCall(priceId: value, secretKey: controller.paymentModel.value.strip!.stripeSecret.toString()).then((value) {
                        if (value != '') {
                          StripeService.handlePayPalPayment(context, approvalUrl: value);
                        }
                      });
                    }
                  });
                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name) {
                  FlutterPaypalSDK sdk = FlutterPaypalSDK(
                      paypalClient: controller.paymentModel.value.paypal!.paypalClient.toString(),
                      paypalSecret: controller.paymentModel.value.paypal!.paypalSecret.toString(),
                      isSendBox: true,
                      amount: controller.selectedDuration.value.planPrice.toString());
                  AccessToken accessToken = await sdk.getAccessToken();
                  if (accessToken.token != null) {
                    Payment payment = await sdk.createPayment(sdk.transaction(), accessToken.token!);
                    if (payment.status) {
                      sdk.handlePayPalPayment(context, payment: payment);
                    }
                  }
                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name) {
                  Get.to(PayStackPage(
                    publicKey: controller.paymentModel.value.payStack!.publicKey.toString(),
                    secretKey: controller.paymentModel.value.payStack!.secretKey.toString(),
                    amount: controller.selectedDuration.value.planPrice.toString(),
                  ));
                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name) {
                  RazorPayService().init();
                  RazorPayService()
                      .openCheckout(amount: controller.selectedDuration.value.planPrice.toString(), key: controller.paymentModel.value.razorpay!.razorpayKey.toString());
                }
              },
            ),
          ],
        );
      },
    );
  }

  cardDecoration(SubscriptionController controller, String value, themeChange, String image) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () {
              controller.selectedPaymentMethod.value = value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Image.asset(
                    image,
                    width: 80,
                    height: 36,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextCustom(
                      title: value,
                    ),
                  ),
                  Radio(
                    value: value.toString(),
                    groupValue: controller.selectedPaymentMethod.value,
                    activeColor: themeChange.getThem() ? AppThemeData.crusta500 : AppThemeData.crusta500,
                    onChanged: (value) {
                      controller.selectedPaymentMethod.value = value.toString();
                    },
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
          )
        ],
      ),
    );
  }
}
