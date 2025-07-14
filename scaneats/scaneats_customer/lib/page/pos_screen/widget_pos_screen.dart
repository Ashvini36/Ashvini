// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/constant/show_toast_dialog.dart';
import 'package:scaneats_customer/controller/pos_controller.dart';
import 'package:scaneats_customer/model/item_category_model.dart';
import 'package:scaneats_customer/model/item_model.dart';
import 'package:scaneats_customer/model/offer_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/model/tax_model.dart';
import 'package:scaneats_customer/responsive/responsive.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/widget/common_ui.dart';
import 'package:scaneats_customer/widget/container_custom.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';
import 'package:scaneats_customer/widget/network_image_widget.dart';
import 'package:scaneats_customer/widget/rounded_button_fill.dart';
import 'package:scaneats_customer/widget/text_field_widget.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

class PosView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const PosView({super.key, this.crossAxisCount = 4, this.childAspectRatio = 1.5});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PosController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceH(height: 20),
                TextFieldWidget(
                  hintText: 'Search here...',
                  controller: controller.searchController.value,
                  onChanged: (v) {
                    Constant().debouncer.call(() {
                      controller.getAllItem(name: v.toString());
                    });
                  },
                  prefix: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/search.svg',
                          fit: BoxFit.contain, color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood950)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 36,
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return spaceW();
                        },
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.itemCategoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          ItemCategoryModel model = controller.itemCategoryList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.selectedCategory.value = model;
                              controller.getAllItem();
                              controller.update();
                            },
                            child: Chip(
                                backgroundColor: model.id == controller.selectedCategory.value.id
                                    ? AppThemeData.crusta500
                                    : themeChange.getThem()
                                        ? AppThemeData.black
                                        : AppThemeData.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: model.id == controller.selectedCategory.value.id
                                            ? AppThemeData.crusta500
                                            : themeChange.getThem()
                                                ? AppThemeData.pickledBluewood900
                                                : AppThemeData.pickledBluewood100),
                                    borderRadius: BorderRadius.circular(8)),
                                avatar: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: NetworkImageWidget(
                                      imageUrl: model.image ?? '',
                                      placeHolderUrl: Constant.placeholderURL,
                                      placeHolderFit: BoxFit.fill,
                                      fit: BoxFit.cover,
                                    )),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                label: TextCustom(
                                    title: model.name ?? '',
                                    fontFamily: AppThemeData.regular,
                                    color: model.id == controller.selectedCategory.value.id
                                        ? AppThemeData.white
                                        : themeChange.getThem()
                                            ? AppThemeData.pickledBluewood400
                                            : AppThemeData.pickledBluewood600)),
                          );
                        }),
                  ),
                ),
                spaceH(),
                if (controller.itemCategoryList.isNotEmpty)
                  Row(children: [
                    selectCatChip(
                        isSelectedItem: controller.selectFoodType.value == 'All',
                        name: 'All',
                        isDarkMode: themeChange.getThem(),
                        onClick: () {
                          controller.selectFoodType.value = 'All';
                          controller.getAllItem();
                        },
                        image: 'assets/icons/veg.svg'),
                    selectCatChip(
                        isSelectedItem: controller.selectFoodType.value == Constant.foodVeg,
                        name: Constant.foodVeg,
                        isDarkMode: themeChange.getThem(),
                        onClick: () {
                          controller.selectFoodType.value = Constant.foodVeg;
                          controller.getAllItem();
                        },
                        image: 'assets/icons/veg.svg'),
                    selectCatChip(
                        isSelectedItem: controller.selectFoodType.value == Constant.foodNonVeg,
                        name: Constant.foodNonVeg,
                        isDarkMode: themeChange.getThem(),
                        onClick: () {
                          controller.selectFoodType.value = Constant.foodNonVeg;
                          controller.getAllItem();
                        },
                        image: 'assets/icons/no_veg.svg'),
                  ]),
                spaceH(),
                if (controller.itemList.isNotEmpty)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const TextCustom(
                      title: 'All Item',
                      fontSize: 16,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              controller.selectItemView.value = 0;
                            },
                            child: SvgPicture.asset('assets/icons/layout_grid.svg',
                                height: 22,
                                width: 22,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(controller.selectItemView.value == 0 ? AppThemeData.crusta500 : AppThemeData.pickledBluewood400, BlendMode.srcIn))),
                        spaceW(),
                        GestureDetector(
                            onTap: () {
                              controller.selectItemView.value = 1;
                            },
                            child: SvgPicture.asset('assets/icons/layout_list.svg',
                                height: 22,
                                width: 22,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(controller.selectItemView.value == 1 ? AppThemeData.crusta500 : AppThemeData.pickledBluewood400, BlendMode.srcIn))),
                        spaceW(width: 8)
                      ],
                    )
                  ]),
                spaceH(),
                controller.itemList.isEmpty || controller.isItemLoading.value
                    ? SizedBox(
                        width: Responsive.width(100, context),
                        height: Responsive.height(50, context),
                        child: Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value, isNotFound: controller.itemList.isEmpty))
                    : controller.selectItemView.value == 0
                        ? Expanded(
                            child: GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: controller.itemList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  mainAxisExtent: Responsive.isMobile(context) ? 300 : 250,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisCount: crossAxisCount),
                              itemBuilder: (context, index) {
                                ItemModel model = controller.itemList[index];
                                return InkWell(
                                  onTap: () async {
                                    // Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": "E6d1t3Tx8WFiQ7QwrfKm"};

                                    // SendNotification.sendOneNotification(
                                    //   token: "cT-mGxENstLxjxknm5g5eY:APA91bH6RJt40f3XMDxs17W2b8YCDXyY3_I0mAoI2pLDwBDK2LDTq0IatBqkRV9WO12bhkjhxwK_Xd3d8iBI0r_-Vb5CgzkJGUo6zpFhfuSFvLzH9K7P8ULxrUQtVIrlGQ5--jHHsTwx",
                                    //   title: "New Order",
                                    //   body: "New Table Order Placed.",
                                    //   payload: playLoad,
                                    // );

                                    //
                                    await controller.productDetailInit(model);
                                    // ignore: use_build_context_synchronously
                                    productDetailsDialog(context, themeChange.getThem());
                                  },
                                  child: ContainerCustom(
                                      radius: 10,
                                      padding: const EdgeInsets.all(0),
                                      child: Column(children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                            child: NetworkImageWidget(
                                              imageUrl: model.image ?? '',
                                              placeHolderUrl: Constant.placeholderURL,
                                              placeHolderFit: BoxFit.fill,
                                              fit: BoxFit.cover,
                                              width: Responsive.width(100, context),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              TextCustom(title: model.name ?? ''),
                                              if (!Responsive.isMobile(context))
                                                Chip(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                    backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                    label: TextCustom(title: '+ Add', color: AppThemeData.crusta500)),
                                            ]),
                                            if (!Responsive.isMobile(context)) spaceH(height: 2),
                                            SingleChildScrollView(child: TextCustom(title: model.description ?? '', maxLine: 2, fontFamily: AppThemeData.regular, fontSize: 12)),
                                            if (!Responsive.isMobile(context)) spaceH(height: 2),
                                            TextCustom(title: Constant.amountShow(amount: model.price ?? '0'), fontSize: 16),
                                            if (Responsive.isMobile(context))
                                              Chip(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                  label: TextCustom(title: '+ Add', color: AppThemeData.crusta500)),
                                          ]),
                                        ),
                                      ])),
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => spaceH(),
                              shrinkWrap: true,
                              itemCount: controller.itemList.length,
                              itemBuilder: (context, index) {
                                ItemModel model = controller.itemList[index];
                                return InkWell(
                                  onTap: () async {
                                    await controller.productDetailInit(model);
                                    // ignore: use_build_context_synchronously
                                    productDetailsDialog(context, themeChange.getThem());
                                  },
                                  child: ContainerCustom(
                                      alignment: Alignment.centerLeft,
                                      radius: 10,
                                      padding: const EdgeInsets.all(0),
                                      child: Row(children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              NetworkImageWidget(
                                                imageUrl: model.image ?? '',
                                                placeHolderUrl: Constant.placeholderURL,
                                                placeHolderFit: BoxFit.fill,
                                                fit: BoxFit.cover,
                                                width: Responsive.isMobile(context) ? 120 : 200,
                                                height: 110,
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: model.itemType == Constant.foodVeg ? AppThemeData.forestGreen400 : Colors.red,
                                                      ),
                                                    ),
                                                    spaceW(width: 5),
                                                    TextCustom(
                                                      title: model.itemType == Constant.foodVeg ? Constant.foodVeg : Constant.foodNonVeg,
                                                      color: model.itemType == Constant.foodVeg ? AppThemeData.forestGreen400 : Colors.red,
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        spaceW(),
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: SizedBox(
                                              height: 110,
                                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TextCustom(title: model.name ?? ''),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                                      child: Chip(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                          backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                          label: TextCustom(title: '+ Add', color: AppThemeData.crusta500)),
                                                    )
                                                  ],
                                                ),
                                                SingleChildScrollView(
                                                    child: TextCustom(title: model.description ?? '', maxLine: 2, fontFamily: AppThemeData.regular, fontSize: 12)),
                                                TextCustom(title: Constant.amountShow(amount: model.price ?? '0'), fontSize: 16),
                                                spaceH(height: 5),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ])),
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

