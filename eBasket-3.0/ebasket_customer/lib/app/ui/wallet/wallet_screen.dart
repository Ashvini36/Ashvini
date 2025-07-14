import 'package:ebasket_customer/app/controller/wallet_controller.dart';
import 'package:ebasket_customer/app/model/wallet_transaction_model.dart';
import 'package:ebasket_customer/app/ui/order_details_screen/order_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/payment/createRazorPayOrderModel.dart';
import 'package:ebasket_customer/payment/rozorpayConroller.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<WalletController>(
        init: WalletController(),
        builder: (controller) {
          return Scaffold(
            appBar: CommonUI.customAppBar(
              context,
              title: Text("Wallet".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              isBack: true,
              onBackTap: () {
                Get.back();
              },
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue.withOpacity(0.50), borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "Total Amount".tr,
                                style: TextStyle(fontSize: 12, fontFamily: AppThemeData.medium, color: AppThemeData.groceryAppDarkBlue),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                Constant.amountShow(amount: controller.userModel.value.walletAmount),
                                style: TextStyle(fontSize: 32, fontFamily: AppThemeData.bold, color: AppThemeData.groceryAppDarkBlue),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              child: RoundedButtonFill(
                                title: "Add Amount".tr,
                                color: AppThemeData.groceryAppDarkBlue,
                                icon: const Icon(Icons.add, color: AppThemeData.white),
                                isRight: false,
                                onPress: () {
                                  paymentMethodDialog(context, controller, themeChange);
                                },
                              ),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: controller.transactionList.isEmpty
                              ? Constant.showEmptyView(message: "Transaction not found".tr)
                              : ListView.builder(
                                  padding: const EdgeInsets.only(top: 20),
                                  itemCount: controller.transactionList.length,
                                  itemBuilder: (context, index) {
                                    WalletTransactionModel walletTractionModel = controller.transactionList[index];
                                    return transactionCard(controller, themeChange, walletTractionModel);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  paymentMethodDialog(BuildContext context, WalletController controller, themeChange) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: StatefulBuilder(builder: (context1, setState) {
                return Obx(
                  () => Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: AppThemeData.grey04,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Container(
                                    width: 134,
                                    height: 5,
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: ShapeDecoration(
                                      color: AppThemeData.groceryAppDarkBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Add Money to Wallet'.tr,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: AppThemeData.medium,
                                          color: AppThemeData.grey10,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: AppThemeData.grey10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFieldWidget(
                            title: 'Enter Amount'.tr,
                            onPress: () {},
                            controller: controller.amountController.value,
                            hintText: 'Enter Amount'.tr,
                            textInputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],
                            prefix: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(Constant.currencyModel!.symbol.toString(), style: const TextStyle(fontSize: 20, color: AppThemeData.grey08)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppThemeData.groceryAppDarkBlue,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Minimum amount will be a ${Constant.amountShow(amount: Constant.minimumAmountToDeposit.toString())}".tr,
                                style: TextStyle(fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.groceryAppDarkBlue),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
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
                                  visible: controller.paymentModel.value.mercadoPago != null && controller.paymentModel.value.mercadoPago!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.mercadoPago!.name.toString(), themeChange, "assets/images/mercadopogo.png"),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.flutterWave != null && controller.paymentModel.value.flutterWave!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.flutterWave!.name.toString(), themeChange, "assets/images/flutterwave.png"),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.payfast != null && controller.paymentModel.value.payfast!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.payfast!.name.toString(), themeChange, "assets/images/payfast.png"),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.razorpay!.name.toString(), themeChange, "assets/images/rezorpay.png"),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.xendit != null && controller.paymentModel.value.xendit!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.xendit!.name.toString(), themeChange, "assets/images/xendit.png"),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.orangePay != null && controller.paymentModel.value.orangePay!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.orangePay!.name.toString(), themeChange, "assets/images/orangeMoney.png"),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.midtrans != null && controller.paymentModel.value.midtrans!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.midtrans!.name.toString(), themeChange, "assets/images/midtrans.png"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: Container(
                      color: AppThemeData.colorLightWhite,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RoundedButtonFill(
                          title: "Topup".tr,
                          height: 5.5,
                          color: AppThemeData.groceryAppDarkBlue,
                          fontSizes: 16,
                          onPress: () {
                            if (controller.amountController.value.text.isNotEmpty) {
                              Get.back();
                              if (double.parse(controller.amountController.value.text) >= double.parse(Constant.minimumAmountToDeposit.toString())) {
                                //  ShowToastDialog.showLoader("Please wait".tr);
                                if (controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name) {
                                  controller.stripeMakePayment(amount: controller.amountController.value.text);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name) {
                                  // controller.paypalPayment(controller.amountController.value.text);
                                  controller.paypalPaymentSheet(controller.amountController.value.text,context);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name) {
                                  controller.payStackPayment(controller.amountController.value.text);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.mercadoPago!.name) {
                                  controller.mercadoPagoMakePayment(context: context, amount: controller.amountController.value.text);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.flutterWave!.name) {
                                  controller.flutterWaveInitiatePayment(context: context, amount: controller.amountController.value.text);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payfast!.name) {
                                  controller.payFastPayment(context: context, amount: controller.amountController.value.text);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.xendit!.name) {
                                  controller.xenditPayment(context, double.parse(controller.amountController.value.text));
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.orangePay!.name) {
                                  controller.orangeMakePayment(amount: controller.amountController.value.text.toString(), context: context);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.midtrans!.name) {
                                  controller.midtransMakePayment(amount: controller.amountController.value.text.toString(), context: context);
                                } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name) {
                                  RazorPayController()
                                      .createOrderRazorPay(amount: int.parse(controller.amountController.value.text), razorpayModel: controller.paymentModel.value.razorpay)
                                      .then((value) {
                                    if (value == null) {
                                      Get.back();
                                      ShowToastDialog.showToast("Something went wrong, please contact admin.".tr);
                                    } else {
                                      CreateRazorPayOrderModel result = value;
                                      controller.openCheckout(amount: controller.amountController.value.text, orderId: result.id);
                                    }
                                  });
                                } else {
                                  ShowToastDialog.showToast("Please select payment method".tr);
                                }
                              } else {
                                ShowToastDialog.showToast("Please Enter minimum amount of ${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}".tr);
                              }
                            } else {
                              ShowToastDialog.showToast("Please enter amount".tr);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ));
  }

  transactionCard(WalletController controller, themeChange, WalletTransactionModel transactionModel) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (!transactionModel.isCredit!) {
              Get.to(const OrderDetailsScreen(), arguments: {"orderId": transactionModel.orderId});
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SvgPicture.asset(
                  transactionModel.isCredit == true ? "assets/icons/ic_wallet_credit.svg" : "assets/icons/ic_wallet_debit.svg",
                  width: 52,
                  height: 52,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transactionModel.note.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: AppThemeData.assetColorGrey900,
                              ),
                            ),
                          ),
                          Text(
                            // Constant.amountShow(amount: transactionModel.amount.toString()),
                            transactionModel.isCredit == true
                                ? "${"+"} ${Constant.amountShow(amount: transactionModel.amount.toString().replaceAll('-', ''))}"
                                : "${"-"} ${Constant.amountShow(amount: transactionModel.amount.toString().replaceAll('-', ''))}",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppThemeData.bold,
                              color: transactionModel.isCredit == true ? AppThemeData.groceryAppDarkBlue : AppThemeData.colorRed,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              Constant.dateFormatTimestamp(transactionModel.createdDate!),
                              style: const TextStyle(fontSize: 12, fontFamily: AppThemeData.regular, color: AppThemeData.grey07),
                            ),
                          ),
                          Text(
                            transactionModel.paymentType.toString(),
                            style: const TextStyle(fontSize: 12, fontFamily: AppThemeData.regular, color: AppThemeData.colorGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1, color: AppThemeData.assetColorLightGrey1000),
      ],
    );
  }

  cardDecoration(WalletController controller, String value, themeChange, String image) {
    return Obx(
      () => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              controller.selectedPaymentMethod.value = value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: AppThemeData.grey04, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Image.asset(
                        image,
                        width: 60,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14, fontFamily: AppThemeData.bold, color: AppThemeData.grey10),
                    ),
                  ),
                  Radio(
                    value: value.toString(),
                    groupValue: controller.selectedPaymentMethod.value,
                    activeColor: AppThemeData.groceryAppDarkBlue,
                    onChanged: (value) {
                      controller.selectedPaymentMethod.value = value.toString();
                    },
                  )
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, color: AppThemeData.grey04),
        ],
      ),
    );
  }
}
