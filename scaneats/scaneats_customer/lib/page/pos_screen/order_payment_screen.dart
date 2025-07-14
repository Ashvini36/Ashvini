import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/controller/order_details_controller.dart';
import 'package:scaneats_customer/model/dining_table_model.dart';
import 'package:scaneats_customer/model/item_model.dart';
import 'package:scaneats_customer/model/tax_model.dart';
import 'package:scaneats_customer/model/user_model.dart';
import 'package:scaneats_customer/page/pos_screen/widget_pos_screen.dart';
import 'package:scaneats_customer/responsive/responsive.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';
import 'package:scaneats_customer/widget/common_ui.dart';
import 'package:scaneats_customer/widget/container_custom.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';
import 'package:scaneats_customer/widget/text_field_widget.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

class OrderPaymentScreen extends StatelessWidget {
  const OrderPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: Responsive.isMobile(context) ? CommonUI.appBarUI(context, isCartVisible: false) : null,
      body: GetX(
          init: OrderDetailsController(),
          builder: (controller) {
            return Padding(
              padding: paddingEdgeInsets(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SvgPicture.asset(
                          'assets/icons/arrow_left.svg',
                          height: 24,
                          width: 24,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, BlendMode.srcIn),
                        ),
                        spaceW(width: 5),
                        const TextCustom(title: 'Order Details', fontSize: 18, fontFamily: AppThemeData.medium, isUnderLine: false),
                      ]),
                    ),
                    spaceH(height: 20),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              ContainerCustom(
                                child: Column(children: [
                                  Row(children: [
                                    TextCustom(
                                      title: 'Order Id: ',
                                      fontSize: 16,
                                      fontFamily: AppThemeData.bold,
                                      color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                    ),
                                    TextCustom(
                                        title: controller.selectedOrder.value.id == '' ? '' : Constant.showOrderId(orderId: controller.selectedOrder.value.id.toString()),
                                        fontSize: 16,
                                        fontFamily: AppThemeData.bold,
                                        color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                  ]),
                                  spaceH(height: 15),
                                  controller.selectedOrder.value.tableId == null &&
                                          controller.selectedOrder.value.tableId?.isEmpty == true &&
                                          controller.selectedOrder.value.tableId == ''
                                      ? const SizedBox()
                                      : FutureBuilder<DiningTableModel?>(
                                          future: FireStoreUtils.getDiningTableById(controller.selectedOrder.value.tableId.toString()),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Constant.loader(context);
                                              default:
                                                if (snapshot.hasError) {
                                                  print(snapshot.error);
                                                  return Text('Error: ${snapshot.error}');
                                                } else {
                                                  return Row(children: [
                                                    TextCustom(
                                                        title: 'Table No :',
                                                        color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                        fontFamily: AppThemeData.medium),
                                                    spaceW(),
                                                    TextCustom(title: "${snapshot.data?.name}", fontFamily: AppThemeData.medium)
                                                  ]);
                                                }
                                            }
                                          },
                                        ),
                                ]),
                              ),
                              spaceH(height: 10),
                              ContainerCustom(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const TextCustom(title: 'Cart Summary', fontFamily: AppThemeData.medium, fontSize: 16),
                                spaceH(height: 15),
                                ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: devider(context, height: 2));
                                  },
                                  itemBuilder: (context, index) {
                                    ItemModel model = controller.selectedOrder.value.product![index];
                                    double totalAddonPrice = 0.0;
                                    if (model.addons != null)
                                      // ignore: curly_braces_in_flow_control_structures
                                      for (var element in model.addons!) {
                                        totalAddonPrice += double.parse(element.price!);
                                      }
                                    return SizedBox(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              TextCustom(title: model.name?.trim() ?? '', textAlign: TextAlign.start),
                                              spaceW(width: 5),
                                              model.itemAttributes != null
                                                  ? SizedBox(
                                                      height: 20,
                                                      child: TextCustom(
                                                          fontFamily: AppThemeData.regular,
                                                          title: "(${model.itemAttributes!.variants!.firstWhere((element) => element.variantId == model.variantId).variantSku})",
                                                          maxLine: 3,
                                                          fontSize: 12),
                                                    )
                                                  : const SizedBox(),
                                              spaceH(height: 5),
                                            ]),
                                          ],
                                        ),
                                        if (model.addons!.isNotEmpty)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: model.addons!
                                                    .map((e) => e.qty == 0
                                                        ? const SizedBox()
                                                        : Padding(
                                                            padding: const EdgeInsets.only(bottom: 4),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                  title: "${e.name!.capitalizeText()} (${Constant.amountShow(amount: e.price.toString())})",
                                                                  fontSize: 10,
                                                                ),
                                                                spaceW(width: 5),
                                                                TextCustom(
                                                                  title: "x ${e.qty ?? ''}",
                                                                  fontSize: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                    .toList()),
                                          ),
                                        if (model.addons!.isNotEmpty)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const TextCustom(
                                                title: "Total Addons Price: ",
                                                fontSize: 10,
                                              ),
                                              TextCustom(
                                                title: Constant.amountShow(amount: totalAddonPrice.toString()),
                                                fontSize: 10,
                                              ),
                                            ],
                                          ),
                                        spaceH(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                                fontSize: 16,
                                                title: Constant.amountShow(
                                                  amount: model.price ?? '0',
                                                )),
                                            TextCustom(
                                              fontSize: 16,
                                              title: '${model.qty ?? 0}',
                                            ),
                                          ],
                                        ),
                                      ]),
                                    );
                                  },
                                  itemCount: controller.selectedOrder.value.product?.length ?? 0,
                                ),
                              ])),
                              spaceH(),
                              ContainerCustom(
                                padding: EdgeInsets.zero,
                                child: Column(mainAxisSize: MainAxisSize.max, children: [
                                  Padding(
                                    padding: paddingEdgeInsets(),
                                    child: Column(children: [
                                      labelData(label: 'Sub Total', value: Constant.amountShow(amount: '${controller.selectedOrder.value.subtotal ?? 0}')),
                                      spaceH(height: 20),
                                      labelData(label: 'Discount', value: Constant.amountShow(amount: controller.selectedOrder.value.discount ?? '0.0')),
                                      spaceH(height: 20),
                                      ListView.builder(
                                          itemCount: Constant.taxList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            TaxModel taxModel = Constant.taxList[index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: labelData(
                                                  label:
                                                      '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
                                                  value: Constant.amountShow(
                                                      amount: Constant().calculateTax(taxModel: taxModel, amount: controller.selectedOrder.value.subtotal ?? '0.0').toString())),
                                            );
                                          }),
                                      spaceH(),
                                    ]),
                                  ),
                                  devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                          border: Border.all(color: themeChange.getThem() == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: labelData(
                                            label: 'Total',
                                            value: Constant.amountShow(amount: (double.parse(controller.selectedOrder.value.total ?? '0.0').toString())),
                                            textColor: AppThemeData.crusta500),
                                      )),
                                ]),
                              ),
                              spaceH(height: 15),
                              Visibility(
                                visible: Constant.paymentModel != null,
                                child: ContainerCustom(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextCustom(title: 'Payment Method', fontFamily: AppThemeData.medium, fontSize: 16),
                                      spaceH(),
                                      InkWell(
                                        onTap: () {
                                          showDialog(context: context, builder: (ctxt) => const PaymentDialog());
                                        },
                                        child: TextFieldWidget(
                                          hintText: 'Select Payment Method',
                                          controller: controller.paymentController.value,
                                          enable: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              spaceH(height: 10),
                              InkWell(
                                onTap: () async {
                                  controller.selectedOrder.value.paymentMethod = controller.selectedPaymentMethod.value;
                                  controller.selectedOrder.value.paymentStatus = true;
                                  controller.selectedOrder.value.status = Constant.statusDelivered;
                                  await Preferences.setString(Preferences.orderData, jsonEncode(controller.selectedOrder.value.toStringData()));
                                  await controller.makePayment(context, amount: controller.selectedOrder.value.total ?? '0.0');
                                },
                                child: ContainerCustom(
                                  color: AppThemeData.forestGreen400,
                                  child: Row(children: [
                                    const Expanded(
                                      child: TextCustom(title: 'Process to Payment'), //Process to Checkout
                                    ),
                                    Row(children: [
                                      TextCustom(title: Constant.amountShow(amount: '${(double.parse(controller.selectedOrder.value.total ?? '0.0'))}')),
                                      spaceW(),
                                      SvgPicture.asset('assets/icons/arrow_right.svg',
                                          height: 20,
                                          width: 20,
                                          fit: BoxFit.cover,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                    ])
                                  ]),
                                ),
                              ),
                              spaceH(height: 15),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ContainerCustom(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(
                                          title: 'Order Id: ',
                                          fontSize: 20,
                                          fontFamily: AppThemeData.bold,
                                          color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                        ),
                                        TextCustom(
                                            title: controller.selectedOrder.value.id == '' ? '' : Constant.showOrderId(orderId: controller.selectedOrder.value.id.toString()),
                                            fontSize: 20,
                                            fontFamily: AppThemeData.bold,
                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                      ]),
                                      Visibility(
                                        visible: controller.selectedOrder.value.createdAt != null,
                                        child: Column(
                                          children: [
                                            spaceH(height: 15),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_month, size: 15, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                                spaceW(),
                                                TextCustom(
                                                    title: controller.selectedOrder.value.createdAt == null
                                                        ? ''
                                                        : Constant.timestampToDateAndTime(controller.selectedOrder.value.createdAt!),
                                                    color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                    fontFamily: AppThemeData.medium)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (controller.selectedOrder.value.paymentStatus == true) spaceH(),
                                      if (controller.selectedOrder.value.paymentStatus == true)
                                        Row(children: [
                                          TextCustom(
                                              title: 'Payment Type :',
                                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                              fontFamily: AppThemeData.medium),
                                          spaceW(),
                                          TextCustom(title: controller.selectedOrder.value.paymentMethod ?? '', fontFamily: AppThemeData.medium)
                                        ]),
                                      spaceH(),
                                      Row(children: [
                                        TextCustom(
                                            title: 'Order Placed By :',
                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                            fontFamily: AppThemeData.medium),
                                        spaceW(),
                                        FutureBuilder<UserModel?>(
                                          future: FireStoreUtils.getRestaurantUserById(controller.selectedOrder.value.orderPlacedByUserId ?? ''), // async work
                                          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return const TextCustom(title: 'Loading...');
                                              default:
                                                if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                } else {
                                                  return snapshot.data?.id == null
                                                      ? TextCustom(title: 'Customer')
                                                      : TextCustom(
                                                          title:
                                                              '${Constant().capitalizeFirstLetter(snapshot.data?.name ?? '')} (${Constant().capitalizeFirstLetter(snapshot.data?.role ?? '')})');
                                                }
                                            }
                                          },
                                        ),
                                      ]),
                                      if (controller.selectedOrder.value.status == Constant.statusDelivered) spaceH(),
                                      if (controller.selectedOrder.value.status == Constant.statusDelivered)
                                        Row(children: [
                                          TextCustom(
                                              title: 'Delivery Time :',
                                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                              fontFamily: AppThemeData.medium),
                                          spaceW(),
                                          TextCustom(
                                            title:
                                                controller.selectedOrder.value.updatedAt == null ? '' : Constant.timestampToDateAndTime(controller.selectedOrder.value.updatedAt!),
                                            fontFamily: AppThemeData.medium,
                                          )
                                        ]),
                                      Visibility(
                                          visible: controller.selectedOrder.value.tokenNo != null && controller.selectedOrder.value.tokenNo!.isNotEmpty,
                                          child: Column(children: [
                                            spaceH(),
                                            Row(children: [
                                              TextCustom(
                                                  title: 'Token No :',
                                                  color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                  fontFamily: AppThemeData.medium),
                                              spaceW(),
                                              TextCustom(title: "#${controller.selectedOrder.value.tokenNo ?? ''}", fontFamily: AppThemeData.medium)
                                            ])
                                          ])),
                                      spaceH(),
                                      controller.selectedOrder.value.tableId == null &&
                                              controller.selectedOrder.value.tableId?.isEmpty == true &&
                                              controller.selectedOrder.value.tableId == ''
                                          ? const SizedBox()
                                          : FutureBuilder<DiningTableModel?>(
                                              future: FireStoreUtils.getDiningTableById(controller.selectedOrder.value.tableId.toString()),
                                              builder: (context, snapshot) {
                                                switch (snapshot.connectionState) {
                                                  case ConnectionState.waiting:
                                                    return Constant.loader(context);
                                                  default:
                                                    if (snapshot.hasError) {
                                                      print(snapshot.error);
                                                      return Text('Error: ${snapshot.error}');
                                                    } else {
                                                      return Row(children: [
                                                        TextCustom(
                                                            title: 'Table No :',
                                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                            fontFamily: AppThemeData.medium),
                                                        spaceW(),
                                                        TextCustom(title: "${snapshot.data?.name}", fontFamily: AppThemeData.medium)
                                                      ]);
                                                    }
                                                }
                                              },
                                            ),
                                      spaceH(),
                                    ],
                                  ),
                                ),
                              ),
                              spaceW(width: 20),
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ContainerCustom(
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        const TextCustom(title: 'Cart Summary', fontFamily: AppThemeData.medium, fontSize: 16),
                                        spaceH(height: 15),
                                        ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) {
                                            return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: devider(context, height: 2));
                                          },
                                          itemBuilder: (context, index) {
                                            ItemModel model = controller.selectedOrder.value.product![index];
                                            double totalAddonPrice = 0.0;
                                            if (model.addons != null)
                                              // ignore: curly_braces_in_flow_control_structures
                                              for (var element in model.addons!) {
                                                totalAddonPrice += double.parse(element.price!);
                                              }
                                            return SizedBox(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      TextCustom(title: model.name?.trim() ?? '', textAlign: TextAlign.start),
                                                      spaceW(width: 5),
                                                      model.itemAttributes != null
                                                          ? SizedBox(
                                                              height: 20,
                                                              child: TextCustom(
                                                                  fontFamily: AppThemeData.regular,
                                                                  title:
                                                                      "(${model.itemAttributes!.variants!.firstWhere((element) => element.variantId == model.variantId).variantSku})",
                                                                  maxLine: 3,
                                                                  fontSize: 12),
                                                            )
                                                          : const SizedBox(),
                                                      spaceH(height: 5),
                                                    ]),
                                                  ],
                                                ),
                                                if (model.addons!.isNotEmpty)
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: model.addons!
                                                            .map((e) => e.qty == 0
                                                                ? const SizedBox()
                                                                : Padding(
                                                                    padding: const EdgeInsets.only(bottom: 4),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        TextCustom(
                                                                          title: "${e.name!.capitalizeText()} (${Constant.amountShow(amount: e.price.toString())})",
                                                                          fontSize: 10,
                                                                        ),
                                                                        spaceW(width: 5),
                                                                        TextCustom(
                                                                          title: "x ${e.qty ?? ''}",
                                                                          fontSize: 10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ))
                                                            .toList()),
                                                  ),
                                                if (model.addons!.isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const TextCustom(
                                                        title: "Total Addons Price: ",
                                                        fontSize: 10,
                                                      ),
                                                      TextCustom(
                                                        title: Constant.amountShow(amount: totalAddonPrice.toString()),
                                                        fontSize: 10,
                                                      ),
                                                    ],
                                                  ),
                                                spaceH(height: 5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(
                                                        fontSize: 16,
                                                        title: Constant.amountShow(
                                                          amount: model.price ?? '0',
                                                        )),
                                                    TextCustom(
                                                      fontSize: 16,
                                                      title: '${model.qty ?? 0}',
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                            );
                                          },
                                          itemCount: controller.selectedOrder.value.product?.length ?? 0,
                                        ),
                                      ])),
                                      spaceH(),
                                      ContainerCustom(
                                        padding: EdgeInsets.zero,
                                        child: Column(mainAxisSize: MainAxisSize.max, children: [
                                          Padding(
                                            padding: paddingEdgeInsets(),
                                            child: Column(children: [
                                              labelData(label: 'Sub Totals', value: Constant.amountShow(amount: '${controller.selectedOrder.value.subtotal ?? 0}')),
                                              spaceH(height: 20),
                                              labelData(label: 'Discount', value: Constant.amountShow(amount: controller.selectedOrder.value.discount ?? '0.0')),
                                              spaceH(height: 20),
                                              ListView.builder(
                                                  itemCount: Constant.taxList.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    TaxModel taxModel = Constant.taxList[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: labelData(
                                                          label:
                                                              '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
                                                          value: Constant.amountShow(
                                                              amount: Constant()
                                                                  .calculateTax(taxModel: taxModel, amount: controller.selectedOrder.value.subtotal ?? '0.0')
                                                                  .toString())),
                                                    );
                                                  }),
                                              Visibility(visible: Constant.taxList.isNotEmpty, child: spaceH(height: 20)),
                                            ]),
                                          ),
                                          devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                  border: Border.all(color: themeChange.getThem() == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                child: labelData(
                                                    label: 'Total',
                                                    value: Constant.amountShow(amount: (double.parse(controller.selectedOrder.value.total ?? '0.0').toString())),
                                                    textColor: AppThemeData.crusta500),
                                              )),
                                        ]),
                                      ),
                                      spaceH(height: 15),
                                      Visibility(
                                        visible: Constant.paymentModel != null,
                                        child: ContainerCustom(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const TextCustom(title: 'Payment Method', fontFamily: AppThemeData.medium, fontSize: 16),
                                              spaceH(),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(context: context, builder: (ctxt) => const PaymentDialog());
                                                },
                                                child: TextFieldWidget(
                                                  hintText: 'Select Payment Method',
                                                  controller: controller.paymentController.value,
                                                  enable: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      spaceH(height: 10),
                                      InkWell(
                                        onTap: () async {
                                          controller.selectedOrder.value.paymentMethod = controller.selectedPaymentMethod.value;
                                          controller.selectedOrder.value.paymentStatus = true;
                                          controller.selectedOrder.value.status = Constant.statusDelivered;
                                          await Preferences.setString(Preferences.orderData, jsonEncode(controller.selectedOrder.value.toStringData()));
                                          await controller.makePayment(context, amount: controller.selectedOrder.value.total ?? '0.0');
                                        },
                                        child: ContainerCustom(
                                          color: AppThemeData.forestGreen400,
                                          child: Row(children: [
                                            const Expanded(
                                              child: TextCustom(title: 'Proceed to Order'), //Process to Checkout
                                            ),
                                            Row(children: [
                                              TextCustom(title: Constant.amountShow(amount: '${(double.parse(controller.selectedOrder.value.total ?? '0.0'))}')),
                                              spaceW(),
                                              SvgPicture.asset('assets/icons/arrow_right.svg',
                                                  height: 20,
                                                  width: 20,
                                                  fit: BoxFit.cover,
                                                  color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                            ])
                                          ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: OrderDetailsController(),
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
                  visible: Constant.paymentModel != null && Constant.paymentModel!.cash != null && Constant.paymentModel!.cash!.enable == true,
                  child: cardDecoration(controller, Constant.paymentModel!.cash!.name.toString(), themeChange, "assets/images/ic_cash.png"),
                ),
                Visibility(
                  visible: Constant.paymentModel != null && Constant.paymentModel!.card != null && Constant.paymentModel!.card!.enable == true,
                  child: cardDecoration(controller, Constant.paymentModel!.card!.name.toString(), themeChange, "assets/images/ic_card.png"),
                ),
                Visibility(
                  visible: Constant.paymentModel != null && Constant.paymentModel!.strip != null && Constant.paymentModel!.strip!.enable == true,
                  child: cardDecoration(controller, Constant.paymentModel!.strip!.name.toString(), themeChange, "assets/images/strip.png"),
                ),
                Visibility(
                  visible: Constant.paymentModel != null && Constant.paymentModel!.paypal != null && Constant.paymentModel!.paypal!.enable == true,
                  child: cardDecoration(controller, Constant.paymentModel!.paypal!.name.toString(), themeChange, "assets/images/paypal.png"),
                ),
                Visibility(
                  visible: Constant.paymentModel != null && Constant.paymentModel!.payStack != null && Constant.paymentModel!.payStack!.enable == true,
                  child: cardDecoration(controller, Constant.paymentModel!.payStack!.name.toString(), themeChange, "assets/images/paystack.png"),
                ),
                Visibility(
                  visible: Constant.paymentModel != null && Constant.paymentModel!.razorpay != null && Constant.paymentModel!.razorpay!.enable == true,
                  child: cardDecoration(controller, Constant.paymentModel!.razorpay!.name.toString(), themeChange, "assets/images/rezorpay.png"),
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          //   RoundedButtonFill(
          //       borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
          //       width: 80,
          //       radius: 8,
          //       height: 40,
          //       fontSizes: 14,
          //       title: "Close",
          //       icon: SvgPicture.asset('assets/icons/close.svg',
          //           height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
          //       textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
          //       isRight: false,
          //       onPress: () {
          //         Get.back();
          //       }),
          //   RoundedButtonFill(
          //     width: 100,
          //     radius: 8,
          //     height: 40,
          //     fontSizes: 14,
          //     title: "Subscribe",
          //     icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
          //     color: AppThemeData.crusta500,
          //     textColor: AppThemeData.white,
          //     isRight: false,
          //     onPress: () async {
          //       // await Constant.setSubscription(subscriptionModel, dayModel, controller.selectedPaymentMethod.value);
          //
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  cardDecoration(OrderDetailsController controller, String value, themeChange, String image) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () {
              controller.selectedPaymentMethod.value = value;
              controller.paymentController.value.text = value;
              Get.back();
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