productDetailsDialog(BuildContext context, bool isDarkTheme) {
  Dialog alert = Dialog(
    shadowColor: isDarkTheme ? AppThemeData.white : AppThemeData.black,
    backgroundColor: isDarkTheme ? AppThemeData.black : AppThemeData.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: GetX(
        init: PosController(),
        builder: (controller) {
          return SizedBox(
            width: Responsive.width(
                Responsive.isMobile(context)
                    ? 90
                    : Responsive.isDesktop(context)
                        ? 40
                        : 60,
                context),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: paddingEdgeInsets(),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: Row(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  NetworkImageWidget(
                                      imageUrl: controller.productDetails.value.image ?? '',
                                      placeHolderUrl: Constant.placeholderURL,
                                      placeHolderFit: BoxFit.fill,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: controller.productDetails.value.itemType == Constant.foodVeg ? Colors.green : Colors.red,
                                          ),
                                        ),
                                        spaceW(width: 5),
                                        TextCustom(
                                          title: controller.productDetails.value.itemType == Constant.foodVeg ? Constant.foodVeg : Constant.foodNonVeg,
                                          color: controller.productDetails.value.itemType == Constant.foodVeg ? Colors.green : Colors.red,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          spaceW(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(title: controller.productDetails.value.name ?? '', fontSize: 18),
                                if (controller.productDetails.value.description != null)
                                  Wrap(
                                    children: [
                                      Text(controller.productDetails.value.description ?? '',
                                          maxLines: controller.isReadMore.value ? 10 : 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: AppThemeData.regular,
                                              color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                              fontSize: 14)),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          child: Text(
                                            controller.isReadMore.value ? "Read less" : "Read more",
                                            style: const TextStyle(color: AppThemeData.crusta400, fontFamily: AppThemeData.regular, fontSize: 12),
                                          ),
                                          onTap: () {
                                            controller.isReadMore.value = !controller.isReadMore.value;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                GetBuilder(
                                    init: PosController(),
                                    builder: (controller) {
                                      return TextCustom(title: Constant.amountShow(amount: controller.productDetails.value.price ?? '0'), fontSize: 16);
                                    }),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset("assets/icons/close.svg",
                            width: 18, height: 18, colorFilter: ColorFilter.mode(isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, BlendMode.srcIn)),
                      )
                    ]),
                  ),
                ),
                SizedBox(
                  height: 1,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: DashedLinePainter(),
                  ),
                ),
                Padding(
                  padding: paddingEdgeInsets(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(title: 'Quantity'),
                        spaceH(),
                        GetBuilder(
                            init: PosController(),
                            builder: (controller) {
                              return controller.productDetails.value.qty == 0
                                  ? InkWell(
                                      onTap: () {
                                        controller.productDetails.value.qty ??= 0;
                                        controller.productDetails.value.qty = controller.productDetails.value.qty! + 1;
                                        controller.update();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                        decoration: BoxDecoration(color: AppThemeData.crusta500, borderRadius: BorderRadius.circular(20)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                                          child: TextCustom(
                                            title: '+ Add',
                                            color: AppThemeData.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200, borderRadius: BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.productDetails.value.qty ??= 0;
                                              if (controller.productDetails.value.qty != 0) {
                                                controller.productDetails.value.qty = controller.productDetails.value.qty! - 1;
                                                controller.update();
                                              }
                                            },
                                            child: const TextCustom(
                                              title: '-',
                                              color: AppThemeData.tulipTree500,
                                              fontSize: 24,
                                            ),
                                          ),
                                          spaceW(width: 12),
                                          TextCustom(title: '${controller.productDetails.value.qty ?? 0}'),
                                          spaceW(width: 12),
                                          InkWell(
                                            onTap: () {
                                              controller.productDetails.value.qty ??= 0;
                                              controller.productDetails.value.qty = controller.productDetails.value.qty! + 1;
                                              controller.update();
                                            },
                                            child: const TextCustom(
                                              title: '+',
                                              color: AppThemeData.tulipTree500,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ));
                            }),
                        controller.productDetails.value.itemAttributes == null
                            ? Container()
                            : controller.productDetails.value.itemAttributes!.attributes!.isEmpty
                                ? Container()
                                : GetBuilder(
                                    init: PosController(),
                                    builder: (controller) {
                                      return ListView.builder(
                                        itemCount: controller.productDetails.value.itemAttributes!.attributes?.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          String title = "";
                                          for (var element in controller.itemAttributeList) {
                                            if (controller.productDetails.value.itemAttributes!.attributes![index].attributesId == element.id) {
                                              title = element.name.toString();
                                            }
                                          }
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              spaceH(height: 15),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                                child: TextCustom(title: title),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                                child: Wrap(
                                                  spacing: 6.0,
                                                  runSpacing: 6.0,
                                                  children: List.generate(
                                                    controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions!.length,
                                                    (i) {
                                                      return GestureDetector(
                                                          onTap: () async {
                                                            if (controller.selectedIndexVariants.where((element) => element.contains('$index _')).isEmpty) {
                                                              controller.selectedVariants.insert(
                                                                  index, controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString());
                                                              controller.selectedIndexVariants.add(
                                                                  '$index _${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString()}');
                                                              controller.selectedIndexArray.add('${index}_$i');
                                                            } else {
                                                              controller.selectedIndexArray.remove(
                                                                  '${index}_${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions?.indexOf(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first.replaceAll('$index _', ''))}');
                                                              controller.selectedVariants.removeAt(index);
                                                              controller.selectedIndexVariants
                                                                  .remove(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first);
                                                              controller.selectedVariants.insert(
                                                                  index, controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString());
                                                              controller.selectedIndexVariants.add(
                                                                  '$index _${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString()}');
                                                              controller.selectedIndexArray.add('${index}_$i');
                                                            }

                                                            if (controller.productDetails.value.itemAttributes!.variants!
                                                                .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                                .isNotEmpty) {
                                                              controller.productDetails.value.price = controller.productDetails.value.itemAttributes!.variants!
                                                                      .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                                      .first
                                                                      .variantPrice ??
                                                                  '0';
                                                              controller.productDetails.value.variantId = controller.productDetails.value.itemAttributes!.variants!
                                                                      .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                                      .first
                                                                      .variantId ??
                                                                  '';
                                                              controller.productDetails.value.disPrice = '0';
                                                            }

                                                            controller.update();
                                                          },
                                                          child: buildChip(
                                                              label: controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString(),
                                                              isSelected: controller.selectedVariants
                                                                      .contains(controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString())
                                                                  ? true
                                                                  : false,
                                                              isDarkMode: isDarkTheme));
                                                    },
                                                  ).toList(),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    }),
                        Visibility(
                          // ignore: unnecessary_null_comparison
                          visible: controller.productDetails.value != null,
                          child: controller.productDetails.value.addons!.isEmpty
                              ? const SizedBox()
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      spaceH(height: 20),
                                      const TextCustom(title: 'Add on'),
                                      spaceH(),
                                      SizedBox(
                                        height: 80,
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.productDetails.value.addons!.length,
                                            separatorBuilder: (context, index) {
                                              return spaceW();
                                            },
                                            itemBuilder: (BuildContext context, int i) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                                                    borderRadius: BorderRadius.circular(10)),
                                                height: 80,
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                        child: Stack(
                                                          children: [
                                                            NetworkImageWidget(
                                                                imageUrl: controller.productDetails.value.addons![i].image ?? '',
                                                                height: 80,
                                                                width: 100,
                                                                placeHolderFit: BoxFit.fill,
                                                                fit: BoxFit.cover,
                                                                placeHolderUrl: Constant.placeholderURL),
                                                            Positioned(
                                                              top: 10,
                                                              right: 10,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 10,
                                                                    height: 10,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      color: controller.productDetails.value.itemType == Constant.foodVeg ? Colors.green : Colors.red,
                                                                    ),
                                                                  ),
                                                                  spaceW(width: 5),
                                                                  TextCustom(
                                                                    title: controller.productDetails.value.itemType == Constant.foodVeg ? Constant.foodVeg : Constant.foodNonVeg,
                                                                    color: controller.productDetails.value.itemType == Constant.foodVeg ? Colors.green : Colors.red,
                                                                    fontSize: 12,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    spaceW(),
                                                    SizedBox(
                                                      width: 200,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          spaceH(height: 5),
                                                          Row(
                                                            children: [
                                                              TextCustom(title: controller.productDetails.value.addons![i].name ?? '', fontFamily: AppThemeData.regular),
                                                              spaceW(),
                                                              TextCustom(title: Constant.amountShow(amount: controller.productDetails.value.addons![i].price ?? '0')),
                                                            ],
                                                          ),
                                                          spaceH(),
                                                          GetBuilder(
                                                              init: PosController(),
                                                              builder: (controller) {
                                                                return Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                                                                    decoration: BoxDecoration(
                                                                        color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                                                        borderRadius: BorderRadius.circular(20)),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            if (controller.productDetails.value.addons![i].qty == null) {
                                                                              controller.productDetails.value.addons![i].qty = 0;
                                                                            }
                                                                            if (controller.productDetails.value.addons![i].qty != 0) {
                                                                              controller.productDetails.value.addons![i].qty = controller.productDetails.value.addons![i].qty! - 1;
                                                                            }
                                                                            controller.update();
                                                                          },
                                                                          child: const TextCustom(
                                                                            title: '-',
                                                                            color: AppThemeData.tulipTree500,
                                                                            fontSize: 20,
                                                                          ),
                                                                        ),
                                                                        spaceW(),
                                                                        TextCustom(title: '${controller.productDetails.value.addons![i].qty ?? 0}'),
                                                                        spaceW(),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            if (controller.productDetails.value.addons![i].qty == null) {
                                                                              controller.productDetails.value.addons![i].qty = 0;
                                                                            }
                                                                            controller.productDetails.value.addons![i].qty = controller.productDetails.value.addons![i].qty! + 1;
                                                                            controller.update();
                                                                          },
                                                                          child: const TextCustom(
                                                                            title: '+',
                                                                            color: AppThemeData.tulipTree500,
                                                                            fontSize: 20,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ));
                                                              }),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                        spaceH(height: 20),
                        const TextCustom(title: 'Special Instructions'),
                        spaceH(),
                        TextFieldWidget(
                          hintText: 'Instructions',
                          fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                          controller: controller.specialInstruController.value,
                        ),
                        spaceH(height: 10),
                        if (Responsive.isMobile(context))
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (controller.productDetails.value.qty != 0) {
                                    controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                    if (controller.addToCart.value.product == null) {
                                      controller.addToCart.value = OrderModel(product: []);
                                    }

                                    if (controller.addToCart.value.product!
                                        .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                        .isNotEmpty) {
                                      print("same");
                                      controller.addToCart.value
                                              .product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                          ItemModel.fromJson(controller.productDetails.value.toJson());
                                    } else {
                                      print("Not same");
                                      controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                    }
                                    controller.calculateAddToCart();
                                    await Constant.setOrderData(controller.addToCart.value);

                                    Get.back();
                                  } else {
                                    ShowToastDialog.showToast("Please Select At least One Qty.");
                                  }
                                },
                                child: GetBuilder(
                                    init: PosController(),
                                    builder: (controller) {
                                      return SizedBox(
                                        height: 48,
                                        child: ContainerCustom(
                                          color: AppThemeData.crusta500,
                                          child: Row(
                                            children: [
                                              const Expanded(child: TextCustom(title: 'Add To Cart', color: AppThemeData.white, fontSize: 15)),
                                              spaceW(width: 5),
                                              const Icon(Icons.shopping_bag_outlined, color: AppThemeData.white, size: 25),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              spaceH(),
                              InkWell(
                                onTap: () async {
                                  if (controller.productDetails.value.qty != 0) {
                                    controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                    if (controller.addToCart.value.product == null) {
                                      controller.addToCart.value = OrderModel(product: []);
                                    }

                                    if (controller.addToCart.value.product!
                                        .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                        .isNotEmpty) {
                                      print("same");
                                      controller.addToCart.value
                                              .product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                          ItemModel.fromJson(controller.productDetails.value.toJson());
                                    } else {
                                      print("Not same");
                                      controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                    }
                                    controller.calculateAddToCart();
                                    await Constant.setOrderData(controller.addToCart.value);
                                    Get.back();
                                    if (Responsive.isMobile(context)) {
                                      Get.to(const AddToCartMoblieView());
                                    } else {
                                      addToCartDialog(context, isDarkTheme);
                                    }
                                  } else {
                                    ShowToastDialog.showToast("Please Select At least One Qty.");
                                  }
                                },
                                child: GetBuilder(
                                    init: PosController(),
                                    builder: (controller) {
                                      return SizedBox(
                                        height: 48,
                                        child: ContainerCustom(
                                          color: const Color(0xff10A944),
                                          child: Row(
                                            children: [
                                              const Expanded(child: TextCustom(title: 'View Cart', color: AppThemeData.white, fontSize: 15)),
                                              TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontFamily: AppThemeData.medium),
                                              spaceW(width: 5),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        if (!Responsive.isMobile(context))
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if (controller.productDetails.value.qty != 0) {
                                      controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                      if (controller.addToCart.value.product == null) {
                                        controller.addToCart.value = OrderModel(product: []);
                                      }

                                      if (controller.addToCart.value.product!
                                          .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                          .isNotEmpty) {
                                        print("same");
                                        controller.addToCart.value
                                                .product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                            ItemModel.fromJson(controller.productDetails.value.toJson());
                                      } else {
                                        print("Not same");
                                        controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                      }
                                      controller.calculateAddToCart();
                                      await Constant.setOrderData(controller.addToCart.value);

                                      Get.back();
                                    } else {
                                      ShowToastDialog.showToast("Please Select At least One Qty.");
                                    }
                                  },
                                  child: GetBuilder(
                                      init: PosController(),
                                      builder: (controller) {
                                        return SizedBox(
                                          height: 48,
                                          child: ContainerCustom(
                                            color: AppThemeData.crusta500,
                                            child: Row(
                                              children: [
                                                const Expanded(child: TextCustom(title: 'Add To Cart', color: AppThemeData.white, fontSize: 15)),
                                                spaceW(width: 5),
                                                const Icon(Icons.shopping_bag_outlined, color: AppThemeData.white, size: 25),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              spaceW(),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if (controller.productDetails.value.qty != 0) {
                                      controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                      if (controller.addToCart.value.product == null) {
                                        controller.addToCart.value = OrderModel(product: []);
                                      }

                                      if (controller.addToCart.value.product!
                                          .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                          .isNotEmpty) {
                                        print("same");
                                        controller.addToCart.value
                                                .product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                            ItemModel.fromJson(controller.productDetails.value.toJson());
                                      } else {
                                        print("Not same");
                                        controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                      }
                                      controller.calculateAddToCart();
                                      await Constant.setOrderData(controller.addToCart.value);
                                      Get.back();
                                      if (Responsive.isMobile(context)) {
                                        Get.to(const AddToCartMoblieView());
                                      } else {
                                        addToCartDialog(context, isDarkTheme);
                                      }
                                    } else {
                                      ShowToastDialog.showToast("Please Select At least One Qty.");
                                    }
                                  },
                                  child: GetBuilder(
                                      init: PosController(),
                                      builder: (controller) {
                                        return SizedBox(
                                          height: 48,
                                          child: ContainerCustom(
                                            color: const Color(0xff10A944),
                                            child: Row(
                                              children: [
                                                const Expanded(child: TextCustom(title: 'View Cart', color: AppThemeData.white, fontSize: 15)),
                                                TextCustom(
                                                    title: Constant.amountShow(
                                                        amount:
                                                            '${((double.parse(controller.addToCart.value.subtotal ?? '0') - double.parse(controller.productDetails.value.disPrice ?? '0')))}'),
                                                    color: AppThemeData.white),
                                                spaceW(width: 5),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        spaceH(height: 20)
                      ],
                    ),
                  ),
                ),
              ]),
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

addToCartDialog(BuildContext context, bool isDarkTheme) {
  Dialog alert = Dialog(
    shadowColor: isDarkTheme ? AppThemeData.white : AppThemeData.black,
    backgroundColor: isDarkTheme ? AppThemeData.black : AppThemeData.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: GetX(
        init: PosController(),
        builder: (controller) {
          return SizedBox(
            width: Responsive.isMobile(context)
                ? Responsive.width(95, context)
                : Responsive.isDesktop(context)
                    ? Responsive.width(40, context)
                    : Responsive.width(60, context),
            child: Padding(
              padding: paddingEdgeInsets(horizontal: 18),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  spaceH(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextCustom(title: 'Cart Details', fontSize: 16),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SvgPicture.asset("assets/icons/close.svg",
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, BlendMode.srcIn)),
                          ))
                    ],
                  ),
                  spaceH(height: 20),
                  if (controller.addToCart.value.product != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        child: GetBuilder(
                            init: PosController(),
                            builder: (controller) {
                              return DataTable(
                                  horizontalMargin: 12,
                                  columnSpacing: 30,
                                  dataRowMaxHeight: 70,
                                  border: TableBorder.all(
                                    color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  headingRowColor: MaterialStateColor.resolveWith((states) => isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                  columns: [
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? Responsive.width(28, context) : Responsive.width(14, context),
                                            child: const TextCustom(title: 'Items'))),
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? Responsive.width(12, context) : Responsive.width(10, context),
                                            child: const TextCustom(title: 'Qty'))),
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? Responsive.width(12, context) : Responsive.width(10, context),
                                            child: const TextCustom(title: 'Price'))),
                                  ],
                                  rows: controller.addToCart.value.product!.map((e) {
                                    var productAmount = double.parse(e.price!) * e.qty!;
                                    var addonAmount = e.addons!.isNotEmpty ? e.addons!.fold(0.0, (sum, item) => sum + item.qty!.toDouble() * double.parse(item.price!)) : 0.0;
                                    String totalCost = (productAmount + addonAmount).toString();
                                    double totalAddonPrice = 0.0;
                                    if (e.addons != null)
                                      for (var element in e.addons!) {
                                        totalAddonPrice += double.parse(element.price!);
                                      }
                                    return DataRow(cells: [
                                      DataCell(
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  controller.addToCart.value.product!.removeAt(controller.addToCart.value.product!.indexOf(e));
                                                  controller.calculateAddToCart();
                                                  controller.update();
                                                  await Constant.setOrderData(controller.addToCart.value);

                                                  if (controller.addToCart.value.product == null || controller.addToCart.value.product!.isEmpty) {
                                                    Get.back();
                                                  }
                                                },
                                                child: SvgPicture.asset('assets/icons/delete_Icon.svg', height: 16, width: 16, fit: BoxFit.cover)),
                                            spaceW(),
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(30),
                                                child: NetworkImageWidget(
                                                    imageUrl: e.image ?? '',
                                                    placeHolderFit: BoxFit.fill,
                                                    fit: BoxFit.cover,
                                                    placeHolderUrl: Constant.placeholderURL,
                                                    height: 30,
                                                    width: 30)),
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
                                                    Flexible(
                                                      child: SingleChildScrollView(
                                                        child: Column(
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
                                                                .toList()),
                                                      ),
                                                    ),
                                                  if (e.addons!.isNotEmpty)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200, borderRadius: BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  e.qty ??= 0;
                                                  if (e.qty != 1) {
                                                    e.qty = e.qty! - 1;
                                                  }
                                                  controller.calculateAddToCart();
                                                },
                                                child: const TextCustom(
                                                  title: '-',
                                                  color: AppThemeData.tulipTree500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              spaceW(),
                                              TextCustom(title: '${e.qty ?? 0}'),
                                              spaceW(),
                                              InkWell(
                                                onTap: () {
                                                  e.qty ??= 0;
                                                  e.qty = e.qty! + 1;
                                                  controller.calculateAddToCart();
                                                },
                                                child: const TextCustom(
                                                  title: '+',
                                                  color: AppThemeData.tulipTree500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ))),
                                      DataCell(TextCustom(title: Constant.amountShow(amount: totalCost))),
                                    ]);
                                  }).toList());
                            }),
                      ),
                    ),
                  spaceH(height: 20),
                  TextFieldWidget(
                    prefix: controller.isOfferApply.value ? const Icon(Icons.check_circle, color: Colors.green) : const SizedBox(),
                    hintText: 'Enter coupon code',
                    fillColor: isDarkTheme ? AppThemeData.pickledBluewood800 : AppThemeData.pickledBluewood200,
                    controller: controller.couponCodeText.value,
                    textAlign: TextAlign.center,
                    suffix: InkWell(
                      onTap: () async {
                        controller.offerModel.value = OfferModel();
                        controller.isOfferApply.value = false;
                        controller.update();
                        if (controller.couponCodeText.value.text != '') {
                          await controller.getOfferData();
                        } else {
                          controller.calculateAddToCart();
                          ShowToastDialog.showToast("Please Enter Valid Coupon Code.");
                        }
                      },
                      child: Container(
                        width: 90,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Color(0xff736CE8), borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                        child: const TextCustom(title: "Apply", color: AppThemeData.white),
                      ),
                    ),
                  ),
                  spaceH(height: 10),
                  if (controller.addToCart.value.product != null)
                    GetBuilder(
                        init: PosController(),
                        builder: (controller) {
                          return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkTheme == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                                    spaceH(height: 8),
                                    labelData(label: 'Sub Total', value: Constant.amountShow(amount: '${controller.addToCart.value.subtotal ?? 0}')),
                                    spaceH(height: 8),
                                    labelData(label: 'Discount', value: Constant.amountShow(amount: controller.addToCart.value.discount.toString())),
                                    spaceH(height: 5),
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
                                                    amount: Constant().calculateTax(taxModel: taxModel, amount: controller.addToCart.value.subtotal.toString()).toString())),
                                          );
                                        }),
                                    spaceH(height: 5)
                                  ]),
                                ),
                                devider(context, color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                                        border: Border.all(color: isDarkTheme == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                    child: labelData(
                                        label: 'Total', value: Constant.amountShow(amount: controller.addToCart.value.total.toString()), textColor: AppThemeData.crusta500)),
                              ]));
                        }),
                  spaceH(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButtonFill(
                          radius: 8,
                          height: 45,
                          fontSizes: 15,
                          title: "Cancel",
                          color: const Color(0xffEB4848),
                          textColor: AppThemeData.white,
                          isRight: false,
                          onPress: () {
                            Get.back();
                          },
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        child: RoundedButtonFill(
                          radius: 8,
                          height: 45,
                          fontSizes: 15,
                          title: "Order",
                          color: const Color(0xff10A944),
                          textColor: AppThemeData.white,
                          isRight: false,
                          onPress: () {
                            if (int.parse(Constant.restaurantModel.subscription?.noOfOrders ?? '0') > controller.orderList.length) {
                              controller.orderPlace(context, controller.addToCart.value.total ?? '0.0');
                            } else {
                              ShowToastDialog.showToast("Your subscription has reached its maximum limit. Please consider extending it to continue accessing our services.");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ]),
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

Widget labelData({required String label, String? value, Widget? widget, Color? textColor}) {
  return Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: TextCustom(title: label, color: textColor)),
    Visibility(
        visible: value != null,
        child: Expanded(
            child: TextCustom(
          title: value ?? '',
          textAlign: TextAlign.end,
          maxLine: 4,
          color: textColor ?? AppThemeData.pickledBluewood500,
          fontFamily: AppThemeData.regular,
        ))),
    Visibility(visible: widget != null, child: Expanded(child: widget ?? const Text('')))
  ]);
}

class AddToCartMoblieView extends StatelessWidget {
  const AddToCartMoblieView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: CommonUI.appBarUI(context),
      body: GetBuilder(
          init: PosController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceH(height: 10),
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
                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.black, BlendMode.srcIn),
                        ),
                        spaceW(width: 5),
                        TextCustom(
                          title: 'My Cart',
                          fontSize: 18,
                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                        ),
                      ]),
                    ),
                    spaceH(height: 15),
                    controller.addToCart.value.product == null
                        ? SizedBox(
                            width: Responsive.width(100, context),
                            height: Responsive.height(48, context),
                            child: Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value, isNotFound: controller.addToCart.value.product?.isEmpty ?? false))
                        : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: devider(context, height: 1, color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100));
                            },
                            itemBuilder: (context, index) {
                              ItemModel model = controller.addToCart.value.product![index];
                              double totalAddonPrice = 0.0;
                              if (model.addons != null)
                                for (var element in model.addons!) {
                                  totalAddonPrice += double.parse(element.price!);
                                }

                              return InkWell(
                                onTap: () async {
                                  await controller.productDetailInit(model);
                                  // ignore: use_build_context_synchronously
                                  productDetailsDialog(context, themeChange.getThem());
                                },
                                child: Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      children: [
                                        NetworkImageWidget(imageUrl: model.image ?? '', fit: BoxFit.cover, height: 100, width: 85, placeHolderUrl: Constant.placeholderURL),
                                        Positioned(
                                          top: 10,
                                          right: 6,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: controller.productDetails.value.itemType == Constant.foodVeg ? Colors.green : Colors.red,
                                                ),
                                              ),
                                              spaceW(width: 5),
                                              TextCustom(
                                                title: controller.productDetails.value.itemType == Constant.foodVeg ? Constant.foodVeg : Constant.foodNonVeg,
                                                color: controller.productDetails.value.itemType == Constant.foodVeg ? Colors.green : Colors.red,
                                                fontSize: 10,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  spaceW(),
                                  Expanded(
                                    child: SizedBox(
                                      height: 100,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              TextCustom(title: model.name?.trim() ?? '', textAlign: TextAlign.center),
                                              spaceW(width: 5),
                                              model.itemAttributes != null
                                                  ? SizedBox(
                                                      height: 20,
                                                      child: TextCustom(
                                                          fontFamily: AppThemeData.regular,
                                                          title:
                                                              "(${model.itemAttributes!.variants!.firstWhere((element) => element.variantId == model.variantId).variantSku.toString().trim()})",
                                                          maxLine: 3,
                                                          fontSize: 12),
                                                    )
                                                  : const SizedBox()
                                            ]),
                                            InkWell(
                                                onTap: () async {
                                                  controller.addToCart.value.product!.removeAt(index);
                                                  controller.update();
                                                  await Constant.setOrderData(controller.addToCart.value);
                                                  controller.calculateAddToCart();
                                                },
                                                child: SvgPicture.asset('assets/icons/delete_Icon.svg', height: 20, width: 20, fit: BoxFit.cover)),
                                          ],
                                        ),
                                        if (model.addons!.isNotEmpty)
                                          Flexible(
                                            child: SingleChildScrollView(
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
                                            GetBuilder(
                                                init: PosController(),
                                                builder: (controller) {
                                                  return Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              model.qty ??= 0;
                                                              if (model.qty != 1) {
                                                                model.qty = model.qty! - 1;
                                                              }
                                                              controller.calculateAddToCart();
                                                            },
                                                            child: const TextCustom(
                                                              title: '-',
                                                              color: AppThemeData.tulipTree500,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          spaceW(),
                                                          TextCustom(title: '${model.qty ?? 0}'),
                                                          spaceW(),
                                                          InkWell(
                                                            onTap: () {
                                                              model.qty ??= 0;
                                                              model.qty = model.qty! + 1;
                                                              controller.calculateAddToCart();
                                                            },
                                                            child: const TextCustom(
                                                              title: '+',
                                                              color: AppThemeData.tulipTree500,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                }),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ),
                                ]),
                              );
                            },
                            itemCount: controller.addToCart.value.product!.length,
                          ),
                    spaceH(height: 15),
                    TextFieldWidget(
                      prefix: controller.isOfferApply.value ? const Icon(Icons.check_circle, color: Colors.green) : const SizedBox(),
                      hintText: 'Enter coupon code',
                      fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood800 : AppThemeData.pickledBluewood200,
                      controller: controller.couponCodeText.value,
                      textAlign: TextAlign.center,
                      suffix: InkWell(
                        onTap: () async {
                          controller.offerModel.value = OfferModel();
                          controller.isOfferApply.value = false;
                          controller.update();
                          if (controller.couponCodeText.value.text != '') {
                            await controller.getOfferData();
                          } else {
                            controller.calculateAddToCart();
                            ShowToastDialog.showToast("Please Enter Valid Coupon Code.");
                          }
                        },
                        child: Container(
                          width: 90,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: Color(0xff736CE8), borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                          child: const TextCustom(title: "Apply", color: AppThemeData.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Padding(
                          padding: paddingEdgeInsets(),
                          child: Column(children: [
                            labelData(label: 'Sub Total', value: Constant.amountShow(amount: '${controller.addToCart.value.subtotal ?? 0}')),
                            spaceH(height: 20),
                            labelData(label: 'Discount', value: Constant.amountShow(amount: controller.addToCart.value.discount ?? '0.0')),
                            spaceH(height: 20),
                            ListView.builder(
                                itemCount: Constant.taxList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  TaxModel taxModel = Constant.taxList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: labelData(
                                        label:
                                            '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
                                        value: Constant.amountShow(
                                            amount: Constant().calculateTax(taxModel: taxModel, amount: controller.addToCart.value.subtotal ?? '0.0').toString())),
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
                              child: labelData(label: 'Total', value: Constant.amountShow(amount: controller.addToCart.value.total ?? '0.0'), textColor: AppThemeData.crusta500),
                            )),
                      ]),
                    ),
                    spaceH(height: 15),
                    InkWell(
                      onTap: () {
                        if (int.parse(Constant.restaurantModel.subscription!.noOfOrders.toString()) > controller.orderList.length) {
                          Get.to(const OrderDetailsMoblieView());
                        } else {
                          ShowToastDialog.showToast("Your subscription has reached its maximum limit. Please consider extending it to continue accessing our services.");
                        }
                      },
                      child: ContainerCustom(
                        color: AppThemeData.forestGreen400,
                        child: Row(children: [
                          const Expanded(
                            child: TextCustom(title: 'Proceed to order'),
                          ),
                          Row(children: [
                            TextCustom(title: Constant.amountShow(amount: '${controller.addToCart.value.total ?? 0}')),
                            spaceW(),
                            SvgPicture.asset('assets/icons/arrow_right.svg',
                                height: 20, width: 20, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                          ])
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class OrderDetailsMoblieView extends StatelessWidget {
  const OrderDetailsMoblieView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: CommonUI.appBarUI(context),
      body: GetBuilder(
          init: PosController(),
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
                        const TextCustom(title: 'Order Details', fontSize: 18),
                      ]),
                    ),
                    spaceH(height: 15),
                    ContainerCustom(
                        alignment: Alignment.centerLeft,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const TextCustom(
                            title: 'Table',
                            fontFamily: AppThemeData.medium,
                            fontSize: 16,
                          ),
                          spaceH(),
                          TextCustom(title: controller.diningTableModel.value.name.toString(), fontFamily: AppThemeData.medium, fontSize: 15)
                        ])),
                    spaceH(),
                    // if (Constant.paymentModel != null)
                    //   ContainerCustom(
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const TextCustom(title: 'Payment Method', fontFamily: AppThemeData.medium, fontSize: 16),
                    //         spaceH(),
                    //         InkWell(
                    //           onTap: () {
                    //             showDialog(context: context, builder: (ctxt) => const PaymentDialog());
                    //           },
                    //           child: TextFieldWidget(
                    //             hintText: 'Select Payment Method',
                    //             controller: controller.paymentController.value,
                    //             enable: false,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    spaceH(),
                    ContainerCustom(
                        child: controller.addToCart.value.product == null
                            ? SizedBox(
                                width: Responsive.width(100, context),
                                height: Responsive.height(48, context),
                                child: Constant.loaderWithNoFound(context,
                                    isLoading: controller.isItemLoading.value, isNotFound: controller.addToCart.value.product?.isEmpty ?? false))
                            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const TextCustom(title: 'Cart Summary', fontFamily: AppThemeData.medium, fontSize: 16),
                                spaceH(height: 15),
                                ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: devider(context, height: 2));
                                  },
                                  itemBuilder: (context, index) {
                                    ItemModel model = controller.addToCart.value.product![index];
                                    double totalAddonPrice = 0.0;
                                    if (model.addons != null)
                                      for (var element in model.addons!) {
                                        totalAddonPrice += double.parse(element.price!);
                                      }
                                    return InkWell(
                                      onTap: () async {
                                        await controller.productDetailInit(model);
                                        // ignore: use_build_context_synchronously
                                        productDetailsDialog(context, themeChange.getThem());
                                      },
                                      child: SizedBox(
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
                                              InkWell(
                                                  onTap: () async {
                                                    controller.addToCart.value.product!.removeAt(index);
                                                    controller.update();
                                                    await Constant.setOrderData(controller.addToCart.value);
                                                    controller.calculateAddToCart();
                                                  },
                                                  child: SvgPicture.asset('assets/icons/delete_Icon.svg', height: 20, width: 20, fit: BoxFit.cover)),
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
                                              GetBuilder(
                                                  init: PosController(),
                                                  builder: (controller) {
                                                    return Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                                            borderRadius: BorderRadius.circular(20)),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                model.qty ??= 0;
                                                                if (model.qty != 0) {
                                                                  model.qty = model.qty! - 1;
                                                                }
                                                                controller.calculateAddToCart();
                                                              },
                                                              child: const TextCustom(
                                                                title: '-',
                                                                color: AppThemeData.tulipTree500,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            spaceW(),
                                                            TextCustom(title: '${model.qty ?? 0}'),
                                                            spaceW(),
                                                            InkWell(
                                                              onTap: () {
                                                                model.qty ??= 0;
                                                                model.qty = model.qty! + 1;
                                                                controller.calculateAddToCart();
                                                              },
                                                              child: const TextCustom(
                                                                title: '+',
                                                                color: AppThemeData.tulipTree500,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        ));
                                                  }),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                  itemCount: controller.addToCart.value.product!.length,
                                ),
                              ])),
                    spaceH(),
                    ContainerCustom(
                      padding: EdgeInsets.zero,
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Padding(
                          padding: paddingEdgeInsets(),
                          child: Column(children: [
                            labelData(label: 'Sub Total', value: Constant.amountShow(amount: '${controller.addToCart.value.subtotal ?? 0}')),
                            spaceH(height: 20),
                            labelData(label: 'Discount', value: Constant.amountShow(amount: controller.addToCart.value.discount ?? '0.0')),
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
                                            amount: Constant().calculateTax(taxModel: taxModel, amount: controller.addToCart.value.subtotal ?? '0.0').toString())),
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
                              child: labelData(label: 'Total', value: Constant.amountShow(amount: controller.addToCart.value.total ?? '0.0'), textColor: AppThemeData.crusta500),
                            )),
                      ]),
                    ),
                    spaceH(height: 15),
                    InkWell(
                      onTap: () {
                        log("Process to Place Order :: 11");
                        controller.orderPlace(context, controller.addToCart.value.total ?? '0.0');
                      },
                      child: ContainerCustom(
                        color: AppThemeData.forestGreen400,
                        child: Row(children: [
                          const Expanded(
                            child: TextCustom(title: 'Process to Place Order'),
                          ),
                          Row(children: [
                            TextCustom(title: Constant.amountShow(amount: '${controller.addToCart.value.total ?? 0}')),
                            spaceW(),
                            SvgPicture.asset('assets/icons/arrow_right.svg',
                                height: 20, width: 20, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                          ])
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Widget selectCatChip({required bool isDarkMode, required dynamic onClick, required bool isSelectedItem, required String name, required String image}) {
  return GestureDetector(
    onTap: onClick,
    child: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Chip(
          backgroundColor: isSelectedItem
              ? AppThemeData.forestGreen400
              : isDarkMode
                  ? AppThemeData.black
                  : AppThemeData.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: isSelectedItem
                      ? AppThemeData.forestGreen400
                      : isDarkMode
                          ? AppThemeData.pickledBluewood900
                          : AppThemeData.pickledBluewood100),
              borderRadius: BorderRadius.circular(20)),
          avatar: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SvgPicture.asset(
                image,
                width: 25,
                height: 25,
              )),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          label: TextCustom(
              title: name.capitalizeText(),
              fontFamily: AppThemeData.regular,
              color: isSelectedItem
                  ? AppThemeData.white
                  : isDarkMode
                      ? AppThemeData.pickledBluewood400
                      : AppThemeData.pickledBluewood600)),
    ),
  );
}

// class OrderDetailsScreenView extends StatelessWidget {
//   const OrderDetailsScreenView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     // ignore: deprecated_member_use
//     return WillPopScope(
//         onWillPop: () async {
//           showMyDialog(context);
//           return false;
//         },
//         child: GetX(
//             init: PosController(),
//             builder: (controller) {
//               return Scaffold(
//                 appBar: CommonUI.appBarUI(context, isCartVisible: false),
//                 body: Align(
//                   alignment: Alignment.topCenter,
//                   child: SizedBox(
//                     width: Responsive.isMobile(context) ? Responsive.width(100, context) : 800,
//                     child: Padding(
//                       padding: paddingEdgeInsets(),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const TextCustom(title: 'Order Details', fontSize: 18),
//                             spaceH(height: 15),
//                             ContainerCustom(
//                                 alignment: Alignment.centerLeft,
//                                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                   const TextCustom(
//                                     title: 'Table',
//                                     fontFamily: AppThemeData.medium,
//                                     fontSize: 16,
//                                   ),
//                                   spaceH(),
//                                   TextCustom(title: Constant.tableNo, fontFamily: AppThemeData.regular, fontSize: 15)
//                                 ])),
//                             spaceH(),
//                             if (controller.orderDetails.value.product != null)
//                               ContainerCustom(
//                                   alignment: Alignment.centerLeft,
//                                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                     const TextCustom(
//                                       title: 'Payment Method',
//                                       fontFamily: AppThemeData.medium,
//                                       fontSize: 16,
//                                     ),
//                                     spaceH(),
//                                     TextCustom(title: controller.selectedPayment.value, fontFamily: AppThemeData.regular, fontSize: 15)
//                                   ])),
//                             spaceH(),
//                             if (controller.orderDetails.value.product != null)
//                               ContainerCustom(
//                                   child: controller.orderDetails.value.product!.isEmpty
//                                       ? SizedBox(
//                                           width: Responsive.width(100, context),
//                                           height: Responsive.height(48, context),
//                                           child: Constant.loaderWithNoFound(context,
//                                               isLoading: controller.isItemLoading.value, isNotFound: controller.orderDetails.value.product!.isEmpty))
//                                       : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                           const TextCustom(title: 'Product Details', fontFamily: AppThemeData.medium, fontSize: 16),
//                                           spaceH(),
//                                           ListView.separated(
//                                             primary: false,
//                                             shrinkWrap: true,
//                                             separatorBuilder: (context, index) {
//                                               return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: devider(context, height: 2));
//                                             },
//                                             itemBuilder: (context, index) {
//                                               ItemModel model = controller.orderDetails.value.product![index];
//                                               double totalAddonPrice = 0.0;
//                                               if (model.addons != null)
//                                                 for (var element in model.addons!) {
//                                                   totalAddonPrice += double.parse(element.price!);
//                                                 }
//                                               return InkWell(
//                                                 onTap: () async {
//                                                   await controller.productDetailInit(model);
//                                                   // ignore: use_build_context_synchronously
//                                                   productDetailsDialog(context, themeChange.getThem());
//                                                 },
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Row(children: [
//                                                           TextCustom(title: model.name?.trim() ?? '', textAlign: TextAlign.start),
//                                                           spaceW(width: 5),
//                                                           model.itemAttributes != null
//                                                               ? SizedBox(
//                                                                   height: 20,
//                                                                   child: TextCustom(
//                                                                       fontFamily: AppThemeData.regular,
//                                                                       title:
//                                                                           "(${model.itemAttributes!.variants!.firstWhere((element) => element.variantId == model.variantId).variantSku})",
//                                                                       maxLine: 3,
//                                                                       fontSize: 12),
//                                                                 )
//                                                               : const SizedBox(),
//                                                         ]),
//                                                       ],
//                                                     ),
//                                                     if (model.addons!.isNotEmpty)
//                                                       SingleChildScrollView(
//                                                         scrollDirection: Axis.vertical,
//                                                         child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: model.addons!
//                                                                 .map((e) => e.qty == 0
//                                                                     ? const SizedBox()
//                                                                     : Padding(
//                                                                         padding: const EdgeInsets.only(bottom: 4),
//                                                                         child: Row(
//                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             TextCustom(
//                                                                               title: "${e.name!.capitalizeText()} (${Constant.amountShow(amount: e.price.toString())})",
//                                                                               fontSize: 10,
//                                                                             ),
//                                                                             spaceW(width: 5),
//                                                                             TextCustom(
//                                                                               title: "x ${e.qty ?? ''}",
//                                                                               fontSize: 10,
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ))
//                                                                 .toList()),
//                                                       ),
//                                                     if (model.addons!.isNotEmpty)
//                                                       Row(
//                                                         mainAxisAlignment: MainAxisAlignment.start,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           const TextCustom(
//                                                             title: "Total Addons Price: ",
//                                                             fontSize: 10,
//                                                           ),
//                                                           TextCustom(
//                                                             title: Constant.amountShow(amount: totalAddonPrice.toString()),
//                                                             fontSize: 10,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     spaceH(height: 5),
//                                                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                                       TextCustom(
//                                                           fontSize: 16,
//                                                           title: Constant.amountShow(
//                                                             amount: model.price ?? '0',
//                                                           )),
//                                                       Container(
//                                                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//                                                           decoration: BoxDecoration(
//                                                               color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
//                                                               borderRadius: BorderRadius.circular(20)),
//                                                           child: Column(mainAxisSize: MainAxisSize.min, children: [
//                                                             spaceW(),
//                                                             TextCustom(title: '${model.qty ?? 0}'),
//                                                             spaceW(),
//                                                           ])),
//                                                     ])
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                             itemCount: controller.orderDetails.value.product!.length,
//                                           ),
//                                         ])),
//                             spaceH(),
//                             ContainerCustom(
//                               padding: EdgeInsets.zero,
//                               child: Column(mainAxisSize: MainAxisSize.max, children: [
//                                 Padding(
//                                   padding: paddingEdgeInsets(),
//                                   child: Column(children: [
//                                     labelData(label: 'Sub Total', value: Constant.amountShow(amount: '${controller.orderDetails.value.subtotal ?? 0}')),
//                                     spaceH(height: 20),
//                                     labelData(label: 'Discount', value: Constant.amountShow(amount: controller.orderDetails.value.discount ?? '0.0')),
//                                     spaceH(height: 20),
//                                     ListView.builder(
//                                         itemCount: Constant.taxList.length,
//                                         shrinkWrap: true,
//                                         itemBuilder: (context, index) {
//                                           TaxModel taxModel = Constant.taxList[index];
//                                           return Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 5),
//                                             child: labelData(
//                                                 label:
//                                                     '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
//                                                 value: Constant.amountShow(
//                                                     amount: Constant().calculateTax(taxModel: taxModel, amount: controller.orderDetails.value.subtotal ?? '0.0').toString())),
//                                           );
//                                         }),
//                                     spaceH(),
//                                   ]),
//                                 ),
//                                 devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
//                                 Container(
//                                     decoration: BoxDecoration(
//                                         color: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
//                                         border: Border.all(color: themeChange.getThem() == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
//                                         borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                       child: labelData(
//                                           label: 'Total', value: Constant.amountShow(amount: controller.orderDetails.value.total ?? '0.0'), textColor: AppThemeData.crusta500),
//                                     )),
//                               ]),
//                             ),
//                             spaceH(height: 15),
//                             InkWell(
//                               onTap: () async {
//                                 controller.isOrderPlace.value = false;
//                                 await Preferences.clearKeyData(Preferences.order);
//                                 controller.addToCart.value = OrderModel();
//                                 controller.productDetails.value = TempModel();
//                                 controller.update();
//                                 Get.to(const NavigatePosScreen());
//                               },
//                               child: ContainerCustom(
//                                 color: AppThemeData.forestGreen400,
//                                 child: Row(children: [
//                                   const Expanded(
//                                     child: TextCustom(title: 'Go to Home'),
//                                   ),
//                                   SvgPicture.asset('assets/icons/arrow_right.svg',
//                                       height: 20, width: 20, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
//                                 ]),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }));
//   }
// }

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: PosController(),
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

  cardDecoration(PosController controller, String value, themeChange, String image) {
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
