import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/controller/razorpay_controller.dart';
import 'package:ebasket_customer/app/model/wallet_transaction_model.dart';
import 'package:ebasket_customer/payment/createRazorPayOrderModel.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/payment_options_controller.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';

class PaymentOptionsScreen extends StatelessWidget {
  const PaymentOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: PaymentOptionsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(
              context,
              title: Text("Bill Total : ${Constant.amountShow(amount: controller.totalAmount.value.toString())}".tr,
                  style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              isBack: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    controller.isLoading.value
                        ? Constant.loader()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: controller.paymentModel.value.cash != null && controller.paymentModel.value.cash!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.cash!.name.toString(), controller.paymentModel.value.cash!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.wallet != null && controller.paymentModel.value.wallet!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.wallet!.name.toString(), controller.paymentModel.value.wallet!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.strip != null && controller.paymentModel.value.strip!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.strip!.name.toString(), controller.paymentModel.value.strip!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.paypal != null && controller.paymentModel.value.paypal!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.paypal!.name.toString(), controller.paymentModel.value.paypal!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.payStack != null && controller.paymentModel.value.payStack!.enable == true,
                                  child:
                                      cardDecoration(controller, controller.paymentModel.value.payStack!.name.toString(), controller.paymentModel.value.payStack!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.mercadoPago != null && controller.paymentModel.value.mercadoPago!.enable == true,
                                  child: cardDecoration(
                                      controller, controller.paymentModel.value.mercadoPago!.name.toString(), controller.paymentModel.value.mercadoPago!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.flutterWave != null && controller.paymentModel.value.flutterWave!.enable == true,
                                  child: cardDecoration(
                                      controller, controller.paymentModel.value.flutterWave!.name.toString(), controller.paymentModel.value.flutterWave!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.payfast != null && controller.paymentModel.value.payfast!.enable == true,
                                  child:
                                      cardDecoration(controller, controller.paymentModel.value.payfast!.name.toString(), controller.paymentModel.value.payfast!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.enable == true,
                                  child:
                                      cardDecoration(controller, controller.paymentModel.value.razorpay!.name.toString(), controller.paymentModel.value.razorpay!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.xendit != null && controller.paymentModel.value.xendit!.enable == true,
                                  child: cardDecoration(controller, controller.paymentModel.value.xendit!.name.toString(), controller.paymentModel.value.xendit!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.orangePay != null && controller.paymentModel.value.orangePay!.enable == true,
                                  child: cardDecoration(
                                      controller, controller.paymentModel.value.orangePay!.name.toString(), controller.paymentModel.value.orangePay!.image.toString()),
                                ),
                                Visibility(
                                  visible: controller.paymentModel.value.midtrans != null && controller.paymentModel.value.midtrans!.enable == true,
                                  child:
                                      cardDecoration(controller, controller.paymentModel.value.midtrans!.name.toString(), controller.paymentModel.value.midtrans!.image.toString()),
                                ),
                              ],
                            ),
                          ),

                    // Visibility(
                    //   visible: controller.razorpayModel!.value.isEnabled != null &&  controller.razorpayModel!.value.isEnabled!,
                    //   child: InkWell(
                    //     onTap: () {
                    //       controller.selectedPaymentMethod.value = 'RazorPay';
                    //       confirmPaymentBottomSheet(context, controller.selectedPaymentMethod.value, controller);
                    //       // showLoadingDialog("Payment Processing");
                    //       // controller.razorpayPayment();
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         border: Border.all(color: controller.selectedPaymentMethod.value == 'RazorPay' ? AppThemeData.groceryAppDarkBlue : Colors.grey.shade100, width: 2),
                    //         color: AppThemeData.white,
                    //         boxShadow: const [
                    //           BoxShadow(
                    //             color: Color(0x19020202),
                    //             blurRadius: 5,
                    //             offset: Offset(0, 0),
                    //             spreadRadius: 0,
                    //           )
                    //         ],
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               height: 45,
                    //               width: 68,
                    //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade300)),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Image.asset(
                    //                   "assets/icons/razorpay.png",
                    //                   height: 45,
                    //                   width: 45,
                    //                   fit: BoxFit.contain,
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 20,
                    //             ),
                    //             const Expanded(
                    //               child: Text(
                    //                 "Razorpay",
                    //                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: AppThemeData.semiBold, color: AppThemeData.black),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Visibility(
                    //   visible: controller.codModel != null && controller.codModel!.value.isEnabled,
                    //   child: InkWell(
                    //     onTap: () {
                    //       controller.selectedPaymentMethod.value = 'Cash On Delivery';
                    //       confirmPaymentBottomSheet(context, controller.selectedPaymentMethod.value, controller);
                    //       // showLoadingDialog("Payment Processing");
                    //       // controller.orderPlaced();
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         border: Border.all(color: controller.selectedPaymentMethod.value == 'Cash On Delivery' ? AppThemeData.groceryAppDarkBlue : Colors.grey.shade100, width: 2),
                    //         color: AppThemeData.white,
                    //         boxShadow: const [
                    //           BoxShadow(
                    //             color: Color(0x19020202),
                    //             blurRadius: 5,
                    //             offset: Offset(0, 0),
                    //             spreadRadius: 0,
                    //           )
                    //         ],
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //         child: Row(
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Image.asset("assets/icons/ic_cod.png"),
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             const Expanded(
                    //               child: Text(
                    //                 "Cash On Delivery",
                    //                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: AppThemeData.semiBold, color: AppThemeData.black),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Visibility(
                    //   visible: controller.checkOnDeliveryModel != null && controller.checkOnDeliveryModel!.value.isEnabled,
                    //   child: InkWell(
                    //     onTap: () {
                    //       controller.selectedPaymentMethod.value = 'Cheque';
                    //       confirmPaymentBottomSheet(context, controller.selectedPaymentMethod.value, controller);
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         border: Border.all(color: controller.selectedPaymentMethod.value == 'Cheque' ? AppThemeData.groceryAppDarkBlue : Colors.grey.shade100, width: 2),
                    //         color: AppThemeData.white,
                    //         boxShadow: const [
                    //           BoxShadow(
                    //             color: Color(0x19020202),
                    //             blurRadius: 5,
                    //             offset: Offset(0, 0),
                    //             spreadRadius: 0,
                    //           )
                    //         ],
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //         child: Row(
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Image.asset("assets/icons/ic_cheque.png"),
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             const Expanded(
                    //               child: Text(
                    //                 "Cheque On Delivery",
                    //                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: AppThemeData.semiBold, color: AppThemeData.black),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: AppThemeData.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RoundedButtonFill(
                  title: "Pay".tr,
                  color: AppThemeData.groceryAppDarkBlue,
                  onPress: () async {
                    confirmPaymentBottomSheet(context, controller.selectedPaymentMethod.value, controller);
                  },
                ),
              ),
            ),
          );
        });
  }

  cardDecoration(PaymentOptionsController controller, String value, String image) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    decoration: BoxDecoration(color: AppThemeData.grey04, borderRadius: BorderRadius.circular(10)),
                    child: Image.network(
                      image,
                      width: 80,
                      height: 36,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppThemeData.assetColorGrey600),
                    ),
                  ),
                  if (value.toLowerCase() == 'wallet'.toLowerCase())
                    Text(Constant.amountShow(amount: controller.orderModel.value.user!.walletAmount),
                        style: TextStyle(
                            fontSize: 14, fontFamily: AppThemeData.semiBold, color: controller.walletBalanceError.value ? AppThemeData.colorRed : AppThemeData.groceryAppDarkBlue)),
                  Radio(
                    value: value.toString(),
                    groupValue: controller.selectedPaymentMethod.value,
                    activeColor: AppThemeData.groceryAppDarkBlue,
                    onChanged: (value) {
                      if (controller.walletBalanceError.value && value.toString().toLowerCase() == 'wallet'.toLowerCase()) {
                        ShowToastDialog.showToast("Your wallet doesn't have sufficient balance".tr);
                      } else {
                        controller.selectedPaymentMethod.value = value.toString();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

confirmPaymentBottomSheet(BuildContext context, selectPaymentMethod, PaymentOptionsController controller) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: AppThemeData.white,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child:
                      Text("Are you sure you want to".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Center(
                  child: Text("${selectPaymentMethod.toString()} in place order?.",
                      maxLines: 3, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppThemeData.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60),
                                ),
                                border: Border.all(color: AppThemeData.groceryAppDarkBlue, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                              child: Text(
                                "Cancel".tr,
                                style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontFamily: AppThemeData.medium, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          ShowToastDialog.showLoader("Payment Processing");
                          if (controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name) {
                            controller.stripeMakePayment(amount: double.parse(controller.totalAmount.value).toStringAsFixed(Constant.currencyModel!.decimal));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name) {
                            controller.paypalPaymentSheet(double.parse(controller.totalAmount.value).toStringAsFixed(Constant.currencyModel!.decimal),context);
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name) {
                            controller.payStackPayment(double.parse(controller.totalAmount.value).toStringAsFixed(Constant.currencyModel!.decimal));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.mercadoPago!.name) {
                            controller.mercadoPagoMakePayment(
                                context: context, amount: double.parse(controller.totalAmount.value).toStringAsFixed(Constant.currencyModel!.decimal));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.flutterWave!.name) {
                            controller.flutterWaveInitiatePayment(
                                context: context, amount: double.parse(controller.totalAmount.value).toStringAsFixed(Constant.currencyModel!.decimal));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payfast!.name) {
                            controller.payFastPayment(context: context, amount: double.parse(controller.totalAmount.value).toStringAsFixed(Constant.currencyModel!.decimal));
                          }
                          else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.xendit!.name) {
                            controller.xenditPayment(context, double.parse(controller.totalAmount.value));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.orangePay!.name) {
                            controller.orangeMakePayment(amount: controller.totalAmount.value.toString(), context: context);
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.midtrans!.name) {
                            controller.midtransMakePayment(amount: controller.totalAmount.value.toString(), context: context, ordersId: controller.orderModel.value.id);
                          }
                          else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name) {
                            RazorPayController()
                                .createOrderRazorPay(amount: double.parse(controller.totalAmount.value).toInt(), razorpayModel: controller.paymentModel.value.razorpay)
                                .then((value) {
                              if (value == null) {
                                Get.back();
                                ShowToastDialog.showToast("Something went wrong, please contact admin.".tr);
                              } else {
                                CreateRazorPayOrderModel result = value;
                                controller.openCheckout(amount: double.parse(controller.totalAmount.value).toInt(), orderId: result.id);
                              }
                            });
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.wallet!.name) {
                            if (double.parse(controller.orderModel.value.user!.walletAmount.toString()) >= double.parse(controller.totalAmount.value)) {
                              WalletTransactionModel transactionModel = WalletTransactionModel(
                                  id: Constant.getUuid(),
                                  amount: "-${controller.totalAmount.value.toString()}",
                                  createdDate: Timestamp.now(),
                                  paymentType: controller.selectedPaymentMethod.value,
                                  transactionId: "",
                                  note: "Order amount debit".tr,
                                  userId: FireStoreUtils.getCurrentUid(),
                                  isCredit: false,
                                  orderId: controller.orderModel.value.id);

                              await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
                                if (value == true) {
                                  await FireStoreUtils.updateUserWallet(amount: "-${controller.totalAmount.value.toString()}").then((value) {
                                    ShowToastDialog.closeLoader();
                                    controller.orderPlaced();
                                  });
                                }
                              });
                            } else {
                              ShowToastDialog.closeLoader();
                              ShowToastDialog.showToast("Wallet Amount Insufficient".tr);
                            }
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.cash!.name) {
                            ShowToastDialog.closeLoader();
                            controller.orderPlaced();
                          }
                        },
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppThemeData.groceryAppDarkBlue,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60),
                                ),
                                border: Border.all(color: AppThemeData.groceryAppDarkBlue)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                              child: Text(
                                "Yes".tr,
                                style: TextStyle(
                                  color: AppThemeData.white,
                                  fontFamily: AppThemeData.medium,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
}
