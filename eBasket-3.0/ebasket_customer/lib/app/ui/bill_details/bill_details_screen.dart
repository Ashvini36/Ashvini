import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/app/ui/delivery_address_screen/delivery_address_screen.dart';
import 'package:ebasket_customer/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/tax_model.dart';
import 'package:ebasket_customer/app/model/variant_info.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_brand_screen/view_all_brand_screen.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/bill_details_controller.dart';
import 'package:ebasket_customer/app/ui/coupon_screen/coupon_screen.dart';
import 'package:ebasket_customer/app/ui/payment_options/payment_options_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';
import 'package:ebasket_customer/widgets/trusted_brand_item.dart';
import 'package:uuid/uuid.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: BillDetailsController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: CommonUI.customAppBar(
                context,
                title: Text("Bill Details".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
                isBack: true,
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 2, color: AppThemeData.groceryAppDarkBlue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x19020202),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue.withOpacity(0.10), borderRadius: BorderRadius.circular(60)),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_location.svg",
                                        colorFilter: ColorFilter.mode(
                                          AppThemeData.groceryAppDarkBlue,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Delivery Address".tr,
                                              style: TextStyle(color: AppThemeData.black, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: AppThemeData.medium),
                                            ),
                                            Text(
                                              //  Constant.selectedPosition.getFullAddress().toString(),
                                              controller.addressModel.value.getFullAddress(),
                                              style: const TextStyle(color: AppThemeData.black, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryAddressScreen())).then((value) async {
                                          controller.addressModel.value = value;

                                          await controller.getData();

                                          controller.update();
                                        });
                                      },
                                      child: Text(
                                        "Change",
                                        style: TextStyle(fontFamily: AppThemeData.medium, color: AppThemeData.groceryAppDarkBlue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            controller.productList.isEmpty
                                ? EmptyData()
                                : StreamBuilder<List<CartProduct>>(
                                    stream: controller.homeController.cartDatabase.value.watchProducts,
                                    initialData: const [],
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator.adaptive(
                                            valueColor: AlwaysStoppedAnimation(AppThemeData.groceryAppDarkBlue),
                                          ),
                                        );
                                      }

                                      if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          Get.back();
                                        });

                                        return const SizedBox();
                                      } else {
                                        controller.cartProducts.value = snapshot.data!;
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: AppThemeData.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color(0x3F000000),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 0),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                ),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: controller.cartProducts.length,
                                                    itemBuilder: (context, index) {
                                                      CartProduct productList = controller.cartProducts[index];
                                                      return InkWell(
                                                        onTap: () {},
                                                        child: buildCartRow(productList, controller, context),
                                                      );
                                                    }),
                                              ),
                                            ),
                                            buildTotalRow(controller.cartProducts, controller, context),
                                          ],
                                        );
                                      }
                                    }),
                          ],
                        ),
                      ),
                    ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: RoundedButtonFill(
                    title: "Select Payment Option".tr,
                    fontSizes: 16,
                    onPress: () {
                      // if(Constant.selectedPosition.pinCode != '') {
                      if (controller.addressModel.value.pinCode != '') {
                        Constant.distance = (Constant.getKm(
                            LocationLatLng(latitude: controller.addressModel.value.location!.latitude, longitude: controller.addressModel.value.location!.longitude),
                            LocationLatLng(latitude: controller.vendorModel.value.latitude, longitude: controller.vendorModel.value.longitude)));
                        if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance)) {
                          if (double.parse(controller.totalAmount.toString()) <= double.parse(Constant.minorderAmount.toString())) {
                            Get.snackbar("Order value should be greater than  ${Constant.amountShow(amount: Constant.minorderAmount.toString())}", '',
                                messageText: Container(),
                                colorText: AppThemeData.black,
                                snackPosition: SnackPosition.BOTTOM,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                margin: const EdgeInsets.only(bottom: 70),
                                backgroundColor: AppThemeData.groceryAppDarkBlue.withOpacity(0.20));
                          } else {
                            print("=====${controller.selectedCouponModel.value.code}");
                            Get.to(const PaymentOptionsScreen(), arguments: {
                              'orderModel': OrderModel(
                                  id: 'GB${const Uuid().v4().split("-").elementAt(0)}',
                                  coupon: controller.selectedCouponModel.value,
                                  createdAt: Timestamp.now(),
                                  deliveryCharge: controller.deliveryCharges.value.toString(),
                                  estimatedTimeToPrepare: controller.hour.value != 0
                                      ? '${controller.hour.value.toString().padLeft(2, "0")}hour ${controller.minutes.value.toStringAsFixed(0).padLeft(2, "0")} minutes'
                                      : '${controller.minutes.value.toStringAsFixed(0).padLeft(2, "0")} minutes',
                                  user: controller.userModel.value,
                                  userID: controller.userModel.value.id!.toString(),
                                  vendor: controller.vendorModel.value,
                                  products: controller.cartProducts,
                                  taxModel: Constant.taxList,
                                  otp: Constant.getOtpCode(),
                                  // address: Constant.selectedPosition
                                  address: controller.addressModel.value),
                              'totalAmount': controller.totalAmount.value.toString()
                            });
                          }
                        } else {
                          ShowToastDialog.showToast("The service is not available in the current  address.".tr);
                        }
                      } else {
                        ShowToastDialog.showToast("Your address does not have PinCode.Please change the address or edit the current address".tr);
                      }
                    },
                    textColor: AppThemeData.white,
                    color: AppThemeData.groceryAppDarkBlue,
                  ),
                ),
              ));
        });
  }

  buildCartRow(CartProduct cartProduct, controller, context) {
    double priceTotalValue = 0.0;
    VariantInfo? variantInfo;
    Rx<ProductModel> productModel = ProductModel().obs;
    RxInt productQnt = 0.obs;

    productQnt.value = cartProduct.quantity;

    if (cartProduct.variant_info != null) {
      variantInfo = VariantInfo.fromJson(jsonDecode(cartProduct.variant_info.toString()));
    }

    if (cartProduct.discountPrice != '0') {
      priceTotalValue += double.parse(cartProduct.discountPrice!) * cartProduct.quantity;
    } else {
      priceTotalValue += double.parse(cartProduct.price) * cartProduct.quantity;
    }

    return InkWell(
      onTap: () {
        FireStoreUtils.getProductByProductId(cartProduct.id.split('~').first).then((value) {
          Get.to(const ProductDetailsScreen(), arguments: {
            "productModel": value,
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppThemeData.black, width: 0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NetworkImageWidget(
                  height: Responsive.height(5, context),
                  width: Responsive.width(10, context),
                  imageUrl: cartProduct.photo.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartProduct.name.toString(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                                color: AppThemeData.black, fontSize: 12, overflow: TextOverflow.ellipsis, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              Constant.amountShow(amount: priceTotalValue.toString()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
                            ),
                          ),
                          variantInfo == null || variantInfo.variantOptions!.isEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: List.generate(
                                      variantInfo.variantOptions!.length,
                                      (i) {
                                        return Text(
                                          "${variantInfo!.variantOptions![variantInfo.variantOptions!.keys.elementAt(i)]}",
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: AppThemeData.groceryAppDarkBlue,
                                              fontSize: 10,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.bold,
                                              fontWeight: FontWeight.w700),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              productQnt.value = productQnt.value - 1;
                              removeToCard(cartProduct, productQnt.value, controller);
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
                          width: 8,
                        ),
                        SizedBox(
                          width: Responsive.width(5, context),
                          child: Text(
                            "${cartProduct.quantity}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: AppThemeData.medium, color: AppThemeData.black, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                            onTap: () async {
                              await FireStoreUtils.getProductByProductId(cartProduct.id.split('~').first).then((value) {
                                productModel.value = value!;
                              });
                              if (productModel.value.itemAttributes != null && variantInfo != null) {
                                if (productModel.value.itemAttributes!.variants!.where((element) => element.variantSku == variantInfo!.variantSku).isNotEmpty) {
                                  if (int.parse(productModel.value.itemAttributes!.variants!
                                              .where((element) => element.variantSku == variantInfo!.variantSku)
                                              .first
                                              .variantQuantity
                                              .toString()) >
                                          cartProduct.quantity ||
                                      int.parse(productModel.value.itemAttributes!.variants!
                                              .where((element) => element.variantSku == variantInfo!.variantSku)
                                              .first
                                              .variantQuantity
                                              .toString()) ==
                                          -1) {
                                    productQnt.value = productQnt.value + 1;
                                    addToCard(cartProduct, productQnt.value, controller);
                                  } else {
                                    ShowToastDialog.showToast("Item out of stock");
                                  }
                                } else {
                                  if (productModel.value.quantity! > productQnt.value || productModel.value.quantity == -1) {
                                    productQnt.value = productQnt.value + 1;
                                    addToCard(cartProduct, productQnt.value, controller);
                                  } else {
                                    ShowToastDialog.showToast("Item out of stock");
                                  }
                                }
                              } else {
                                if (productModel.value.quantity! > productQnt.value || productModel.value.quantity! == -1) {
                                  productQnt.value = productQnt.value + 1;
                                  addToCard(cartProduct, productQnt.value, controller);
                                } else {
                                  ShowToastDialog.showToast("Item out of stock");
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addToCard(CartProduct cartProduct, qun, BillDetailsController controller) async {
    await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
      id: cartProduct.id,
      name: cartProduct.name,
      photo: cartProduct.photo,
      price: cartProduct.price,
      quantity: qun,
      category_id: cartProduct.category_id,
      discountPrice: cartProduct.discountPrice!,
      hsn_code: cartProduct.hsn_code,
      description: cartProduct.description,
      discount: cartProduct.discount,
      unit: cartProduct.unit,
    ));
  }

  removeToCard(CartProduct cartProduct, qun, BillDetailsController controller) async {
    if (qun >= 1) {
      await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
          id: cartProduct.id,
          category_id: cartProduct.category_id,
          name: cartProduct.name,
          photo: cartProduct.photo,
          price: cartProduct.price,
          quantity: qun,
          discountPrice: cartProduct.discountPrice,
          hsn_code: cartProduct.hsn_code,
          description: cartProduct.description,
          discount: cartProduct.discount,
          unit: cartProduct.unit));
    } else {
      controller.homeController.cartDatabase.value.removeProduct(cartProduct.id);
    }
  }

  discountCalculation(BillDetailsController controller) {
    controller.totalAmount.value = 0.0;

    if (controller.selectedCouponModel.value.id != null) {
      if (controller.selectedCouponModel.value.discountType == "Fix Price") {
        controller.discount.value = double.parse(controller.selectedCouponModel.value.discount.toString());
      } else {
        controller.discount.value = double.parse(controller.subTotal.value.toString()) * double.parse(controller.selectedCouponModel.value.discount.toString()) / 100;
      }
    }
    controller.totalAmount.value = controller.subTotal.value + double.parse(controller.deliveryCharges.value);

    controller.totalAmount.value = controller.totalAmount.value - controller.discount.value;

    String taxAmount = " 0.0";
    if (Constant.taxList != null) {
      for (var element in Constant.taxList!) {
        taxAmount = (double.parse(taxAmount) + Constant.calculateTax(amount: (controller.subTotal.value - controller.discount.value).toString(), taxModel: element)).toString();
      }
    }
    controller.totalAmount.value += double.parse(taxAmount);
  }

  Widget buildTotalRow(List<CartProduct> data, BillDetailsController controller, BuildContext context) {
    controller.subTotal.value = 0.00;
    controller.totalAmount.value = 0.0;
    controller.cartItem.value = 0;
    controller.tempProduct.clear();
    for (int a = 0; a < data.length; a++) {
      CartProduct e = data[a];
      controller.cartItem.value += e.quantity;
      if (e.discountPrice != '0') {
        controller.subTotal.value += double.parse(e.discountPrice!) * e.quantity;
      } else {
        controller.subTotal.value += double.parse(e.price) * e.quantity;
      }
    }
    discountCalculation(controller);

    for (CartProduct cartProduct in data) {
      CartProduct tempCart = cartProduct;
      controller.tempProduct.add(tempCart.id.toString());
    }
    ProductModel establishedBrandItem = ProductModel();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "Before You Checkout".tr,
                style: TextStyle(color: AppThemeData.black, fontSize: 18, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(const ViewAllBrandScreen(), arguments: {"type": 'checkoutBrand'});
              },
              child: Text(
                "View All".tr,
                style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        controller.tempProduct.length == controller.productList.length
            ? Center(child: Text("No products found"))
            : SizedBox(
                height: Responsive.height(38, context),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    // ProductModel establishedBrandItem = controller.productList[index];

                    if (!controller.tempProduct.contains('${controller.productList[index].id!}~')) {
                      establishedBrandItem = controller.productList[index];

                      return SizedBox(
                        height: Responsive.height(38, context),
                        child: InkWell(
                          onTap: () {},
                          child: EstablishedBrandItemWidget(
                            establishedBrandItem: establishedBrandItem,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Get.to(const CouponScreen(), arguments: {"subTotal": controller.subTotal.value.toString()}, transition: Transition.rightToLeftWithFade)!.then((value) {
              if (value != null) {
                controller.selectedCouponModel.value = value;
                discountCalculation(controller);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppThemeData.groceryAppDarkBlue,
                width: 2,
              ),
              color: AppThemeData.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_coupon.svg",
                    colorFilter: ColorFilter.mode(
                      AppThemeData.groceryAppDarkBlue,
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Apply Coupon".tr,
                      style: TextStyle(color: AppThemeData.black, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                    ),
                  ),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: AppThemeData.black,
                          size: 32,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppThemeData.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ic_clock.svg",
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.hour.value != 0
                                  ? 'Delivery in ${controller.hour.value.toString().padLeft(2, "0")}hour ${controller.minutes.value.toStringAsFixed(0).padLeft(2, "0")} minutes'
                                  : 'Delivery in  ${controller.minutes.value.toStringAsFixed(0).padLeft(2, "0")} minutes',
                              style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                            ),
                            Text(
                              "Shipment of ${controller.cartItem.value} items",
                              style: const TextStyle(fontSize: 10, color: AppThemeData.black, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item Total".tr,
                        style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                      ),
                      Text(
                        Constant.amountShow(amount: controller.subTotal.value.toString()),
                        style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product Discount".tr,
                          style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                        ),
                        Text(
                          Constant.amountShow(amount: controller.discount.value.toString()),
                          style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: Constant.taxList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    TaxModel taxModel = Constant.taxList![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              //  "${taxModel.title.toString()} (${taxModel.type == "fix" ? Constant.amountShow(amount: taxModel.tax) : "${taxModel.tax}%"})",
                              taxModel.title.toString(),

                              style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                            ),
                          ),
                          Obx(
                            () => Text(
                              Constant.amountShow(
                                  amount: Constant.calculateTax(
                                          amount: (double.parse(controller.subTotal.value.toString()) - double.parse(controller.discount.value.toString())).toString(),
                                          taxModel: taxModel)
                                      .toString()),
                              style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Charges".tr,
                        style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                      ),
                      Text(
                        controller.deliveryCharges.value != '0' ? Constant.amountShow(amount: controller.deliveryCharges.value.toString()) : "FREE",
                        style: TextStyle(fontSize: 14, color: AppThemeData.groceryAppDarkBlue, fontWeight: FontWeight.w600, fontFamily: AppThemeData.extraBold),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppThemeData.black.withOpacity(0.50),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total".tr,
                        style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.semiBold),
                      ),
                      Obx(
                        () => Text(
                          Constant.amountShow(amount: controller.totalAmount.value.toString()),
                          style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
