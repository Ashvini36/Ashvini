import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/pos_controller.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/offer_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/app/model/user_model.dart';
import 'package:scaneats/app/ui/item_screen/widget_item.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/pickup_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class PosView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const PosView({super.key, this.crossAxisCount = 4, this.childAspectRatio = 1.5});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PosController(),
        initState: (state) {
          state.controller!.getData();
        },
        builder: (controller) {
          return Padding(
            padding: paddingEdgeInsets(vertical: 0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceH(height: 20),
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
                    if (!Responsive.isMobile(context)) spaceH(height: 20),
                    SizedBox(
                      height: Responsive.height(Responsive.isMobile(context) ? 80 : 85, context),
                      child: controller.itemList.isEmpty || controller.isItemLoading.value
                          ? SizedBox(
                              width: Responsive.width(100, context),
                              height: Responsive.height(90, context),
                              child: Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value, isNotFound: controller.itemList.isEmpty))
                          : GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: controller.itemList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 250, childAspectRatio: childAspectRatio, crossAxisCount: crossAxisCount),
                              itemBuilder: (context, index) {
                                ItemModel model = controller.itemList[index];
                                return InkWell(
                                  onTap: () async {
                                    await controller.productDetailInit(model);
                                    // ignore: use_build_context_synchronously
                                    productDetailsDialog(context, isDarkTheme: themeChange.getThem());
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
                                              fit: BoxFit.fill,
                                              placeHolderFit: BoxFit.contain,
                                              width: Responsive.width(100, context),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: paddingEdgeInsets(vertical: 8),
                                          child: Row(children: [
                                            Expanded(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              TextCustom(title: model.name ?? ''),
                                              spaceH(height: 4),
                                              TextCustom(title: Constant.amountShow(amount: model.price ?? '0')),
                                              if (Responsive.isMobile(context))
                                                Chip(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                    backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                    avatar: Icon(
                                                      Icons.add,
                                                      color: AppThemeData.crusta500,
                                                    ),
                                                    label: TextCustom(title: 'Add', color: AppThemeData.crusta500))
                                            ])),
                                            if (!Responsive.isMobile(context))
                                              Chip(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                  backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                  avatar: Icon(
                                                    Icons.add,
                                                    color: AppThemeData.crusta500,
                                                  ),
                                                  label: TextCustom(title: 'Add', color: AppThemeData.crusta500))
                                          ]),
                                        ),
                                      ])),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                GetBuilder(
                    init: PosController(),
                    builder: (controller) {
                      return Visibility(
                        visible: controller.addToCart.value.product != null && controller.addToCart.value.product!.isNotEmpty,
                        child: Positioned(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 0 : 120),
                              child: InkWell(
                                onTap: () {
                                  controller.calculateAddToCart();

                                  addToCartDialog(context, themeChange.getThem());
                                },
                                child: SizedBox(
                                  child: ContainerCustom(
                                    color: const Color(0xff10A944),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: TextCustom(
                                                title: '${controller.addToCart.value.product?.length ?? 0} Item has been added in your cart',
                                                color: AppThemeData.white,
                                                maxLine: 2,
                                                fontSize: 15)),
                                        const TextCustom(title: 'View Cart', color: AppThemeData.white),
                                        spaceW(width: 5),
                                        const Icon(Icons.arrow_forward_rounded, color: AppThemeData.white, size: 20)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      );
                    })
              ],
            ),
          );
        });
  }
}

