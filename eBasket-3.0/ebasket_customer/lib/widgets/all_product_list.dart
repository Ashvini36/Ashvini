import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/view_all_product_controller.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';

class AllProductListWidget extends StatefulWidget {
  final ProductModel trustedBrandItem;

  const AllProductListWidget({super.key, required this.trustedBrandItem});

  @override
  State<AllProductListWidget> createState() => _AllProductListWidgetState();
}

class _AllProductListWidgetState extends State<AllProductListWidget> {
  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  RxInt productQnt = 0.obs;
  RxDouble priceTemp = 0.0.obs;

  // ProductListController controller = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    Rx<ProductModel> trustedBrandItem = widget.trustedBrandItem.obs;
    return GetBuilder(
        init: ProductListController(),
        builder: (controller) {
          return InkWell(
            onTap: () {
              Get.to(const ProductDetailsScreen(), arguments: {
                "productModel": widget.trustedBrandItem,
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppThemeData.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19020202),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            StreamBuilder<List<CartProduct>>(
                                stream: controller.homeController.cartDatabase.value.watchProducts,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const SizedBox();
                                  } else if (snapshot.hasData) {
                                    cartProducts.value = snapshot.data!;

                                    trustedBrandItem.value.productQuantity = 0;
                                    if (cartProducts.isNotEmpty) {
                                      for (CartProduct cartProduct in cartProducts) {
                                        if (cartProduct.id == "${trustedBrandItem.value.id!}~") {
                                          trustedBrandItem.value.productQuantity = cartProduct.quantity;
                                          productQnt.value = cartProduct.quantity;
                                        }
                                      }
                                    }

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      controller.update();
                                    });
                                    return const SizedBox(
                                      height: 0,
                                      width: 0,
                                    );
                                  } else {
                                    return const SizedBox(
                                      height: 0,
                                      width: 0,
                                    );
                                  }
                                }),
                            Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(14)),
                                        child: NetworkImageWidget(
                                          height: Responsive.height(15, context),
                                          width: Responsive.width(25, context),
                                          imageUrl: widget.trustedBrandItem.photo.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trustedBrandItem.value.name.toString(),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              color: AppThemeData.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppThemeData.regular,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              widget.trustedBrandItem.qty_pack.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppThemeData.black.withOpacity(0.50),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppThemeData.semiBold,
                                              ),
                                            ),
                                          ),
                                          widget.trustedBrandItem.discount == "" || widget.trustedBrandItem.discount == "0"
                                              ? Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    Constant.amountShow(amount: widget.trustedBrandItem.price),
                                                    style: const TextStyle(
                                                        color: AppThemeData.black,
                                                        fontSize: 14,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: AppThemeData.semiBold,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        Constant.amountShow(
                                                            amount: Constant.calculateDiscount(amount: widget.trustedBrandItem.price!, discount: widget.trustedBrandItem.discount!)
                                                                .toString()),
                                                        style: const TextStyle(
                                                            color: AppThemeData.black,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontFamily: AppThemeData.semiBold,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        Constant.amountShow(amount: widget.trustedBrandItem.price),
                                                        style: TextStyle(
                                                            color: AppThemeData.black.withOpacity(0.50),
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.semiBold,
                                                            decoration: TextDecoration.lineThrough,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          if (trustedBrandItem.value.itemAttributes != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: trustedBrandItem.value.itemAttributes!.attributes!.length,
                                                  itemBuilder: (context, index) {
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets.zero,
                                                        itemCount: trustedBrandItem.value.itemAttributes!.attributes![index].attributeOptions!.length,
                                                        itemBuilder: (context, i) {
                                                          return ListView.builder(
                                                              shrinkWrap: true,
                                                              padding: EdgeInsets.zero,
                                                              itemCount: trustedBrandItem.value.itemAttributes!.variants!.length,
                                                              itemBuilder: (context, index1) {
                                                                Variants variants = trustedBrandItem.value.itemAttributes!.variants![index1];
                                                                return (trustedBrandItem.value.itemAttributes!.attributes![index].attributeOptions![i].toString() ==
                                                                        variants.variantSku.toString())
                                                                    ? InkWell(
                                                                        onTap: () async {},
                                                                        child: Text(
                                                                          " ${Constant.amountShow(amount: variants.variantPrice.toString())} for ${variants.variantSku.toString()}",
                                                                          textAlign: TextAlign.start,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                              color: AppThemeData.groceryAppDarkBlue,
                                                                              fontSize: 10,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              fontFamily: AppThemeData.bold,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      )
                                                                    : Container();
                                                              });
                                                        });
                                                  }),
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (Constant.currentUser.id != null) {
                                          var contain = controller.listFav.where((element) => element.productId == trustedBrandItem.value.id);

                                          if (contain.isNotEmpty) {
                                            for (int i = 0; i < controller.listFav.length; i++) {
                                              if (controller.listFav[i].productId == trustedBrandItem.value.id) {
                                                FavouriteItemModel favouriteModel =
                                                    FavouriteItemModel(id: controller.listFav[i].id, productId: trustedBrandItem.value.id, userId: FireStoreUtils.getCurrentUid());
                                                FireStoreUtils.removeFavouriteItem(favouriteModel);
                                                controller.listFav.removeAt(i);
                                              }
                                            }
                                          } else {
                                            FavouriteItemModel favouriteModel =
                                                FavouriteItemModel(id: Constant.getUuid(), productId: trustedBrandItem.value.id, userId: FireStoreUtils.getCurrentUid());
                                            FireStoreUtils.addFavouriteItem(favouriteModel);
                                            controller.listFav.add(favouriteModel);
                                          }
                                        } else {
                                          Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                                        }
                                      });
                                    },
                                    child: controller.listFav.where((element) => element.productId == trustedBrandItem.value.id).isNotEmpty
                                        ? Icon(
                                            Icons.favorite,
                                            color: AppThemeData.groceryAppDarkBlue,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            color: AppThemeData.groceryAppDarkBlue,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      trustedBrandItem.value.productQuantity == 0 || trustedBrandItem.value.productQuantity == -1
                          ? InkWell(
                              onTap: () {
                                if (Constant.currentUser.id != null) {
                                  productQnt.value = 1;
                                  trustedBrandItem.value.productQuantity = 1;
                                  setState(() {});
                                  addToCard(trustedBrandItem.value, true, controller);
                                } else {
                                  Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                child: Container(
                                  height: Responsive.height(5, context),
                                  width: Responsive.width(100, context),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppThemeData.groceryAppDarkBlue,
                                      width: 2,
                                    ),
                                    color: AppThemeData.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Add To Cart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.medium,
                                        color: AppThemeData.groceryAppDarkBlue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: Responsive.height(6, context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (productQnt.value > 0) {
                                              productQnt.value = productQnt.value - 1;
                                              trustedBrandItem.value.productQuantity = trustedBrandItem.value.productQuantity! - 1;
                                              removeToCard(trustedBrandItem.value, true, controller);
                                            }
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
                                      width: 10,
                                    ),
                                    Obx(
                                      () => SizedBox(
                                        width: Responsive.width(5.5, context),
                                        child: Text(
                                          "${trustedBrandItem.value.productQuantity}",
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
                                          setState(() {
                                            if (trustedBrandItem.value.quantity! > productQnt.value || trustedBrandItem.value.quantity! == -1) {
                                              setState(() {
                                                productQnt.value++;
                                              });
                                              addToCard(trustedBrandItem.value, true, controller);
                                            } else {
                                              ShowToastDialog.showToast("Item out of stock");
                                            }
                                          });
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
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  addToCard(ProductModel productModel, bool isIncrementQuantity, ProductListController controller) async {
    List<CartProduct> cartProducts = await controller.homeController.cartDatabase.value.allCartProducts;
    if (productQnt.value > 1) {
      String mainPrice = "";

      if (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) {
        mainPrice = Constant.calculateDiscount(amount: productModel.price!, discount: productModel.discount!).toString();
      } else {
        mainPrice = productModel.price!;
      }
      final bool productIsInList = cartProducts.any((product) => product.id == "${productModel.id!}~");

      if (productIsInList) {
        CartProduct element = cartProducts.firstWhere((product) => product.id == "${productModel.id!}~");

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
            // id: "${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}",
            id: "${productModel.id!}~",
            name: productModel.name!,
            photo: productModel.photo!,
            price: productModel.price!,
            discountPrice: productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0 ? mainPrice : '0',
            quantity: productModel.quantity!,
            category_id: productModel.categoryID!,
            hsn_code: productModel.hsn_code!,
            description: productModel.description!,
            discount: productModel.discount!,
            unit: productModel.unit!,
            variant_info: productModel.variantInfo));
      }
      setState(() {});
    } else {
      controller.homeController.cartDatabase.value.addProduct(productModel, controller.homeController.cartDatabase.value, isIncrementQuantity);
    }
    updatePrice(controller);
  }

  void updatePrice(ProductListController controller) {
    List<CartProduct> cartProducts = [];
    Future.delayed(const Duration(milliseconds: 500), () {
      cartProducts.clear();

      controller.homeController.cartDatabase.value.allCartProducts.then((value) {
        priceTemp.value = 0;
        cartProducts.addAll(value);
        for (int i = 0; i < cartProducts.length; i++) {
          CartProduct e = cartProducts[i];

          priceTemp.value += double.parse(e.price) * e.quantity;
          setState(() {});
        }
      });
    });
  }

  removeToCard(ProductModel productModel, bool isIncrementQuantity, ProductListController controller) async {
    List<CartProduct> cartProducts = await controller.homeController.cartDatabase.value.allCartProducts;
    if (productQnt.value >= 1) {
      String mainPrice = "";

      if (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) {
        mainPrice = Constant.calculateDiscount(amount: productModel.price!, discount: productModel.discount!).toString();
      } else {
        mainPrice = productModel.price!;
      }
      final bool productIsInList = cartProducts.any((product) => product.id == "${productModel.id!}~");

      if (productIsInList) {
        CartProduct element = cartProducts.firstWhere((product) => product.id == "${productModel.id!}~");

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
      } else {
        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: "${productModel.id!}~",
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
      }
    } else {
      controller.homeController.cartDatabase.value.removeProduct("${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}");

      setState(() {
        productQnt.value = 0;
      });
    }

    setState(() {});
    updatePrice(controller);
  }
}
