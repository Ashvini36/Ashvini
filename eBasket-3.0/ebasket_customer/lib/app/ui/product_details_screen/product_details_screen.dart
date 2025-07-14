import 'dart:convert';

import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/variant_info.dart';
import 'package:ebasket_customer/app/ui/cart_screen/cart_screen.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/product_details_controller.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ProductDetailsController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: CommonUI.customAppBar(
                context,
                isBack: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            if (Constant.currentUser.id != null) {
                              Get.to(const CartScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                                controller.getData();
                              });
                            } else {
                              Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/icons/ic_bag.svg",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        StreamBuilder<List<CartProduct>>(
                          stream: controller.homeController.cartDatabase.value.watchProducts,
                          builder: (context, snapshot) {
                            controller.cartCount.value = 0;
                            if (snapshot.hasData) {
                              controller.cartProducts.value = snapshot.data!;
                              for (var element in snapshot.data!) {
                                controller.cartCount.value += element.quantity;
                              }
                            }
                            return Visibility(
                              visible: controller.cartCount.value >= 1,
                              child: Positioned(
                                right: 2,
                                top: -1,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppThemeData.groceryAppDarkBlue,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.cartCount.value <= 99 ? '${controller.cartCount.value}' : '+99',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(
                            height: Responsive.height(35, context),
                            child: PageView.builder(
                                padEnds: false,
                                itemCount: controller.productModel.value.photos!.length,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: controller.selectedPageIndex,
                                controller: controller.pageController,
                                itemBuilder: (context, index) {
                                  return NetworkImageWidget(
                                    imageUrl: controller.productModel.value.photos![index].toString(),
                                    fit: BoxFit.fill,
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                controller.productModel.value.photos!.length,
                                (index) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: controller.selectedPageIndex.value == index ? 10 : 5,
                                    height: controller.selectedPageIndex.value == index ? 10 : 5,
                                    decoration: BoxDecoration(
                                      color: controller.selectedPageIndex.value == index ? AppThemeData.groceryAppDarkBlue : AppThemeData.groceryAppDarkBlue.withOpacity(0.50),
                                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppThemeData.groceryAppDarkBlue,
                                    width: 2,
                                  ),
                                  color: AppThemeData.groceryAppDarkBlue.withOpacity(0.10),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "at ${controller.productModel.value.qty_pack.toString()}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppThemeData.groceryAppDarkBlue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          controller.productModel.value.discount == "" || controller.productModel.value.discount == "0"
                                              ? Text(
                                                  Constant.amountShow(amount: controller.productModel.value.price),
                                                  style: TextStyle(
                                                    color: AppThemeData.groceryAppDarkBlue,
                                                    fontSize: 20,
                                                    fontFamily: AppThemeData.semiBold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      Constant.amountShow(
                                                          amount: Constant.calculateDiscount(
                                                                  amount: controller.productModel.value.price!, discount: controller.productModel.value.discount!)
                                                              .toString()),
                                                      style: TextStyle(
                                                        color: AppThemeData.groceryAppDarkBlue,
                                                        fontSize: 20,
                                                        fontFamily: AppThemeData.semiBold,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      Constant.amountShow(amount: controller.productModel.value.price),
                                                      style: const TextStyle(
                                                          fontFamily: AppThemeData.medium, fontWeight: FontWeight.bold, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                      if (controller.productModel.value.itemAttributes != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Variant",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: AppThemeData.groceryAppDarkBlue,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.semiBold,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Responsive.height(10, context),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller.attributes!.length,
                                                  itemBuilder: (context, index) {
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        padding: EdgeInsets.zero,
                                                        itemCount: controller.attributes![index].attributeOptions!.length,
                                                        itemBuilder: (context, i) {
                                                          return ListView.builder(
                                                              shrinkWrap: true,
                                                              scrollDirection: Axis.horizontal,
                                                              padding: EdgeInsets.zero,
                                                              itemCount: controller.variants!.length,
                                                              itemBuilder: (context, index1) {
                                                                Variants variants = controller.variants![index1];

                                                                return (controller.attributes![index].attributeOptions![i].toString() == variants.variantSku.toString())
                                                                    ? Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              controller.selectedVariantIndex.value = index1;
                                                                              if (controller.selectedIndexVariants.where((element) => element.contains('$index _')).isEmpty) {
                                                                                controller.selectedVariants
                                                                                    .insert(index, controller.attributes![index].attributeOptions![i].toString());
                                                                                controller.selectedIndexVariants
                                                                                    .add('$index _${controller.attributes![index].attributeOptions![i].toString()}');
                                                                                controller.selectedIndexArray.add('${index}_$i');
                                                                              } else {
                                                                                controller.selectedIndexArray.remove(
                                                                                    '${index}_${controller.attributes![index].attributeOptions?.indexOf(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first.replaceAll('$index _', ''))}');
                                                                                controller.selectedVariants.removeAt(index);
                                                                                controller.selectedIndexVariants.remove(
                                                                                    controller.selectedIndexVariants.where((element) => element.contains('$index _')).first);
                                                                                controller.selectedVariants
                                                                                    .insert(index, controller.attributes![index].attributeOptions![i].toString());
                                                                                controller.selectedIndexVariants
                                                                                    .add('$index _${controller.attributes![index].attributeOptions![i].toString()}');
                                                                                controller.selectedIndexArray.add('${index}_$i');
                                                                              }

                                                                              await controller.homeController.cartDatabase.value.allCartProducts.then((value) {
                                                                                final bool productIsInList = value.any((product) =>
                                                                                    product.id ==
                                                                                    "${controller.productModel.value.id!}~${controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).isNotEmpty ? controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantId.toString() : ""}");
                                                                                if (productIsInList) {
                                                                                  CartProduct element = value.firstWhere((product) =>
                                                                                      product.id ==
                                                                                      "${controller.productModel.value.id!}~${controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).isNotEmpty ? controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantId.toString() : ""}");

                                                                                  controller.productQnt.value = element.quantity;
                                                                                } else {
                                                                                  controller.productQnt.value = 0;
                                                                                }
                                                                              });

                                                                              controller.update();
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  color: controller.selectedVariantIndex.value == index1
                                                                                      ? AppThemeData.groceryAppDarkBlue
                                                                                      : AppThemeData.groceryAppDarkBlue,
                                                                                  width: controller.selectedVariantIndex.value == index1 ? 3 : 0.5,
                                                                                ),
                                                                                color: AppThemeData.white,
                                                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      Constant.amountShow(amount: variants.variantPrice.toString()),
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                          color: AppThemeData.groceryAppDarkBlue, fontSize: 14, fontFamily: AppThemeData.semiBold),
                                                                                    ),
                                                                                    Text(
                                                                                      "at ${variants.variantSku.toString()}",
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: AppThemeData.groceryAppDarkBlue,
                                                                                        fontSize: 14,
                                                                                        fontFamily: AppThemeData.medium,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 12,
                                                                          )
                                                                        ],
                                                                      )
                                                                    : Container();
                                                              });
                                                        });
                                                  }),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  controller.productModel.value.name.toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: AppThemeData.black,
                                    fontSize: 20,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.productModel.value.description.toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: AppThemeData.black,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Product Information',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppThemeData.black,
                                    fontSize: 20,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppThemeData.black, width: 0.5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child: Text(
                                          'General Information',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppThemeData.black,
                                            fontSize: 16,
                                            fontFamily: AppThemeData.semiBold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Shelf Life'.tr,
                                                style: TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 13,
                                                  fontFamily: AppThemeData.semiBold,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.productModel.value.shelf_life.toString(),
                                                style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Country Of Origin'.tr,
                                                style: TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 13,
                                                  fontFamily: AppThemeData.semiBold,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.productModel.value.country.toString(),
                                                style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'FSSAI License'.tr,
                                                style: TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 13,
                                                  fontFamily: AppThemeData.semiBold,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.productModel.value.license_fssai.toString(),
                                                style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Expiry Date'.tr,
                                                style: TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 13,
                                                  fontFamily: AppThemeData.semiBold,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.productModel.value.expiry_date!.toDate().formatDate(),
                                                maxLines: 4,
                                                style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (controller.productModel.value.packaging_type!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Packaging Type'.tr,
                                                  style: TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 13,
                                                    fontFamily: AppThemeData.semiBold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.productModel.value.packaging_type.toString(),
                                                  style: const TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData.regular,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (controller.productModel.value.seller!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Seller'.tr,
                                                  style: TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 13,
                                                    fontFamily: AppThemeData.semiBold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.productModel.value.seller.toString(),
                                                  style: const TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData.regular,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (controller.productModel.value.seller_fssai!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Seller FSSAI'.tr,
                                                  style: TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 13,
                                                    fontFamily: AppThemeData.semiBold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.productModel.value.seller_fssai.toString(),
                                                  style: const TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData.regular,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (controller.productModel.value.hsn_code!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'HSN Code:'.tr,
                                                  style: TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 13,
                                                    fontFamily: AppThemeData.semiBold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.productModel.value.hsn_code.toString(),
                                                  style: const TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData.regular,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (controller.productModel.value.unit!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Unit:'.tr,
                                                  style: TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 13,
                                                    fontFamily: AppThemeData.semiBold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.productModel.value.unit.toString(),
                                                  style: const TextStyle(
                                                    color: AppThemeData.black,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData.regular,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Disclaimer'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppThemeData.black,
                                  fontSize: 20,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.productModel.value.disclaimer.toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: AppThemeData.black,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Customer Care Details'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppThemeData.black,
                                    fontSize: 20,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Email: info@grocery.com',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppThemeData.black,
                                    fontSize: 12,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: controller.productQnt.value == 0 || controller.productQnt.value == -1
                    ? RoundedButtonFill(
                        title: "Add To Cart".tr,
                        fontSizes: 16,
                        onPress: () {
                          if (Constant.currentUser.id != null) {
                            controller.productQnt.value = controller.productQnt.value + 1;

                            if (controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).isNotEmpty) {
                              if (int.parse(
                                          controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantQuantity.toString()) >=
                                      1 ||
                                  int.parse(
                                          controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantQuantity.toString()) ==
                                      -1) {
                                VariantInfo? variantInfo = VariantInfo();

                                Map<String, String> mapData = {};
                                for (var element in controller.attributes!) {
                                  mapData.addEntries([
                                    MapEntry(controller.attributesList.where((element1) => element.attributesId == element1.id).first.title.toString(),
                                        controller.selectedVariants[controller.attributes!.indexOf(element)])
                                  ]);
                                  controller.update();
                                }

                                variantInfo = VariantInfo(
                                    variantPrice: controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantPrice ?? '0',
                                    variantSku: controller.selectedVariants.join('-'),
                                    variantOptions: mapData,
                                    variantImage: controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantImage ?? '',
                                    variantId: controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantId ?? '0');

                                //   controller.productModel.value.variantInfo = variantInfo;
                                controller.productQnt.value = 1;
                                ProductModel product = ProductModel(
                                    id: controller.productModel.value.id,
                                    name: controller.productModel.value.name,
                                    photo: controller.productModel.value.photo,
                                    price: controller.productModel.value.itemAttributes!.variants!
                                            .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                            .first
                                            .variantPrice ??
                                        '0',
                                    discount: '0',
                                    categoryID: controller.productModel.value.categoryID,
                                    hsn_code: controller.productModel.value.hsn_code,
                                    description: controller.productModel.value.description,
                                    unit: controller.productModel.value.unit,
                                    variantInfo: variantInfo);

                                addToCard(controller, product, true);
                              } else {
                                ShowToastDialog.showToast("Item out of stock".tr);
                              }
                            } else {
                              if (controller.productModel.value.quantity! > controller.productQnt.value || controller.productModel.value.quantity == -1) {
                                controller.update();
                                controller.update();
                                addToCard(controller, controller.productModel.value, true);
                              } else {
                                ShowToastDialog.showToast("Item out of stock".tr);
                              }
                            }
                          } else {
                            Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                          }
                        },
                        textColor: AppThemeData.white,
                        color: AppThemeData.groceryAppDarkBlue,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (controller.productQnt.value != 0) {
                                      controller.productQnt.value--;
                                    }
                                    if (controller.productQnt.value >= 0) {
                                      removeToCard(controller, controller.productModel.value, true);
                                    }
                                    controller.update();
                                  },
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: AppThemeData.black,
                                        size: 16,
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => SizedBox(
                                  width: Responsive.width(8, context),
                                  child: Text(
                                    "${controller.productQnt.value}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      color: AppThemeData.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).isNotEmpty) {
                                      if (int.parse(controller.variants!
                                                  .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                  .first
                                                  .variantQuantity
                                                  .toString()) >
                                              controller.productQnt.value ||
                                          int.parse(controller.variants!
                                                  .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                  .first
                                                  .variantQuantity
                                                  .toString()) ==
                                              -1) {
                                        VariantInfo? variantInfo = VariantInfo();
                                        Map<String, String> mapData = {};
                                        for (var element in controller.attributes!) {
                                          mapData.addEntries([
                                            MapEntry(controller.attributesList.where((element1) => element.attributesId == element1.id).first.title.toString(),
                                                controller.selectedVariants[controller.attributes!.indexOf(element)])
                                          ]);
                                          controller.update();
                                        }

                                        variantInfo = VariantInfo(
                                            variantPrice:
                                                controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantPrice ?? '0',
                                            variantSku: controller.selectedVariants.join('-'),
                                            variantOptions: mapData,
                                            variantImage:
                                                controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantImage ?? '',
                                            variantId: controller.variants!.where((element) => element.variantSku == controller.selectedVariants.join('-')).first.variantId ?? '0');

                                        controller.productModel.value.variantInfo = variantInfo;
                                        if (controller.productQnt.value != 0) {
                                          controller.productQnt.value++;
                                        }
                                        addToCard(controller, controller.productModel.value, true);
                                      } else {
                                        ShowToastDialog.showToast("Item out of stock".tr);
                                      }
                                    } else {
                                      if (controller.productModel.value.quantity! > controller.productQnt.value || controller.productModel.value.quantity! == -1) {
                                        if (controller.productQnt.value != 0) {
                                          controller.productQnt.value++;
                                        }
                                        addToCard(controller, controller.productModel.value, true);
                                      } else {
                                        ShowToastDialog.showToast("Item out of stock".tr);
                                      }
                                    }
                                  },
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppThemeData.groceryAppDarkBlue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: AppThemeData.black,
                                        size: 16,
                                      ))),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Total: ",
                                style: TextStyle(
                                  color: AppThemeData.groceryAppDarkBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                              Text(
                                Constant.amountShow(amount: controller.priceTotalValue.value.toString()),
                                style: TextStyle(
                                  color: AppThemeData.groceryAppDarkBlue,
                                  fontSize: 24,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              ));
        });
  }

  addToCard(ProductDetailsController controller, ProductModel productModel, bool isIncrementQuantity) async {
    List<CartProduct> cartProducts = await controller.homeController.cartDatabase.value.allCartProducts;

    if (controller.productQnt.value > 1) {
      String mainPrice = "";

      if (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) {
        mainPrice = Constant.calculateDiscount(amount: productModel.price!, discount: productModel.discount!).toString();
      } else {
        mainPrice = productModel.price!;
      }

      final bool productIsInList =
          cartProducts.any((product) => product.id == "${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}");

      if (productIsInList) {
        CartProduct element =
            cartProducts.firstWhere((product) => product.id == "${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}");
        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: element.id,
            name: element.name,
            photo: element.photo,
            price: element.price,
            quantity: isIncrementQuantity ? element.quantity + 1 : element.quantity,
            category_id: element.category_id,
            discountPrice: element.discountPrice!,
            hsn_code: element.hsn_code,
            description: element.description,
            discount: element.discount,
            unit: element.unit));
      } else {
        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
          id: "${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}",
          name: productModel.name!,
          photo: productModel.photo!,
          price: mainPrice,
          discountPrice: (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) ? mainPrice : '0',
          quantity: productModel.quantity!,
          category_id: productModel.categoryID!,
          hsn_code: productModel.hsn_code!,
          description: productModel.description!,
          discount: productModel.discount!,
          unit: productModel.unit!,
          variant_info: productModel.variantInfo,
        ));
      }
      controller.update();
    } else {
      controller.homeController.cartDatabase.value.addProduct(productModel, controller.homeController.cartDatabase.value, isIncrementQuantity);
    }
    updatePrice(controller);
  }

  removeToCard(ProductDetailsController controller, ProductModel productModel, bool isIncrementQuantity) async {
    List<CartProduct> cartProducts = await controller.homeController.cartDatabase.value.allCartProducts;

    if (controller.productQnt.value >= 1) {
      String mainPrice = "";

      if (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) {
        mainPrice = Constant.calculateDiscount(amount: productModel.price!, discount: productModel.discount!).toString();
      } else {
        mainPrice = productModel.price!;
      }

      final bool productIsInList =
          // cartProducts.any((product) => product.id == "${productModel.id}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}");
          cartProducts.any(
              (product) => product.id == "${productModel.id!}~${product.variant_info != null ? VariantInfo.fromJson(jsonDecode(product.variant_info.toString())).variantId : ""}");

      if (productIsInList) {
        CartProduct element =
            //    cartProducts.firstWhere((product) => product.id == "${productModel.id}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}");
            cartProducts.firstWhere((product) =>
                product.id == "${productModel.id!}~${product.variant_info != null ? VariantInfo.fromJson(jsonDecode(product.variant_info.toString())).variantId : ""}");

        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: element.id,
            name: element.name,
            photo: element.photo,
            price: element.price,
            quantity: isIncrementQuantity ? element.quantity - 1 : element.quantity,
            category_id: element.category_id,
            discountPrice: element.discountPrice!,
            hsn_code: element.hsn_code,
            description: element.description,
            discount: element.discount,
            unit: element.unit));
        controller.update();
      } else {
        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: "${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}",
            name: productModel.name!,
            photo: productModel.photo!,
            price: productModel.price.toString(),
            discountPrice: (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) ? mainPrice : '0',
            quantity: productModel.quantity!,
            category_id: productModel.categoryID!,
            hsn_code: productModel.hsn_code!,
            description: productModel.description!,
            discount: productModel.discount!,
            unit: productModel.unit!,
            variant_info: productModel.variantInfo));
        controller.update();
      }
    } else {
      CartProduct element = cartProducts.firstWhere(
          (product) => product.id == "${productModel.id!}~${product.variant_info != null ? VariantInfo.fromJson(jsonDecode(product.variant_info.toString())).variantId : ""}");
      controller.homeController.cartDatabase.value.removeProduct(element.id);

      controller.productQnt.value = 0;
    }

    updatePrice(controller);
  }

  void updatePrice(controller) {
    List<CartProduct> cartProducts = [];
    Future.delayed(const Duration(milliseconds: 500), () {
      cartProducts.clear();

      controller.homeController.cartDatabase.value.allCartProducts.then((value) {
        controller.priceTotalValue.value = 0.0;
        cartProducts.addAll(value);
        for (int i = 0; i < cartProducts.length; i++) {
          CartProduct e = cartProducts[i];
          if (e.discountPrice != '0') {
            controller.priceTotalValue.value += double.parse(e.discountPrice!) * e.quantity;
          } else {
            controller.priceTotalValue.value += double.parse(e.price) * e.quantity;
          }
          controller.update();
        }
      });
    });
  }
}
