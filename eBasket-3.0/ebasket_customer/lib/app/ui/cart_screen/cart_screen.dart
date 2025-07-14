import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/controller/product_details_controller.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/variant_info.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/cart_controller.dart';
import 'package:ebasket_customer/app/ui/bill_details/bill_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: CartController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title:  Text(
                  "Cart".tr,
                  style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20),
                ),
                isBack: true),
            body: StreamBuilder<List<CartProduct>>(
                stream: controller.homeController.cartDatabase.value.watchProducts,
                initialData: const [],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(AppThemeData.groceryAppDarkBlue),
                      ),
                    );
                  }

                  if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                    return  Constant.emptyView(image: "assets/icons/no_record.png",text: "Empty".tr,description: "You don’t have any product item in your cart at this time");

                  } else {
                    controller.cartProducts.value = snapshot.data!;

                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: controller.cartProducts.length,
                                  itemBuilder: (context, index) {
                                    CartProduct productList = controller.cartProducts[index];
                                    return InkWell(
                                      onTap: () {},
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) => Get.dialog(
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
                                                        child: Text(
                                                          'Delete Item'.tr,
                                                          style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 24),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                       Center(
                                                        child: Text("Are you sure you want to".tr,
                                                            style:
                                                                TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 16, fontWeight: FontWeight.w500)),
                                                      ),
                                                       Center(
                                                        child: Text("delete this grocery?".tr,
                                                            style:
                                                                TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 16, fontWeight: FontWeight.w500)),
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
                                                                      borderRadius:  const BorderRadius.all(
                                                                        Radius.circular(60),
                                                                      ),
                                                                      border: Border.all(color: AppThemeData.groceryAppDarkBlue, width: 2)),
                                                                  child:  Padding(
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
                                                              onTap: () {
                                                                controller.homeController.cartDatabase.value.removeProduct(productList.id);
                                                                Get.back();
                                                                controller.update();
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
                                                                  child:  Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                                                                    child: Text(
                                                                      "Delete".tr,
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
                                            )),
                                        background: Container(
                                          color: Colors.red.withOpacity(0.10),
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: SvgPicture.asset("assets/icons/ic_delete.svg"),
                                          ),
                                        ),
                                        child: CartItemWidget(
                                          productList: productList,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                              child: RoundedButtonFill(
                                title: "Proceed To Checkout".tr,
                                onPress: () {
                                  Get.to(const BillDetailsScreen());
                                },
                                textColor: AppThemeData.white,
                                fontSizes: 16,
                                color: AppThemeData.groceryAppDarkBlue,
                              ),
                            )
                          ],
                        ));
                  }
                }),
          );
        });
  }
}

class CartItemWidget extends StatefulWidget {
  final CartProduct productList;

  const CartItemWidget({super.key, required this.productList});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  CartController cartController = Get.put(CartController());
  double priceTotalValue = 0.0;

  @override
  Widget build(BuildContext context) {
    Rx<CartProduct> productList = widget.productList.obs;
    Rx<ProductModel> productModel = ProductModel().obs;
    VariantInfo? variantInfo;
    RxInt productQnt = 0.obs;

    productQnt.value = widget.productList.quantity;

    if (widget.productList.variant_info != null) {
      variantInfo = VariantInfo.fromJson(jsonDecode(widget.productList.variant_info.toString()));
    }
    if (widget.productList.discountPrice != '0') {
      priceTotalValue += double.parse(widget.productList.discountPrice!) * widget.productList.quantity;
    } else {
      priceTotalValue += double.parse(widget.productList.price) * widget.productList.quantity;
    }
    // FireStoreUtils.getProductByProductId(widget.productList.id.split('~').first).then((value) {
    //   productModel.value = value!;
    // });
    return InkWell(
      onTap: () {
        FireStoreUtils.getProductByProductId(widget.productList.id.split('~').first).then((value) {
          Get.delete<ProductDetailsController>();
          Get.to(const ProductDetailsScreen(), arguments: {
            "productModel": value,
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100, width: 1),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      imageUrl: widget.productList.photo.toString(),
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
                                widget.productList.name.toString(),
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
                                              // "${variantInfo!.variantOptions!.keys.elementAt(i)} : ${variantInfo.variantOptions![variantInfo.variantOptions!.keys.elementAt(i)]}",
                                              " ${variantInfo!.variantOptions![variantInfo.variantOptions!.keys.elementAt(i)]}",

                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              style:  TextStyle(
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
                                  setState(() {
                                    // if (int.parse(productList.value.quantity.toString()) > 0) {
                                    //   productList.value.quantity = productList.value.quantity - 1;
                                    //   removeToCard(productList.value, productList.value.quantity, cartController);
                                    // }
                                    productQnt.value = productQnt.value - 1;
                                    removeToCard(productList.value, productQnt.value, cartController);
                                  });
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
                              width: Responsive.width(5.5, context),
                              child: Text(
                                "${productList.value.quantity}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontFamily: AppThemeData.medium, color: AppThemeData.black, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () async{
                                await  FireStoreUtils.getProductByProductId(widget.productList.id.split('~').first).then((value) {
                                    productModel.value = value!;
                                  });
                                  if (productModel.value.itemAttributes != null && variantInfo != null) {
                                    if (productModel.value.itemAttributes!.variants!.where((element) => element.variantSku == variantInfo!.variantSku).isNotEmpty) {
                                      if (int.parse(productModel.value.itemAttributes!.variants!
                                                  .where((element) => element.variantSku == variantInfo!.variantSku)
                                                  .first
                                                  .variantQuantity
                                                  .toString()) >
                                              productList.value.quantity ||
                                          int.parse(productModel.value.itemAttributes!.variants!
                                                  .where((element) => element.variantSku == variantInfo!.variantSku)
                                                  .first
                                                  .variantQuantity
                                                  .toString()) ==
                                              -1) {
                                        productQnt.value = productQnt.value + 1;
                                        addToCard(productList.value, productQnt.value, cartController);
                                      } else {
                                        ShowToastDialog.showToast("Item out of stock".tr);
                                      }
                                    } else {
                                      if (productModel.value.quantity! > productQnt.value || productModel.value.quantity == -1) {
                                        productQnt.value = productQnt.value + 1;
                                        addToCard(productList.value, productQnt.value, cartController);
                                      } else {
                                        ShowToastDialog.showToast("Item out of stock".tr);
                                      }
                                    }
                                  } else {
                                    if (productModel.value.quantity! > productQnt.value || productModel.value.quantity! == -1) {
                                      productQnt.value = productQnt.value + 1;
                                      addToCard(productList.value, productQnt.value, cartController);
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addToCard(CartProduct cartProduct, qun, CartController controller) async {
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
    unit: cartProduct.unit));
  }

  removeToCard(CartProduct cartProduct, qun, CartController controller) async {
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
}
