import 'package:ebasket_customer/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/favourite_controller.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: FavouriteController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(
              context,
              title: Text("Favorites".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              isBack: true,
              onBackTap: () {
                Get.back();
              },
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.listFavourite.isEmpty
                    ? controller.isServiceAvailable.value
                        ? Constant.emptyView(image: "assets/icons/no_data.png", text: "No Data Found".tr)
                        : EmptyData()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                        child: Column(children: [
                          TextFieldWidget(
                            controller: controller.searchTextFiledController.value,
                            hintText: "Search".tr,
                            enable: true,
                            onChanged: (value) {
                              controller.getFilterData(controller.searchTextFiledController.value.text.toString());
                              controller.update();
                              return null;
                            },
                            prefix: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset("assets/icons/ic_search.svg", height: 22, width: 22),
                            ),
                          ),
                          Expanded(
                            child: controller.favProductList.isEmpty
                                ? Constant.emptyView(image: "assets/icons/no_data.png", text: "No Data Found".tr)
                                : ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: controller.favProductList.length,
                                    itemBuilder: (context, index) {
                                      ProductModel product = controller.favProductList[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 7),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(const ProductDetailsScreen(), arguments: {
                                              "productModel": product,
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: Colors.grey.shade100, width: 1),
                                              color: AppThemeData.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x3F000000),
                                                  blurRadius: 2,
                                                  offset: Offset(0, 0),
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                        imageUrl: product.photo.toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                product.name.toString(),
                                                                textAlign: TextAlign.center,
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                    color: AppThemeData.black,
                                                                    fontSize: 12,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    fontFamily: AppThemeData.regular,
                                                                    fontWeight: FontWeight.w400),
                                                              ),
                                                              product.discount == "" || product.discount == "0"
                                                                  ? Padding(
                                                                      padding: const EdgeInsets.only(top: 4.0),
                                                                      child: Text(
                                                                        Constant.amountShow(amount: product.price),
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
                                                                                amount: Constant.calculateDiscount(amount: product.price!, discount: product.discount!).toString()),
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
                                                                            Constant.amountShow(amount: product.price),
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
                                                              product.itemAttributes != null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets.only(top: 4.0),
                                                                      child: ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: product.itemAttributes!.variants!.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Text(
                                                                              "${Constant.currencyModel!.symbol}${product.itemAttributes!.variants![index].variantPrice.toString()} for ${product.itemAttributes!.variants![index].variantSku.toString()} ",
                                                                              textAlign: TextAlign.start,
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                  color: AppThemeData.groceryAppDarkBlue,
                                                                                  fontSize: 10,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  fontFamily: AppThemeData.bold,
                                                                                  fontWeight: FontWeight.w700),
                                                                            );
                                                                          }),
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            for (var element in controller.listFavourite) {
                                                              if (element.productId == product.id) {
                                                                removeItemBottomSheet(context, product.id.toString(), element.id.toString());
                                                              }
                                                            }
                                                          },
                                                          child: controller.listFavourite.where((element) => element.productId == product.id).isNotEmpty
                                                              ? Icon(
                                                                  Icons.favorite,
                                                                  color: AppThemeData.groceryAppDarkBlue,
                                                                )
                                                              : Icon(
                                                                  Icons.favorite_border,
                                                                  color: AppThemeData.groceryAppDarkBlue,
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                        ]),
                      ),
          );
        });
  }
}

removeItemBottomSheet(BuildContext context, String? productId, String? favoriteId) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return GetBuilder<FavouriteController>(builder: (controller) {
          return Container(
            height: Get.height * 0.3,
            color: AppThemeData.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'Remove From Favorite'.tr,
                      style: TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 24, color: AppThemeData.black),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text("Are you sure you want to".tr,
                        maxLines: 2, style: TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
                  ),
                  Center(
                    child: Text("remove this favorite?".tr,
                        maxLines: 2, style: TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: AppThemeData.white,
                            padding: const EdgeInsets.all(8),
                            side: BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 2),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              'Cancel'.tr,
                              style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: AppThemeData.groceryAppDarkBlue,
                            padding: const EdgeInsets.all(8),
                            side: BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 0.4),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                          ),
                          onPressed: () {
                            FavouriteItemModel favouriteModel = FavouriteItemModel(id: favoriteId, productId: productId, userId: FireStoreUtils.getCurrentUid());
                            controller.listFavourite.removeWhere((item) => item.productId == productId);
                            FireStoreUtils.removeFavouriteItem(favouriteModel).then((value) {
                              Get.back();
                              controller.getData();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              'Yes, remove'.tr,
                              style: const TextStyle(color: AppThemeData.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      });
}
