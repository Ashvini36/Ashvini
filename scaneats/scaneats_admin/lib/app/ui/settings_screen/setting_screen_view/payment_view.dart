import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/payment_view_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: PaymentViewController(),
        builder: (controller) {
          return ContainerCustom(
            child: controller.isLoading.value
                ? Constant.loader(context)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: controller.cashName.value,
                        fontSize: 18,
                        fontFamily: AppThemeData.bold,
                      ),
                      spaceH(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.enableCash.value,
                                title: 'STATUS',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.enableCash.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.enableCash.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                          const Expanded(child: SizedBox())
                        ],
                      ),
                      Divider(
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                      ),
                      spaceH(),
                      TextCustom(
                        title: controller.cardName.value,
                        fontSize: 18,
                        fontFamily: AppThemeData.bold,
                      ),
                      spaceH(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.enableCard.value,
                                title: 'STATUS',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.enableCard.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.enableCard.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                          const Expanded(child: SizedBox())
                        ],
                      ),
                      Divider(
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                      ),

                      spaceH(),
                      TextCustom(
                        title: controller.razorPay.value,
                        fontSize: 18,
                        fontFamily: AppThemeData.bold,
                      ),
                      spaceH(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.razorpayKey.value, title: 'RazorPay Key',obscureText: Constant.isDemo())),
                          spaceW(width: 20),
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.enableRazorPay.value,
                                title: 'STATUS',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.enableRazorPay.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.enableRazorPay.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                        ],
                      ),
                      spaceH(),
                      Divider(
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                      ),
                      spaceH(),
                      TextCustom(
                        title: controller.payStack.value,
                        fontSize: 18,
                        fontFamily: AppThemeData.bold,
                      ),
                      spaceH(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.payStackPublicKey.value, title: 'PayStack Public key',obscureText: Constant.isDemo())),
                          spaceW(width: 20),
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.payStackSecretKey.value, title: 'PayStack secrete key',obscureText: Constant.isDemo())),
                        ],
                      ),
                      spaceH(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.enablePayStack.value,
                                title: 'STATUS',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.enablePayStack.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.enablePayStack.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                          Expanded(child: spaceW(width: 20)),
                        ],
                      ),
                      spaceH(),
                      Divider(
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                      ),
                      spaceH(),
                      TextCustom(
                        title: controller.stripName.value,
                        fontSize: 18,
                        fontFamily: AppThemeData.bold,
                      ),
                      spaceH(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.stripSecretKey.value, title: 'Stripe Secret Key',obscureText: Constant.isDemo())),
                          spaceW(width: 20),
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.enableStripe.value,
                                title: 'Status',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.enableStripe.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.enableStripe.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                        ],
                      ),
                      Divider(
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                      ),
                      spaceH(),
                      TextCustom(
                        title: controller.payPalName.value,
                        fontSize: 18,
                        fontFamily: AppThemeData.bold,
                      ),
                      spaceH(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.paypalSecret.value, title: 'PayPal Secret Key',obscureText: Constant.isDemo())),
                          spaceW(width: 20),
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.paypalClient.value, title: 'PayPal Client Key',obscureText: Constant.isDemo())),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.enablePaypal.value,
                                title: 'Status',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.enablePaypal.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.enablePaypal.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                          spaceW(width: 20),
                          Expanded(
                            flex: 1,
                            child: customRadioButton(context,
                                parameter: controller.isSandboxPaypal.value,
                                title: 'Sandbox',
                                radioOne: "Active",
                                onChangeOne: () {
                                  controller.isSandboxPaypal.value = "Active";
                                  controller.update();
                                },
                                radioTwo: "Inactive",
                                onChangeTwo: () {
                                  controller.isSandboxPaypal.value = "Inactive";
                                  controller.update();
                                }),
                          ),
                        ],
                      ),
                      RoundedButtonFill(
                        width: 100,
                        radius: 8,
                        height: 40,
                        fontSizes: 14,
                        title: "Save",
                        icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                        color: AppThemeData.crusta500,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () {
                          if (Constant.isDemo()) {
                            ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                          } else {
                            controller.addCompanyData();
                          }
                        },
                      ),
                    ],
                  ),
          );
        });
  }
}
