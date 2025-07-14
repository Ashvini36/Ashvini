import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/dash_board_controller.dart';
import 'package:scaneats/app/controller/notification_controller.dart';
import 'package:scaneats/app/controller/order_details_controller.dart';
import 'package:scaneats/app/controller/pos_controller.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/dining_table_model.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/app/ui/login_screen/login_screen.dart';
import 'package:scaneats/app/ui/pos_screen/widget_pos_screen.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/service/localization_service.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

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
  static AppBar appBarUI(BuildContext context, {Color? backgroundColor, dynamic onChange, dynamic onSelectBranch, bool isPOSTable = false}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      backgroundColor: themeChange.getThem() ? backgroundColor ?? AppThemeData.black : backgroundColor ?? AppThemeData.white,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      centerTitle: false,
      titleSpacing: 16,
      title: SizedBox(
        child: GetX<DashBoardController>(
            init: DashBoardController(),
            builder: (controller) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: onSelectBranch != null,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/icons/appbar_1.svg', height: 40, width: 40, fit: BoxFit.cover),
                            spaceW(),
                            BranchPopUp(onSelectBranch: onSelectBranch),
                            spaceW(width: 40),
                          ],
                        )),
                    GestureDetector(
                        onTap: () {
                          controller.setThme(themeChange: themeChange);
                        },
                        child: themeChange.getThem()
                            ? const Icon(Icons.light_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500)
                            : const Icon(Icons.dark_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500)),
                    spaceW(width: 40),
                    Visibility(
                      visible: Responsive.isDesktop(context) && onChange != null,
                      child: SizedBox(
                          width: 400,
                          height: 55,
                          child: TextFieldWidget(
                            fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                            bottom: 0,
                            top: 0,
                            hintText: 'Search here...',
                            controller: controller.searchController.value,
                            onChanged: (String v) {
                              if (v.isEmpty) {
                                onChange(controller.searchController.value.text);
                              }
                            },
                            onSubmitted: (value) {
                              onChange(controller.searchController.value.text);
                            },
                            suffix: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: SizedBox(
                                width: 80,
                                child: InkWell(
                                  onTap: () {
                                    onChange(controller.searchController.value.text);
                                  },
                                  child: ContainerCustom(
                                    color: AppThemeData.crusta500,
                                    radius: 30,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    child: const TextCustom(title: 'Search', color: AppThemeData.white),
                                  ),
                                ),
                              ),
                            ),
                            prefix: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset('assets/icons/search.svg',
                                    fit: BoxFit.contain, color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood950)),
                          )),
                    ),
                  ],
                ),
              );
            }),
      ),
      actions: [
        spaceW(width: 15),
        isPOSTable ? SizedBox() : const ShoopingCartButton(),
        InkWell(
          onTap: () {
            notificationDialog(context, isDarkTheme: themeChange.getThem());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              height: 24,
              width: 24,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(AppThemeData.pickledBluewood500, BlendMode.srcIn),
            ),
          ),
        ),
        spaceW(width: 15),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: LanguagePopUp(),
        ),
        spaceW(width: 15),
        const ProfilePopUp(),
        spaceW(width: 15)
      ],
    );
  }

  static AppBar appBarMobileUI(BuildContext context, {Color? backgroundColor, bool? isPOSTable = false}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      backgroundColor: themeChange.getThem() ? backgroundColor ?? AppThemeData.black : backgroundColor ?? AppThemeData.white,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          scaffoldHomeKey.currentState!.openDrawer();
        },
        child: const ProfilePopUp(),
      ),
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
        isPOSTable == true ? SizedBox() : const ShoopingCartButton(),
        InkWell(
          onTap: () {
            notificationDialog(context, isDarkTheme: themeChange.getThem());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              height: 24,
              width: 24,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(AppThemeData.pickledBluewood500, BlendMode.srcIn),
            ),
          ),
        ),
        spaceW(width: Responsive.isMobile(context) ? 10 : 15),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: LanguagePopUp(),
        ),
        spaceW(width: Responsive.isMobile(context) ? 10 : 15),
      ],
    );
  }

  static Widget appMoblieUI(BuildContext context, {dynamic onChange, dynamic onSelectBranch}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return onChange == null && onSelectBranch == null
        ? const SizedBox()
        : GetBuilder(
            init: DashBoardController(),
            builder: (controller) {
              return ContainerCustom(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: onSelectBranch != null,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/icons/appbar_1.svg', height: 40, width: 40, fit: BoxFit.cover),
                            spaceW(),
                            BranchPopUp(onSelectBranch: onSelectBranch),
                            spaceW(width: 40),
                          ],
                        )),
                    Visibility(
                      visible: onChange != null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                            width: 400,
                            height: 55,
                            child: TextFieldWidget(
                              fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                              bottom: 0,
                              top: 0,
                              hintText: 'Search here...',
                              controller: controller.searchController.value,
                              onChanged: (String v) {
                                if (v.isEmpty) {
                                  onChange(controller.searchController.value.text);
                                }
                              },
                              onSubmitted: (value) {
                                onChange(controller.searchController.value.text);
                              },
                              suffix: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                child: SizedBox(
                                  width: 80,
                                  child: InkWell(
                                    onTap: () {
                                      onChange(controller.searchController.value.text);
                                    },
                                    child: ContainerCustom(
                                      color: AppThemeData.crusta500,
                                      radius: 30,
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      child: const TextCustom(title: 'Search', color: AppThemeData.white),
                                    ),
                                  ),
                                ),
                              ),
                              prefix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset('assets/icons/search.svg',
                                      fit: BoxFit.contain, color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood950)),
                            )),
                      ),
                    ),
                  ],
                ),
              );
            });
  }

  static notificationDialog(BuildContext context, {required bool isDarkTheme}) {
    Dialog alert = Dialog(
      // shadowColor: isDarkTheme ? AppThemeData.white : AppThemeData.black,
      backgroundColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GetX(
          init: NotificationController(),
          builder: (controller) {
            return SizedBox(
              width: Responsive.isMobile(context)
                  ? Responsive.width(95, context)
                  : Responsive.isDesktop(context)
                      ? Responsive.width(30, context)
                      : Responsive.width(60, context),
              child: Padding(
                padding: paddingEdgeInsets(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceH(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextCustom(title: 'Notification Center', fontSize: 16),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.close, size: 18, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                            ))
                      ],
                    ),
                    spaceH(height: 20),
                    Expanded(
                      child: controller.orderList.isEmpty || controller.isOrderoading.value
                          ? Constant.loaderWithNoFound(context, isLoading: controller.isOrderoading.value, isNotFound: controller.orderList.isEmpty)
                          : ListView.builder(
                              itemCount: controller.orderList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                OrderModel orderModel = controller.orderList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Responsive.isMobile(context)
                                      ? ContainerCustom(
                                          radius: 10,
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    TextCustom(
                                                      title: 'Order Id: ',
                                                      fontSize: 14,
                                                      letterSpacing: 1.2,
                                                      fontFamily: AppThemeData.bold,
                                                      color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                    ),
                                                    TextCustom(
                                                        title: Constant.orderId(orderId: orderModel.id.toString()),
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData.bold,
                                                        letterSpacing: 1.2,
                                                        color: AppThemeData.crusta500),
                                                  ]),
                                                  spaceH(),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.calendar_month, size: 15, color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                                      spaceW(),
                                                      TextCustom(
                                                          title: Constant.timestampToDateAndTime(orderModel.createdAt!),
                                                          letterSpacing: 0.4,
                                                          color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                          fontFamily: AppThemeData.medium)
                                                    ],
                                                  ),
                                                  if (orderModel.paymentStatus == true) spaceH(),
                                                  if (orderModel.paymentStatus == true)
                                                    Row(children: [
                                                      TextCustom(
                                                          title: 'Payment Type :',
                                                          letterSpacing: 0.4,
                                                          color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                          fontFamily: AppThemeData.medium),
                                                      spaceW(),
                                                      TextCustom(title: orderModel.paymentMethod ?? '', letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                                    ]),
                                                  spaceH(),
                                                  Row(children: [
                                                    TextCustom(
                                                        title: 'Order Type :',
                                                        letterSpacing: 0.4,
                                                        color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                        fontFamily: AppThemeData.medium),
                                                    spaceW(),
                                                    TextCustom(
                                                        title: orderModel.type == null ? '' : orderModel.type!.toUpperCase(), fontFamily: AppThemeData.medium, letterSpacing: 0.4)
                                                  ]),
                                                  Visibility(
                                                      visible: orderModel.tokenNo != null && orderModel.tokenNo!.isNotEmpty,
                                                      child: Column(children: [
                                                        spaceH(),
                                                        Row(children: [
                                                          TextCustom(
                                                              title: 'Token No :',
                                                              letterSpacing: 0.4,
                                                              color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                              fontFamily: AppThemeData.medium),
                                                          spaceW(),
                                                          TextCustom(title: "#${orderModel.tokenNo ?? ''}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                                        ])
                                                      ])),
                                                  spaceH(),
                                                  orderModel.tableId == null || orderModel.tableId!.isEmpty
                                                      ? const SizedBox()
                                                      : FutureBuilder<DiningTableModel?>(
                                                          future: FireStoreUtils.getDiningTableById(tableId: orderModel.tableId.toString()),
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
                                                                        color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
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
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  RoundedButtonFill(
                                                    radius: 8,
                                                    height: 30,
                                                    width: 100,
                                                    fontSizes: 14,
                                                    title: "View Order",
                                                    color: AppThemeData.crusta500,
                                                    textColor: AppThemeData.white,
                                                    isRight: false,
                                                    onPress: () {
                                                      Get.back();
                                                      controller.dashBoardController.changeView(screenType: "order");
                                                      OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                                      orderDetailsController.setOrderModel(orderModel);
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : ContainerCustom(
                                          radius: 10,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                child: NetworkImageWidget(
                                                  imageUrl: orderModel.product!.first.image.toString(),
                                                  placeHolderUrl: Constant.userPlaceholderURL,
                                                  fit: BoxFit.fill,
                                                  height: Responsive.width(4, context),
                                                  width: Responsive.width(4, context),
                                                ),
                                              ),
                                              spaceW(),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      TextCustom(
                                                        title: 'Order Id: ',
                                                        fontSize: 14,
                                                        letterSpacing: 1.2,
                                                        fontFamily: AppThemeData.bold,
                                                        color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                      ),
                                                      TextCustom(
                                                          title: Constant.orderId(orderId: orderModel.id.toString()),
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.bold,
                                                          letterSpacing: 1.2,
                                                          color: AppThemeData.crusta500),
                                                    ]),
                                                    spaceH(),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.calendar_month, size: 15, color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600),
                                                        spaceW(),
                                                        TextCustom(
                                                            title: Constant.timestampToDateAndTime(orderModel.createdAt!),
                                                            letterSpacing: 0.4,
                                                            color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                            fontFamily: AppThemeData.medium)
                                                      ],
                                                    ),
                                                    if (orderModel.paymentStatus == true) spaceH(),
                                                    if (orderModel.paymentStatus == true)
                                                      Row(children: [
                                                        TextCustom(
                                                            title: 'Payment Type :',
                                                            letterSpacing: 0.4,
                                                            color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                            fontFamily: AppThemeData.medium),
                                                        spaceW(),
                                                        TextCustom(title: orderModel.paymentMethod ?? '', letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                                      ]),
                                                    spaceH(),
                                                    Row(children: [
                                                      TextCustom(
                                                          title: 'Order Type :',
                                                          letterSpacing: 0.4,
                                                          color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                          fontFamily: AppThemeData.medium),
                                                      spaceW(),
                                                      TextCustom(
                                                          title: orderModel.type == null ? '' : orderModel.type!.toUpperCase(), fontFamily: AppThemeData.medium, letterSpacing: 0.4)
                                                    ]),
                                                    Visibility(
                                                        visible: orderModel.tokenNo != null && orderModel.tokenNo!.isNotEmpty,
                                                        child: Column(children: [
                                                          spaceH(),
                                                          Row(children: [
                                                            TextCustom(
                                                                title: 'Token No :',
                                                                letterSpacing: 0.4,
                                                                color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                                fontFamily: AppThemeData.medium),
                                                            spaceW(),
                                                            TextCustom(title: "#${orderModel.tokenNo ?? ''}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                                          ])
                                                        ])),
                                                    spaceH(),
                                                    orderModel.tableId == null || orderModel.tableId!.isEmpty
                                                        ? const SizedBox()
                                                        : FutureBuilder<DiningTableModel?>(
                                                            future: FireStoreUtils.getDiningTableById(tableId: orderModel.tableId.toString()),
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
                                                                          color: isDarkTheme ? AppThemeData.white : AppThemeData.pickledBluewood600,
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
                                              ),
                                              RoundedButtonFill(
                                                radius: 8,
                                                height: 38,
                                                width: 100,
                                                fontSizes: 14,
                                                title: "View Order",
                                                color: AppThemeData.crusta500,
                                                textColor: AppThemeData.white,
                                                isRight: false,
                                                onPress: () {
                                                  Get.back();
                                                  controller.dashBoardController.changeView(screenType: "order");
                                                  OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                                  orderDetailsController.setOrderModel(orderModel);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static newOrderDialog(BuildContext context, {required bool isDarkTheme, required OrderModel orderModel}) {
    Dialog alert = Dialog(
      // shadowColor: isDarkTheme ? AppThemeData.white : AppThemeData.black,
      backgroundColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: Responsive.isMobile(context)
            ? Responsive.width(95, context)
            : Responsive.isDesktop(context)
                ? Responsive.width(30, context)
                : Responsive.width(60, context),
        child: Padding(
          padding: paddingEdgeInsets(horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spaceH(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextCustom(title: '', fontSize: 16),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.close, size: 18, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                    ),
                  )
                ],
              ),
              spaceH(height: 20),
              Image.asset(
                "assets/images/order_gif.gif",
                width: 62,
                height: 62,
              ),
              spaceH(),
              const TextCustom(
                title: 'New Order Alert!',
                fontSize: 16,
                color: AppThemeData.pickledBluewood950,
              ),
              spaceH(),
              TextCustom(
                title: Constant.orderId(orderId: orderModel.id.toString()),
                fontSize: 16,
                color: AppThemeData.crusta500,
              ),
              spaceH(),
              RoundedButtonFill(
                radius: 8,
                height: 42,
                width: 160,
                fontSizes: 15,
                title: "View Order",
                color: AppThemeData.crusta500,
                textColor: AppThemeData.white,
                isRight: false,
                onPress: () {
                  Get.back();
                  DashBoardController dashBoardController = Get.find<DashBoardController>();
                  dashBoardController.changeView(screenType: "order");
                  OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                  orderDetailsController.setOrderModel(orderModel);
                },
              )
            ],
          ),
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ShoopingCartButton extends StatelessWidget {
  const ShoopingCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: PosController(),
        autoRemove: false,
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                if (controller.addToCart.value.product != null && controller.addToCart.value.product!.isNotEmpty) {
                  controller.calculateAddToCart();
                  addToCartDialog(context, themeChange.getThem());
                } else {
                  ShowToastDialog.showToast("Cart is empty");
                }
              },
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      "assets/icons/shopping_bag.svg",
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(AppThemeData.pickledBluewood500, BlendMode.srcIn),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: AppThemeData.crusta500,
                          child: TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontSize: 10)),
                    ),
                  ),
                ],
              ),
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
                      controller.selectedLng.value.image == null || controller.selectedLng.value.image!.isEmpty
                          ? const SizedBox()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30), child: Image.network(controller.selectedLng.value.image ?? '', height: 25, width: 25, fit: BoxFit.cover)),
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
                                e.image == null || e.image!.isEmpty
                                    ? const SizedBox()
                                    : ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.network(e.image ?? '', width: 20, height: 20)),
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

class ProfilePopUp extends StatelessWidget {
  const ProfilePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DashBoardController(),
        builder: (controller) {
          return SizedBox(
            child: Row(
              children: [
                if (Responsive.isMobile(context)) spaceW(width: 16),
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: NetworkImageWidget(
                        imageUrl: controller.user.value.profileImage ?? Constant.userPlaceholderURL, placeHolderUrl: Constant.userPlaceholderURL, height: 40, width: 40)),
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
                              Expanded(child: TextCustom(title: controller.user.value.name ?? '', fontSize: 15, fontFamily: AppThemeData.bold, maxLine: 1)),
                              SvgPicture.asset('assets/icons/down.svg',
                                  height: 20, width: 20, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                            ],
                          ),
                        ),
                        onSelected: (value) {
                          if (value == "Logout") {
                            Preferences.clearKeyData(Preferences.user);
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

class BranchPopUp extends StatefulWidget {
  final dynamic onSelectBranch;

  const BranchPopUp({super.key, this.onSelectBranch});

  @override
  State<BranchPopUp> createState() => _BranchPopUpState();
}

class _BranchPopUpState extends State<BranchPopUp> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: DashBoardController(),
        builder: (controller) {
          return Constant.allBranch.isEmpty
              ? const SizedBox()
              : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // SvgPicture.asset('assets/icons/down.svg', height: 20, width: 20, fit: BoxFit.cover),
                  const TextCustom(title: 'Branch', fontSize: 12, fontFamily: AppThemeData.bold),
                  PopupMenuButton<BranchModel>(
                      position: PopupMenuPosition.under,
                      child: SizedBox(
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: TextCustom(title: Constant.selectedBranch.name ?? '', fontSize: 15, fontFamily: AppThemeData.bold, maxLine: 1)),
                            SvgPicture.asset('assets/icons/down.svg',
                                height: 20, width: 20, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                          ],
                        ),
                      ),
                      onSelected: (BranchModel value) {
                        Constant.selectedBranch = value;
                        widget.onSelectBranch(value);
                        setState(() {});
                      },
                      itemBuilder: (BuildContext bc) {
                        return Constant.allBranch
                            .map((BranchModel element) => PopupMenuItem<BranchModel>(
                                  height: 30,
                                  value: element,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      element.name == Constant.selectedBranch.name
                                          ? const Icon(Icons.radio_button_checked_outlined, size: 20)
                                          : const Icon(Icons.circle_outlined, size: 20),
                                      const SizedBox(width: 10),
                                      TextCustom(
                                        title: element.name.toString(),
                                        maxLine: 1,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList();
                      }),
                ]);
        });
  }
}