productDetailsDialog(BuildContext context, {required bool isDarkTheme}) {
  Dialog alert = Dialog(
    shadowColor: isDarkTheme ? AppThemeData.white : AppThemeData.black,
    backgroundColor: isDarkTheme ? AppThemeData.black : AppThemeData.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: GetBuilder(
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
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: NetworkImageWidget(
                              imageUrl: controller.productDetails.value.image ?? '',
                              placeHolderUrl: Constant.placeholderURL,
                              height: 100,
                              width: 100,
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
                                            fontFamily: AppThemeData.regular, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontSize: 14)),
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
                        child: Icon(Icons.close, size: 18, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950))
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
              spaceH(height: 20),
              Padding(
                padding: paddingEdgeInsets(),
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

                                    // controller.calculateAddToCart();
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
                                        child: TextCustom(
                                          title: '-',
                                          color: AppThemeData.crusta500,
                                          fontSize: 20,
                                        ),
                                      ),
                                      spaceW(),
                                      TextCustom(title: '${controller.productDetails.value.qty ?? 0}'),
                                      spaceW(),
                                      InkWell(
                                        onTap: () {
                                          controller.productDetails.value.qty ??= 0;
                                          controller.productDetails.value.qty = controller.productDetails.value.qty! + 1;
                                          controller.update();
                                        },
                                        child: TextCustom(
                                          title: '+',
                                          color: AppThemeData.crusta500,
                                          fontSize: 20,
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
                                                          controller.selectedVariants
                                                              .insert(index, controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString());
                                                          controller.selectedIndexVariants
                                                              .add('$index _${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString()}');
                                                          controller.selectedIndexArray.add('${index}_$i');
                                                        } else {
                                                          controller.selectedIndexArray.remove(
                                                              '${index}_${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions?.indexOf(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first.replaceAll('$index _', ''))}');
                                                          controller.selectedVariants.removeAt(index);
                                                          controller.selectedIndexVariants
                                                              .remove(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first);
                                                          controller.selectedVariants
                                                              .insert(index, controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString());
                                                          controller.selectedIndexVariants
                                                              .add('$index _${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString()}');
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

                                                        // controller.calculateAddToCart();
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
                      // ignore: prefer_is_empty
                      child: controller.productDetails.value.addons?.length == 0
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceH(height: 20),
                                const TextCustom(title: 'Addons'),
                                spaceH(),
                                SizedBox(
                                  height: 80,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.productDetails.value.addons?.length ?? 0,
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
                                                child: NetworkImageWidget(
                                                  imageUrl: controller.productDetails.value.addons![i].image ?? '',
                                                  placeHolderUrl: Constant.placeholderURL,
                                                  height: 80,
                                                  width: 100,
                                                ),
                                              ),
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
                                                          return controller.productDetails.value.addons![i].qty == 0
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    if (controller.productDetails.value.addons![i].qty == null) {
                                                                      controller.productDetails.value.addons![i].qty = 0;
                                                                    }
                                                                    controller.productDetails.value.addons![i].qty = controller.productDetails.value.addons![i].qty! + 1;
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
                                                                        child: TextCustom(
                                                                          title: '-',
                                                                          color: AppThemeData.crusta500,
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
                                                                        child: TextCustom(
                                                                          title: '+',
                                                                          color: AppThemeData.crusta500,
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
                    spaceH(height: 20),
                    const TextCustom(title: 'Special Instructions'),
                    spaceH(),
                    TextFieldWidget(
                      hintText: 'Instructions',
                      fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                      controller: controller.specialInstruController.value,
                    ),
                    spaceH(height: 10),
                    if (!Responsive.isMobile(context))
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (controller.productDetails.value.qty != 0) {
                                  controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                  if (controller.addToCart.value.product == null) {
                                    controller.addToCart.value =
                                        OrderModel(product: [], customer: controller.selectedCustomer.value, tokenNo: controller.tokenController.value.text);
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
                                  Constant.setOrderData(controller.addToCart.value);

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
                                            const Icon(Icons.shopping_bag_outlined, color: AppThemeData.white, size: 20),
                                            spaceW(width: 5),
                                            TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontFamily: AppThemeData.medium),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Expanded(child: spaceW()),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (controller.productDetails.value.qty != 0) {
                                  controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                  if (controller.addToCart.value.product == null) {
                                    controller.addToCart.value =
                                        OrderModel(product: [], customer: controller.selectedCustomer.value, tokenNo: controller.tokenController.value.text);
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
                                  Constant.setOrderData(controller.addToCart.value);

                                  Get.back();
                                  addToCartDialog(context, isDarkTheme);
                                } else if (controller.addToCart.value.product != null && controller.addToCart.value.product!.isNotEmpty) {
                                  Get.back();
                                  controller.calculateAddToCart();
                                  addToCartDialog(context, isDarkTheme);
                                } else {
                                  ShowToastDialog.showToast("Cart is empty");
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
                                            const Icon(Icons.arrow_forward_rounded, color: AppThemeData.white, size: 20)
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    if (Responsive.isMobile(context))
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (controller.productDetails.value.qty != 0) {
                                controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                if (controller.addToCart.value.product == null) {
                                  controller.addToCart.value = OrderModel(product: [], customer: controller.selectedCustomer.value, tokenNo: controller.tokenController.value.text);
                                }

                                if (controller.addToCart.value.product!
                                    .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                    .isNotEmpty) {
                                  print("same");
                                  controller
                                          .addToCart.value.product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                      ItemModel.fromJson(controller.productDetails.value.toJson());
                                } else {
                                  print("Not same");
                                  controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                }
                                controller.calculateAddToCart();
                                Constant.setOrderData(controller.addToCart.value);

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
                                          const Icon(Icons.shopping_bag_outlined, color: AppThemeData.white, size: 20),
                                          spaceW(width: 5),
                                          TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontFamily: AppThemeData.medium),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          spaceH(),
                          InkWell(
                            onTap: () {
                              if (controller.productDetails.value.qty != 0) {
                                controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                if (controller.addToCart.value.product == null) {
                                  controller.addToCart.value = OrderModel(product: [], customer: controller.selectedCustomer.value, tokenNo: controller.tokenController.value.text);
                                }

                                if (controller.addToCart.value.product!
                                    .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                    .isNotEmpty) {
                                  print("same");
                                  controller
                                          .addToCart.value.product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                      ItemModel.fromJson(controller.productDetails.value.toJson());
                                } else {
                                  print("Not same");
                                  controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                }
                                controller.calculateAddToCart();
                                Constant.setOrderData(controller.addToCart.value);

                                Get.back();
                                addToCartDialog(context, isDarkTheme);
                              } else if (controller.addToCart.value.product != null && controller.addToCart.value.product!.isNotEmpty) {
                                Get.back();
                                controller.calculateAddToCart();
                                addToCartDialog(context, isDarkTheme);
                              } else {
                                ShowToastDialog.showToast("Cart is empty");
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
                                          const Icon(Icons.arrow_forward_rounded, color: AppThemeData.white, size: 20)
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    spaceH(height: 20)
                  ],
                ),
              ),
            ]),
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
                            child: Icon(Icons.close, size: 18, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                          ))
                    ],
                  ),
                  spaceH(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<UserModel>(
                            isExpanded: true,
                            hint: Text(
                              'Search customer',
                              style: TextStyle(
                                fontSize: 14,
                                color: !isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                              ),
                            ),
                            items: controller.customerList
                                .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ))))
                                .toList(),
                            value: controller.selectedCustomer.value.id == null ? null : controller.selectedCustomer.value,
                            onChanged: (value) {
                              controller.selectedCustomer.value = value!;
                              controller.update();
                            },
                            buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)), color: isDarkTheme ? AppThemeData.black : AppThemeData.pickledBluewood100)),
                            dropdownStyleData:
                                DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(color: isDarkTheme ? AppThemeData.black : AppThemeData.pickledBluewood100)),
                            dropdownSearchData: DropdownSearchData(
                              searchController: controller.searchEditingController.value,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Padding(
                                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: TextFieldWidget(
                                  hintText: 'Search customer',
                                  fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                                  controller: controller.searchEditingController.value,
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value!.name!.toLowerCase().contains(searchValue.toLowerCase());
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                controller.searchEditingController.value.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: DropdownButtonFormField<UserModel>(
                      //     value: controller.selectedCustomer.value.id == null ? null : controller.selectedCustomer.value,
                      //     hint: const TextCustom(title: 'Select Customer'),
                      //     onChanged: (UserModel? newValue) {
                      //       controller.selectedCustomer.value = newValue!;
                      //       controller.update();
                      //     },
                      //     decoration: InputDecoration(
                      //         errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                      //         isDense: true,
                      //         filled: true,
                      //         fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                      //         contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      //         disabledBorder: OutlineInputBorder(
                      //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //           borderSide: BorderSide(
                      //             color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                      //           ),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //           borderSide: BorderSide(
                      //             color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                      //           ),
                      //         ),
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //           borderSide: BorderSide(
                      //             color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                      //           ),
                      //         ),
                      //         errorBorder: OutlineInputBorder(
                      //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //           borderSide: BorderSide(
                      //             color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                      //           ),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //           borderSide: BorderSide(
                      //             color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                      //           ),
                      //         ),
                      //         hintText: "Select Customer".tr,
                      //         hintStyle: TextStyle(
                      //             fontSize: 14,
                      //             color: isDarkTheme ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                      //             fontWeight: FontWeight.w500,
                      //             fontFamily: AppThemeData.medium)),
                      //     items: controller.customerList.map<DropdownMenuItem<UserModel>>((UserModel value) {
                      //       return DropdownMenuItem<UserModel>(
                      //         alignment: Alignment.centerLeft,
                      //         value: value,
                      //         child: TextCustom(title: value.name ?? ''),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      spaceW(),
                      RoundedButtonFill(
                        icon: SvgPicture.asset(
                          'assets/icons/plus.svg',
                          height: 16,
                          width: 16,
                          fit: BoxFit.cover,
                          color: AppThemeData.pickledBluewood50,
                        ),
                        width: 80,
                        radius: 8,
                        height: 45,
                        title: "Add".tr,
                        color: AppThemeData.crusta500,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () {
                          showDialog(context: context, builder: (ctxt) => const AddCustomerDialog());
                        },
                      ),
                    ],
                  ),
                  spaceH(height: 15),
                  TextFieldWidget(
                    hintText: 'Token No.',
                    fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                    controller: controller.tokenController.value,
                  ),
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
                                  dataRowMaxHeight: 60,
                                  border: TableBorder.all(
                                    color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  headingRowColor: MaterialStateColor.resolveWith((states) => isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                  columns: [
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? Responsive.width(10, context) : Responsive.width(14, context),
                                            child: const Center(child: TextCustom(title: 'Items')))),
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? 70 : Responsive.width(04, context), child: const Center(child: TextCustom(title: 'Price')))),
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? 100 : Responsive.width(04, context), child: const Center(child: TextCustom(title: 'Qty')))),
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? 100 : Responsive.width(04, context), child: const Center(child: TextCustom(title: 'Extra')))),
                                    DataColumn(
                                        label: SizedBox(
                                            width: Responsive.isMobile(context) ? 80 : Responsive.width(04, context), child: const Center(child: TextCustom(title: 'Total')))),
                                  ],
                                  rows: controller.addToCart.value.product!.map(
                                    (e) {
                                      var productAmount = double.parse(e.price!) * e.qty!;
                                      var addonAmount = e.addons!.isNotEmpty ? e.addons!.fold(0.0, (sum, item) => sum + item.qty!.toDouble() * double.parse(item.price!)) : 0.0;
                                      String totalCost = (productAmount + addonAmount).toString();
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.addToCart.value.product!.removeAt(controller.addToCart.value.product!.indexOf(e));
                                                      controller.calculateAddToCart();
                                                      controller.update();
                                                      Constant.setOrderData(controller.addToCart.value);

                                                      if (controller.addToCart.value.product == null || controller.addToCart.value.product!.isEmpty) {
                                                        Get.back();
                                                      }
                                                    },
                                                    child: SvgPicture.asset('assets/icons/delete_Icon.svg', height: 16, width: 16, fit: BoxFit.cover)),
                                                spaceW(),
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(30),
                                                    child: NetworkImageWidget(imageUrl: e.image ?? '', placeHolderUrl: Constant.placeholderURL, height: 30, width: 30)),
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
                                                              title:
                                                                  '(${e.itemAttributes?.variants?.firstWhere((element) => element.variantId == e.variantId).variantSku.toString()})',
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
                                            ),
                                          ),
                                          DataCell(Center(child: TextCustom(title: Constant.amountShow(amount: e.price.toString()), color: AppThemeData.forestGreen))),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200, borderRadius: BorderRadius.circular(20)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      e.qty ??= 0;
                                                      if (e.qty != 0) {
                                                        e.qty = e.qty! - 1;
                                                      }
                                                      controller.calculateAddToCart();
                                                    },
                                                    child: TextCustom(
                                                      title: '-',
                                                      color: AppThemeData.crusta500,
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
                                                    child: TextCustom(
                                                      title: '+',
                                                      color: AppThemeData.crusta500,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                          DataCell(
                                            TextCustom(
                                              title: Constant.amountShow(amount: totalCost),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList());
                            }),
                      ),
                    ),
                  spaceH(height: 15),
                  TextFieldWidget(
                    prefix: SizedBox(
                      width: 125,
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                            errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                            isDense: true,
                            filled: true,
                            fillColor: isDarkTheme ? AppThemeData.black : AppThemeData.pickledBluewood100,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                              ),
                            ),
                            hintText: "Select Type".tr,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: isDarkTheme ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.medium)),
                        value: controller.selectedDiscountType.value,
                        onChanged: (value) {
                          controller.selectedDiscountType.value = value ?? '';
                        },
                        items: Constant.rateTypeList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: TextCustom(title: item),
                          );
                        }).toList(),
                      ),
                    ),
                    hintText: 'Add Discount',
                    fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                    controller: controller.discountController.value,
                    textInputType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    suffix: InkWell(
                      onTap: () {
                        if (controller.discountController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Discount amount is not valid");
                        } else {
                          controller.offerModel.value = OfferModel(
                              name: "admin",
                              rate: controller.discountController.value.text,
                              isFix: controller.selectedDiscountType.value == "Percentage" ? false : true,
                              isActive: true);
                          controller.calculateAddToCart();
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
                  if (controller.addToCart.value.subtotal != null)
                    GetBuilder(
                      init: PosController(),
                      builder: (controller) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkTheme == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                                      spaceH(),
                                      labelData(label: 'Sub Total', value: Constant.amountShow(amount: '${controller.addToCart.value.subtotal ?? 0}')),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3),
                                        child: Divider(
                                          color: isDarkTheme ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                                        ),
                                      ),
                                      labelData(label: 'Discount', value: "-${Constant.amountShow(amount: controller.addToCart.value.discount.toString())}"),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3),
                                        child: Divider(
                                          color: isDarkTheme ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                                        ),
                                      ),
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
                                                      amount: controller.addToCart.value.product!.isEmpty
                                                          ? "0.0"
                                                          : Constant()
                                                              .calculateTax(
                                                                  taxModel: taxModel,
                                                                  amount: (double.parse(controller.addToCart.value.subtotal.toString()) -
                                                                          double.parse(controller.addToCart.value.discount.toString()))
                                                                      .toString())
                                                              .toString())),
                                            );
                                          }),
                                      spaceH()
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
                                          label: 'Total',
                                          value: Constant.amountShow(amount: controller.addToCart.value.product!.isEmpty ? '0.0' : controller.addToCart.value.total.toString()),
                                          textColor: AppThemeData.crusta500)),
                                ],
                              ),
                            ),
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
                                spaceW(
                                    width: controller.addToCart.value.subtotal == null || controller.addToCart.value.subtotal!.isEmpty || controller.addToCart.value.subtotal == "0"
                                        ? 0
                                        : 20),
                                controller.addToCart.value.subtotal == null || controller.addToCart.value.subtotal!.isEmpty || controller.addToCart.value.subtotal == "0"
                                    ? const SizedBox()
                                    : Expanded(
                                        child: RoundedButtonFill(
                                          radius: 8,
                                          height: 45,
                                          fontSizes: 15,
                                          title: "Order",
                                          color: const Color(0xff10A944),
                                          textColor: AppThemeData.white,
                                          isRight: false,
                                          onPress: () {
                                            if (int.parse(Constant.restaurantModel.subscription!.noOfOrders.toString()) > controller.orderList.length) {
                                              controller.orderPlace();
                                            } else {
                                              ShowToastDialog.showToast(
                                                  "Your subscription has reached its maximum limit. Please consider extending it to continue accessing our services.");
                                            }
                                          },
                                        ),
                                      ),
                              ],
                            )
                          ],
                        );
                      },
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

