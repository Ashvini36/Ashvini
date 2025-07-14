import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/dash_board_controller.dart';
import 'package:scaneats/app/controller/order_details_controller.dart';
import 'package:scaneats/app/model/dining_table_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/app/ui/item_screen/widget_item.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/common_ui.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        Responsive.isMobile(context) ? CommonUI.appBarMobileUI(context) : CommonUI.appBarUI(context),
        GetBuilder(
            init: OrderDetailsController(),
            builder: (controller) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spaceH(),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                DashBoardController dashBoardController = Get.find<DashBoardController>();
                                dashBoardController.changeView(screenType: "");
                              },
                              child: Icon(Icons.arrow_back, size: 25, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)),
                          spaceW(),
                          Responsive.isMobile(context)
                              ? const TextCustom(title: 'Order Details', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true)
                              : Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          DashBoardController dashBoardController = Get.find<DashBoardController>();
                                          dashBoardController.changeView(screenType: "");
                                        },
                                        child: const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true)),
                                    const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                                    const TextCustom(title: 'Order Details', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true),
                                  ],
                                ),
                          spaceH(height: 20),
                        ],
                      ),
                      spaceH(),
                      Responsive.isMobile(context)
                          ? Column(
                              children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  TextCustom(
                                    title: 'Order Id: ',
                                    fontSize: 20,
                                    letterSpacing: 1.2,
                                    fontFamily: AppThemeData.bold,
                                    color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                  ),
                                  TextCustom(
                                      title: controller.selectedOrder.value.id == '' ? '' : Constant.orderId(orderId: controller.selectedOrder.value.id.toString()),
                                      fontSize: 20,
                                      fontFamily: AppThemeData.bold,
                                      letterSpacing: 1.2,
                                      color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                ]),
                                spaceH(height: 15),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month, size: 15, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                    spaceW(),
                                    TextCustom(
                                        title: controller.selectedOrder.value.createdAt == null ? '' : Constant.timestampToDateAndTime(controller.selectedOrder.value.createdAt!),
                                        letterSpacing: 0.4,
                                        color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                        fontFamily: AppThemeData.medium)
                                  ],
                                ),
                                if (controller.selectedOrder.value.paymentStatus == true) spaceH(),
                                if (controller.selectedOrder.value.paymentStatus == true)
                                  Row(children: [
                                    TextCustom(
                                        title: 'Payment Type :',
                                        letterSpacing: 0.4,
                                        color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                        fontFamily: AppThemeData.medium),
                                    spaceW(),
                                    TextCustom(title: controller.selectedOrder.value.paymentMethod ?? '', letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                  ]),
                                spaceH(),
                                Row(children: [
                                  TextCustom(
                                      title: 'Order Type :',
                                      letterSpacing: 0.4,
                                      color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                      fontFamily: AppThemeData.medium),
                                  spaceW(),
                                  TextCustom(
                                      title: controller.selectedOrder.value.type == null ? '' : controller.selectedOrder.value.type!.toUpperCase(),
                                      fontFamily: AppThemeData.medium,
                                      letterSpacing: 0.4)
                                ]),
                                if (controller.selectedOrder.value.status == Constant.statusDelivered) spaceH(),
                                if (controller.selectedOrder.value.status == Constant.statusDelivered)
                                  Row(children: [
                                    TextCustom(
                                        title: 'Delivery Time :',
                                        letterSpacing: 0.4,
                                        color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                        fontFamily: AppThemeData.medium),
                                    spaceW(),
                                    TextCustom(
                                        title: controller.selectedOrder.value.updatedAt == null ? '' : Constant.timestampToDateAndTime(controller.selectedOrder.value.updatedAt!),
                                        fontFamily: AppThemeData.medium,
                                        letterSpacing: 0.4)
                                  ]),
                                Visibility(
                                    visible: controller.selectedOrder.value.tokenNo != null && controller.selectedOrder.value.tokenNo!.isNotEmpty,
                                    child: Column(children: [
                                      spaceH(),
                                      Row(children: [
                                        TextCustom(
                                            title: 'Token No :',
                                            letterSpacing: 0.4,
                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                            fontFamily: AppThemeData.medium),
                                        spaceW(),
                                        TextCustom(title: "#${controller.selectedOrder.value.tokenNo ?? ''}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                      ])
                                    ])),
                                spaceH(),
                                controller.selectedOrder.value.tableId == null || controller.selectedOrder.value.tableId!.isEmpty
                                    ? const SizedBox()
                                    : FutureBuilder<DiningTableModel?>(
                                        future: FireStoreUtils.getDiningTableById(tableId: controller.selectedOrder.value.tableId.toString()),
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
                                                      letterSpacing: 0.4,
                                                      color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                      fontFamily: AppThemeData.medium),
                                                  spaceW(),
                                                  TextCustom(title: "${snapshot.data!.name}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                                ]);
                                              }
                                          }
                                        },
                                      ),
                                spaceH(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: controller.selectedPaymentStatus.value,
                                          hint: const TextCustom(title: 'Select'),
                                          onChanged: (String? newValue) {
                                            controller.selectedPaymentStatus.value = newValue!;
                                            if (newValue == 'Paid') {
                                              controller.selectedOrderStatus.value = Constant.statusDelivered;
                                            }
                                            controller.update();
                                            controller.updateOrderData();
                                          },
                                          decoration: InputDecoration(
                                              iconColor: AppThemeData.crusta500,
                                              isDense: true,
                                              filled: true,
                                              fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              hintText: "Select",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: AppThemeData.medium)),
                                          items: controller.paymentStatus.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: TextCustom(title: value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    spaceW(),
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: controller.selectedOrderStatus.value,
                                          hint: const TextCustom(title: 'Select'),
                                          onChanged: (String? newValue) {
                                            controller.selectedOrderStatus.value = newValue!;
                                            if (newValue == Constant.statusDelivered) {
                                              controller.selectedPaymentStatus.value = "Paid";
                                            }
                                            controller.update();
                                            controller.updateOrderData();
                                          },
                                          decoration: InputDecoration(
                                              iconColor: AppThemeData.crusta500,
                                              isDense: true,
                                              filled: true,
                                              fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(
                                                  color: AppThemeData.crusta500,
                                                ),
                                              ),
                                              hintText: "Select",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: AppThemeData.medium)),
                                          items: controller.orderType.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: TextCustom(title: value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                spaceH(),
                                RoundedButtonFill(
                                    radius: 6,
                                    width: 150,
                                    height: 40,
                                    icon: const Icon(Icons.print, size: 20, color: AppThemeData.white),
                                    title: "Print Invoice",
                                    color: AppThemeData.crusta500,
                                    fontSizes: 14,
                                    textColor: AppThemeData.white,
                                    isRight: false,
                                    onPress: () async {
                                      controller.printInvoice();
                                    }),
                              ],
                            )
                          : ContainerCustom(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(
                                          title: 'Order Id: ',
                                          fontSize: 20,
                                          letterSpacing: 1.2,
                                          fontFamily: AppThemeData.bold,
                                          color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                        ),
                                        TextCustom(
                                            title: controller.selectedOrder.value.id == '' ? '' : Constant.orderId(orderId: controller.selectedOrder.value.id.toString()),
                                            fontSize: 20,
                                            fontFamily: AppThemeData.bold,
                                            letterSpacing: 1.2,
                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                      ]),
                                      spaceH(height: 15),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_month, size: 15, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                          spaceW(),
                                          TextCustom(
                                              title: controller.selectedOrder.value.createdAt == null
                                                  ? ''
                                                  : Constant.timestampToDateAndTime(controller.selectedOrder.value.createdAt!),
                                              letterSpacing: 0.4,
                                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                              fontFamily: AppThemeData.medium)
                                        ],
                                      ),
                                      if (controller.selectedOrder.value.paymentStatus == true) spaceH(),
                                      if (controller.selectedOrder.value.paymentStatus == true)
                                        Row(children: [
                                          TextCustom(
                                              title: 'Payment Type :',
                                              letterSpacing: 0.4,
                                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                              fontFamily: AppThemeData.medium),
                                          spaceW(),
                                          TextCustom(title: controller.selectedOrder.value.paymentMethod ?? '', letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                        ]),
                                      spaceH(),
                                      Row(children: [
                                        TextCustom(
                                            title: 'Order Type :',
                                            letterSpacing: 0.4,
                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                            fontFamily: AppThemeData.medium),
                                        spaceW(),
                                        TextCustom(
                                            title: controller.selectedOrder.value.type == null ? '' : controller.selectedOrder.value.type!.toUpperCase(),
                                            fontFamily: AppThemeData.medium,
                                            letterSpacing: 0.4)
                                      ]),
                                      if (controller.selectedOrder.value.status == Constant.statusDelivered) spaceH(),
                                      if (controller.selectedOrder.value.status == Constant.statusDelivered)
                                        Row(children: [
                                          TextCustom(
                                              title: 'Delivery Time :',
                                              letterSpacing: 0.4,
                                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                              fontFamily: AppThemeData.medium),
                                          spaceW(),
                                          TextCustom(
                                              title: controller.selectedOrder.value.updatedAt == null
                                                  ? ''
                                                  : Constant.timestampToDateAndTime(controller.selectedOrder.value.updatedAt!),
                                              fontFamily: AppThemeData.medium,
                                              letterSpacing: 0.4)
                                        ]),
                                      Visibility(
                                          visible: controller.selectedOrder.value.tokenNo != null && controller.selectedOrder.value.tokenNo!.isNotEmpty,
                                          child: Column(children: [
                                            spaceH(),
                                            Row(children: [
                                              TextCustom(
                                                  title: 'Token No :',
                                                  letterSpacing: 0.4,
                                                  color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                  fontFamily: AppThemeData.medium),
                                              spaceW(),
                                              TextCustom(title: "#${controller.selectedOrder.value.tokenNo ?? ''}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                            ])
                                          ])),
                                      spaceH(),
                                      controller.selectedOrder.value.tableId == null || controller.selectedOrder.value.tableId!.isEmpty
                                          ? const SizedBox()
                                          : FutureBuilder<DiningTableModel?>(
                                              future: FireStoreUtils.getDiningTableById(tableId: controller.selectedOrder.value.tableId.toString()),
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
                                                            letterSpacing: 0.4,
                                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                            fontFamily: AppThemeData.medium),
                                                        spaceW(),
                                                        TextCustom(title: "${snapshot.data!.name}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                                      ]);
                                                    }
                                                }
                                              },
                                            ),
                                    ],
                                  ),
                                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    SizedBox(
                                      width: 150,
                                      height: 40,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: controller.selectedPaymentStatus.value,
                                        hint: const TextCustom(title: 'Select'),
                                        onChanged: (String? newValue) {
                                          controller.selectedPaymentStatus.value = newValue!;
                                          if (newValue == 'Paid') {
                                            controller.selectedOrderStatus.value = Constant.statusDelivered;
                                          }
                                          controller.update();
                                          controller.updateOrderData();
                                        },
                                        decoration: InputDecoration(
                                            iconColor: AppThemeData.crusta500,
                                            isDense: true,
                                            filled: true,
                                            fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            hintText: "Select",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppThemeData.medium)),
                                        items: controller.paymentStatus.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: TextCustom(title: value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    spaceW(),
                                    SizedBox(
                                      width: 150,
                                      height: 40,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: controller.selectedOrderStatus.value,
                                        hint: const TextCustom(title: 'Select'),
                                        onChanged: (String? newValue) {
                                          controller.selectedOrderStatus.value = newValue!;
                                          if (newValue == Constant.statusDelivered) {
                                            controller.selectedPaymentStatus.value = "Paid";
                                          }
                                          controller.update();
                                          controller.updateOrderData();
                                        },
                                        decoration: InputDecoration(
                                            iconColor: AppThemeData.crusta500,
                                            isDense: true,
                                            filled: true,
                                            fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: AppThemeData.crusta500,
                                              ),
                                            ),
                                            hintText: "Select",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppThemeData.medium)),
                                        items: controller.orderType.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: TextCustom(title: value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    spaceW(),
                                    RoundedButtonFill(
                                        radius: 6,
                                        width: 150,
                                        height: 40,
                                        icon: const Icon(Icons.print, size: 20, color: AppThemeData.white),
                                        title: "Print Invoice",
                                        color: AppThemeData.crusta500,
                                        fontSizes: 14,
                                        textColor: AppThemeData.white,
                                        isRight: false,
                                        onPress: () async {
                                          controller.printInvoice();
                                        }),
                                  ])
                                ],
                              ),
                            ),
                      spaceH(height: 15),
                      if (Responsive.isDesktop(context) && controller.selectedOrder.value.product != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: orderDetailWidget(context: context, ordermodel: controller.selectedOrder.value)),
                            spaceW(width: 15),
                            Expanded(child: auditDeliveryDetailWidget(context: context, orderModel: controller.selectedOrder.value)),
                          ],
                        ),
                      if (!Responsive.isDesktop(context) && controller.selectedOrder.value.product != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderDetailWidget(context: context, ordermodel: controller.selectedOrder.value),
                            spaceH(),
                            auditDeliveryDetailWidget(context: context, orderModel: controller.selectedOrder.value),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }

  Widget orderDetailWidget({required BuildContext context, required OrderModel ordermodel}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ContainerCustom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(title: 'Order Details', fontSize: Responsive.isMobile(context) ? 16 : 18),
          spaceH(),
          devider(context),
          spaceH(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: ordermodel.product?.isEmpty == true
                  ? Constant.loaderWithNoFound(context, isLoading: false, isNotFound: ordermodel.product?.isEmpty == true)
                  : DataTable(
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
                            width: 220,
                            child: Center(child: TextCustom(title: 'Item')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 85,
                            child: Center(child: TextCustom(title: 'Price')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 85,
                            child: Center(child: TextCustom(title: 'Qty')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 85,
                            child: Center(child: TextCustom(title: 'Extras')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 85,
                            child: Center(child: TextCustom(title: 'Total')),
                          ),
                        ),
                      ],
                      rows: ordermodel.product!.map(
                        (e) {
                          var productAmount = double.parse(e.price!) * e.qty!;
                          var addonAmount = e.addons!.isNotEmpty ? e.addons!.fold(0.0, (sum, item) => sum + item.qty!.toDouble() * double.parse(item.price!)) : 0.0;
                          String totalCost = (productAmount + addonAmount).toString();
                          return DataRow(
                            cells: [
                              DataCell(Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: NetworkImageWidget(imageUrl: e.image ?? '', placeHolderUrl: Constant.userPlaceholderURL, height: 30, width: 30)),
                                  spaceW(),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? ''),
                                            spaceW(),
                                            if (e.variantId != null)
                                              TextCustom(
                                                title: '(${e.itemAttributes?.variants?.firstWhere((element) => element.variantId == e.variantId).variantSku.toString()})',
                                                fontSize: 14,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        if (e.addons!.isNotEmpty)
                                          Column(
                                              children: e.addons!
                                                  .map((e) => e.qty == 0
                                                      ? const SizedBox()
                                                      : Padding(
                                                          padding: const EdgeInsets.only(bottom: 4),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              TextCustom(
                                                                title: "${e.name ?? ''} (${Constant.amountShow(amount: e.price.toString())})",
                                                                fontSize: 10,
                                                              ),
                                                              spaceW(),
                                                              TextCustom(
                                                                title: "x ${e.qty ?? ''}",
                                                                fontSize: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                  .toList())
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              DataCell(Center(child: TextCustom(title: Constant.amountShow(amount: e.price.toString()), color: AppThemeData.forestGreen))),
                              DataCell(Center(child: TextCustom(title: 'x ${e.qty.toString()}'))),
                              DataCell(
                                Center(
                                  child: e.addons!.isEmpty
                                      ? TextCustom(
                                          title: Constant.amountShow(amount: "0"),
                                          color: AppThemeData.forestGreen,
                                        )
                                      : TextCustom(
                                          title: Constant.amountShow(amount: addonAmount.toString()),
                                          color: AppThemeData.forestGreen,
                                        ),
                                ),
                              ),
                              DataCell(Center(
                                  child: TextCustom(
                                title: Constant.amountShow(amount: totalCost),
                                color: AppThemeData.forestGreen,
                              ))),
                            ],
                          );
                        },
                      ).toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget auditDeliveryDetailWidget({required BuildContext context, OrderModel? orderModel}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        ContainerCustom(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.all(12),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  spaceH(),
                  labelData(
                      label: 'Sub Total',
                      textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                      value: Constant.amountShow(amount: '${orderModel?.subtotal ?? 0}')),
                  spaceH(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Divider(
                      color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                    ),
                  ),
                  labelData(
                      label: 'Discount',
                      textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                      value: "-${Constant.amountShow(amount: orderModel?.discount ?? '')}"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Divider(
                      color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                    ),
                  ),
                  ListView.builder(
                      itemCount: orderModel!.taxList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        TaxModel taxModel = orderModel.taxList![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: labelData(
                              label: '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
                              textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                              value: Constant.amountShow(
                                  amount: Constant()
                                      .calculateTax(
                                          taxModel: taxModel, amount: (double.parse(orderModel.subtotal.toString()) - double.parse(orderModel.discount.toString())).toString())
                                      .toString())),
                        );
                      }),
                ])),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                    color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                    border: Border.all(color: themeChange.getThem() == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                child: labelData(
                  label: 'Total',
                  textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                  value: Constant.amountShow(amount: orderModel.total ?? ''),
                )),
          ]),
        ),
        spaceH(height: 15),
        orderModel.customer?.id != null
            ? ContainerCustom(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextCustom(title: 'Customer Information', fontSize: Responsive.isMobile(context) ? 16 : 18),
                  spaceH(height: 5),
                  devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                  spaceH(height: 5),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: NetworkImageWidget(
                                imageUrl: orderModel.customer?.profileImage ?? '',
                                placeHolderUrl: Constant.userPlaceholderURL,
                                height: 30,
                                width: 30,
                              ),
                            ),
                            spaceW(width: 15),
                            TextCustom(title: capitalize(orderModel.customer?.name ?? ''))
                          ],
                        ),
                        spaceH(height: 15),
                        devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                        spaceH(height: 15),
                        Row(
                          children: [
                            Icon(Icons.email, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600, size: 18),
                            spaceW(),
                            TextCustom(
                              title: orderModel.customer?.email ?? '',
                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                              fontFamily: AppThemeData.regular,
                            )
                          ],
                        ),
                        spaceH(height: 15),
                        Row(
                          children: [
                            Icon(Icons.phone, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600, size: 18),
                            spaceW(),
                            TextCustom(
                              title: orderModel.customer?.mobileNo ?? '',
                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                              fontFamily: AppThemeData.regular,
                            )
                          ],
                        ),
                        spaceH(height: 15),
                        devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                      ]),
                    ),
                  ])
                ]),
              )
            : const SizedBox(),
      ],
    );
  }
}
