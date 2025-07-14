import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/constant/collection_name.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/constant/show_toast_dialog.dart';
import 'package:scaneats_customer/controller/order_details_controller.dart';
import 'package:scaneats_customer/model/dining_table_model.dart';
import 'package:scaneats_customer/model/item_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/model/restaurant_model.dart';
import 'package:scaneats_customer/model/tax_model.dart';
import 'package:scaneats_customer/model/user_model.dart';
import 'package:scaneats_customer/page/pos_screen/navigate_pos_screen.dart';
import 'package:scaneats_customer/page/pos_screen/order_payment_screen.dart';
import 'package:scaneats_customer/page/pos_screen/widget_pos_screen.dart';
import 'package:scaneats_customer/responsive/responsive.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';
import 'package:scaneats_customer/widget/container_custom.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';
import 'package:scaneats_customer/widget/network_image_widget.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel ordermodel;
  final String restaurantId;
  const OrderDetailScreen({super.key, required this.ordermodel, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OrderDetailsController(),
        initState: (state) {
          Constant.tableNo = ordermodel.tableId ?? '';
          Constant.branchId = ordermodel.branchId ?? '';
          CollectionName.restaurantId = restaurantId;
          state.controller?.setOrderModel(ordermodel);
        },
        builder: (controller) {
          return SafeArea(
            child: controller.selectedOrder.value.id == null
                ? Constant.loader(context)
                : Column(
                    children: [
                      spaceH(height: 10),
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spaceH(),
                            const TextCustom(title: 'Order Details', fontSize: 18, fontFamily: AppThemeData.medium, isUnderLine: false),
                            spaceH(height: 20),
                            Responsive.isMobile(context)
                                ? Column(
                                    children: [
                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                      controller.selectedOrder.value.tableId == null || controller.selectedOrder.value.tableId!.isEmpty
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
                                                        TextCustom(title: "${snapshot.data!.name}", fontFamily: AppThemeData.medium)
                                                      ]);
                                                    }
                                                }
                                              },
                                            ),
                                      spaceH(),
                                      restaurantId == '' || restaurantId.isEmpty
                                          ? const SizedBox()
                                          : FutureBuilder<RestaurantModel?>(
                                              future: FireStoreUtils.getRestaurantById(restaurantId: restaurantId),
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
                                                            title: 'Restaurant Name :',
                                                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                            fontFamily: AppThemeData.medium),
                                                        spaceW(),
                                                        TextCustom(title: capitalize(snapshot.data?.name ?? ''), fontFamily: AppThemeData.medium)
                                                      ]);
                                                    }
                                                }
                                              },
                                            ),
                                      spaceH(),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppThemeData.crusta500,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              child: Text(
                                                controller.selectedOrder.value.paymentStatus == false ? 'Unpaid' : 'Paid',
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppThemeData.crusta500,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              child: Text(
                                                controller.selectedOrder.value.status.toString(),
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          InkWell(
                                            onTap: () async {
                                              ShowToastDialog.showLoader("Please wait...");
                                              OrderModel order = controller.selectedOrder.value;
                                              await controller.setOrderData(order);
                                              ShowToastDialog.closeLoader();
                                              Get.to(OrderPaymentScreen());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppThemeData.forestGreen400,
                                                ),
                                                color: AppThemeData.forestGreen400,
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                child: TextCustom(title: 'Pay  ${Constant.amountShow(amount: '${controller.selectedOrder.value.total ?? 0}')}'),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
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
                                                          title: Constant.timestampToDateAndTime(controller.selectedOrder.value.createdAt!),
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
                                                  title: controller.selectedOrder.value.updatedAt == null
                                                      ? ''
                                                      : Constant.timestampToDateAndTime(controller.selectedOrder.value.updatedAt!),
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
                                            restaurantId == '' || restaurantId.isEmpty
                                                ? const SizedBox()
                                                : FutureBuilder<RestaurantModel?>(
                                                    future: FireStoreUtils.getRestaurantById(restaurantId: restaurantId),
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
                                                                  title: 'Restaurant Name :',
                                                                  color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                                  fontFamily: AppThemeData.medium),
                                                              spaceW(),
                                                              TextCustom(title: capitalize(snapshot.data?.name ?? ''), fontFamily: AppThemeData.medium)
                                                            ]);
                                                          }
                                                      }
                                                    },
                                                  ),
                                          ],
                                        ),
                                        SingleChildScrollView(
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppThemeData.crusta500,
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  child: Text(
                                                    controller.selectedOrder.value.paymentStatus == false ? 'Unpaid' : 'Paid',
                                                  ),
                                                ),
                                              ),
                                              spaceW(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppThemeData.crusta500,
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  child: Text(
                                                    controller.selectedOrder.value.status.toString(),
                                                  ),
                                                ),
                                              ),
                                              spaceW(),
                                              InkWell(
                                                onTap: () async {
                                                  ShowToastDialog.showLoader("Please wait...");
                                                  OrderModel order = controller.selectedOrder.value;
                                                  await controller.setOrderData(order);
                                                  ShowToastDialog.closeLoader();
                                                  Get.to(OrderPaymentScreen());
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppThemeData.forestGreen400,
                                                    ),
                                                    color: AppThemeData.forestGreen400,
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                    child: TextCustom(title: 'Pay ${Constant.amountShow(amount: '${controller.selectedOrder.value.total ?? 0}')}'),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            spaceH(height: 15),
                            if (Responsive.isDesktop(context) && controller.selectedOrder.value.product != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: orderDetailWidget(context: context, productData: controller.selectedOrder.value.product!, ordermodel: controller.selectedOrder.value)),
                                  spaceW(width: 15),
                                  Expanded(child: auditDeliveryDetailWidget(context: context, orderModel: controller.selectedOrder.value)),
                                ],
                              ),
                            if (!Responsive.isDesktop(context) && controller.selectedOrder.value.product != null)
                              SizedBox(
                                height: Responsive.height(62, context),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      orderDetailWidget(context: context, productData: controller.selectedOrder.value.product!, ordermodel: controller.selectedOrder.value),
                                      spaceH(),
                                      auditDeliveryDetailWidget(context: context, orderModel: controller.selectedOrder.value),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
          );
        });
  }

  Widget orderDetailWidget({required BuildContext context, required List<ItemModel> productData, required OrderModel ordermodel}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ContainerCustom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(title: 'Order Details', fontSize: Responsive.isMobile(context) ? 18 : 18),
          spaceH(),
          devider(context),
          spaceH(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: productData.isEmpty
                  ? Constant.loaderWithNoFound(context, isLoading: false, isNotFound: productData.isEmpty)
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
                      rows: productData.map(
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
                              DataCell(Center(child: TextCustom(title: Constant.amountShow(amount: e.price.toString()), color: AppThemeData.forestGreen800))),
                              DataCell(Center(child: TextCustom(title: 'x ${e.qty.toString()}'))),
                              DataCell(
                                Center(
                                  child: e.addons!.isEmpty
                                      ? TextCustom(
                                          title: Constant.amountShow(amount: "0"),
                                          color: AppThemeData.forestGreen800,
                                        )
                                      : TextCustom(
                                          title: Constant.amountShow(amount: addonAmount.toString()),
                                          color: AppThemeData.forestGreen800,
                                        ),
                                ),
                              ),
                              DataCell(Center(
                                  child: TextCustom(
                                title: Constant.amountShow(amount: totalCost),
                                color: AppThemeData.forestGreen800,
                              ))),
                            ],
                          );
                        },
                      ).toList()),
            ),
          ),
          if (ordermodel.paymentStatus == false)
            Column(children: [
              spaceH(),
              InkWell(
                onTap: () async {
                  await Constant.setOrderData(ordermodel);
                  Get.to(NavigatePosScreen());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(color: AppThemeData.crusta500, borderRadius: BorderRadius.circular(6)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    child: TextCustom(
                      title: '+ Add Product',
                      color: AppThemeData.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ]),
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
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              labelData(
                  label: 'Sub Total',
                  textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                  value: Constant.amountShow(amount: '${orderModel?.subtotal ?? 0}')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Divider(
                  color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                ),
              ),
              labelData(
                  label: 'Discount',
                  textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                  value: "-${Constant.amountShow(amount: orderModel?.discount ?? '0')}"),
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
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: labelData(
                          label: '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
                          textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                          value: Constant.amountShow(
                              amount: Constant()
                                  .calculateTax(taxModel: taxModel, amount: (double.parse(orderModel.subtotal ?? '0.0') - double.parse(orderModel.discount ?? '0.0')).toString())
                                  .toString())),
                    );
                  }),
              Visibility(
                visible: orderModel.taxList?.isNotEmpty == true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Divider(
                    color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                      border: Border.all(color: themeChange.getThem() == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                  child: labelData(
                    label: 'Total',
                    textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                    value: Constant.amountShow(amount: double.parse(orderModel.total ?? '0.0').toString()),
                  )),
            ]),
          ),
          orderModel.customer?.id != null && orderModel.customer?.id != ''
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
        ]))
      ],
    );
  }
}