class AddCustomerDialog extends StatelessWidget {
  const AddCustomerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PosController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Add Customer', fontSize: 18),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 1,
                    child: ContainerCustom(
                      color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood50,
                    ),
                  ),
                  spaceH(),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.name.value,
                          title: 'Name',
                        )),
                    spaceW(width: 15),
                    Expanded(
                        flex: 1,
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.email.value,
                          title: 'Email',
                        )),
                  ]),
                  spaceH(),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.password.value,
                          obscureText: !controller.isPasswordVisible.value,
                          title: 'Password',
                          suffix: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                            ),
                            onPressed: () {
                              controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                            },
                          ),
                        )),
                    spaceW(width: 15),
                    Expanded(
                        flex: 1,
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.conPassword.value,
                          obscureText: !controller.isConformationPasswordVisible.value,
                          title: 'Confirm Password',
                          suffix: IconButton(
                            icon: Icon(
                              controller.isConformationPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                            ),
                            onPressed: () {
                              controller.isConformationPasswordVisible.value = !controller.isConformationPasswordVisible.value;
                            },
                          ),
                        )),
                  ]),
                  spaceH(height: 20),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 1,
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.phone.value,
                          title: 'Phone Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        )),
                    spaceW(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: InkWell(
                            onTap: () {
                              showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                if (value != null) {
                                  XFile stringFile = value;
                                  controller.profileImage.value = stringFile.path;
                                  controller.profileImageUin8List.value = await stringFile.readAsBytes();
                                }
                              });
                            },
                            child: Stack(alignment: Alignment.bottomCenter, children: [
                              controller.profileImage.isEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: NetworkImageWidget(
                                        imageUrl: Constant.userPlaceholderURL,
                                        placeHolderUrl: Constant.userPlaceholderURL,
                                        fit: BoxFit.fill,
                                        height: Responsive.width(30, context),
                                        width: Responsive.width(30, context),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Constant().hasValidUrl(controller.profileImage.value) == false
                                          ? kIsWeb
                                              ? controller.profileImageUin8List.value.isEmpty
                                                  ? Constant.loader(
                                                      context,
                                                    )
                                                  : Image.memory(
                                                      controller.profileImageUin8List.value,
                                                      height: Responsive.width(30, context),
                                                      width: Responsive.width(30, context),
                                                      fit: BoxFit.fill,
                                                    )
                                              : Image.file(
                                                  File(controller.profileImage.value),
                                                  height: Responsive.width(30, context),
                                                  width: Responsive.width(30, context),
                                                  fit: BoxFit.fill,
                                                )
                                          : NetworkImageWidget(
                                              imageUrl: controller.profileImage.value.toString(),
                                              placeHolderUrl: Constant.userPlaceholderURL,
                                              fit: BoxFit.fill,
                                              height: Responsive.width(30, context),
                                              width: Responsive.width(30, context),
                                            ),
                                    ),
                              Positioned(
                                bottom: 50,
                                right: Responsive.width(36, context),
                                child: InkWell(
                                  onTap: () {},
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/ic_edit_profile.svg',
                                          width: 22,
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  spaceH(),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: customRadioButton(context,
                              parameter: controller.status.value,
                              title: 'STATUS',
                              radioOne: "Active",
                              onChangeOne: () {
                                controller.status.value = "Active";
                                controller.update();
                              },
                              radioTwo: "Inactive",
                              onChangeTwo: () {
                                controller.status.value = "Inactive";
                                controller.update();
                              })),
                      spaceW(width: 20),
                      const Expanded(child: SizedBox())
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  RoundedButtonFill(
                      width: 120,
                      radius: 8,
                      height: 45,
                      icon: !controller.isNotAdded.value ? const SizedBox() : Constant.loader(context, color: AppThemeData.pickledBluewood50),
                      title: "Save",
                      color: AppThemeData.crusta500,
                      fontSizes: 14,
                      textColor: AppThemeData.white,
                      isRight: false,
                      onPress: () {
                        if (Constant.isDemo()) {
                          ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                        } else {
                          controller.loginUser();
                        }
                      }),
                  spaceW(width: 15),
                  RoundedButtonFill(
                      borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                      width: 120,
                      radius: 8,
                      height: 45,
                      fontSizes: 14,
                      title: "Close",
                      textColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                      isRight: false,
                      onPress: () {
                        controller.setDefaultData();
                        Get.back();
                      }),
                ],
              )
            ],
          );
        });
  }
}
