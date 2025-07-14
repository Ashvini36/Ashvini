import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/ui/search_screen/search_screen.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:ebasket_customer/widgets/all_product_list.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/view_all_product_controller.dart';
import 'package:ebasket_customer/app/ui/cart_screen/cart_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/round_button_fill.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';

class ViewAllCategoryProductScreen extends StatelessWidget {
  const ViewAllCategoryProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: ProductListController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: CommonUI.customAppBar(
                context,
                title: Text(controller.categoryName.toString().tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
                isBack: true,
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, bottom: 15),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(const SearchScreen(), transition: Transition.rightToLeftWithFade);
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_search_button.svg",
                                      height: 45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controller.productSearchList.isEmpty
                              ? Expanded(child: Constant.emptyView(image: "assets/icons/no_record.png", text: "Empty".tr, description: "You don’t have any products at this time"))
                              : Expanded(
                                  child: SizedBox(
                                    height: Responsive.height(65, context),
                                    child: GridView.builder(
                                      itemCount: controller.productSearchList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {},
                                          child: AllProductListWidget(
                                            trustedBrandItem: controller.productSearchList[index],
                                          ),
                                        );
                                      },
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: (2 / 3.9),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
              bottomNavigationBar: controller.isLoading.value
                  ? Constant.loader()
                  : StreamBuilder<List<CartProduct>>(
                      stream: controller.homeController.cartDatabase.value.watchProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasData) {
                          controller.cartProducts.value = snapshot.data!;

                          controller.cartCount.value = 0;
                          if (controller.cartProducts.isNotEmpty) {
                            for (var element in snapshot.data!) {
                              controller.cartCount.value += element.quantity;
                            }
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.update();
                          });
                          return controller.cartProducts.isEmpty
                              ? const SizedBox(
                                  height: 0,
                                  width: 0,
                                )
                              : SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppThemeData.groceryAppDarkBlue,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 20,
                                            offset: Offset(0, 0),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: SizedBox(
                                                          width: Responsive.width(25, context),
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Opacity(
                                                                opacity: 0.50,
                                                                child: Container(
                                                                  width: 65,
                                                                  height: 68,
                                                                  padding: const EdgeInsets.all(20),
                                                                  decoration: ShapeDecoration(
                                                                    color: Colors.white,
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 10,
                                                                child: Opacity(
                                                                  opacity: 0.50,
                                                                  child: Container(
                                                                    width: 65,
                                                                    height: 68,
                                                                    padding: const EdgeInsets.all(20),
                                                                    decoration: ShapeDecoration(
                                                                      color: Colors.white,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 20,
                                                                child: Opacity(
                                                                  opacity: 0.50,
                                                                  child: Container(
                                                                    width: 65,
                                                                    height: 68,
                                                                    padding: const EdgeInsets.all(20),
                                                                    decoration: ShapeDecoration(
                                                                      color: Colors.white,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 30,
                                                                child: Container(
                                                                  width: 65,
                                                                  height: 68,
                                                                  padding: const EdgeInsets.all(20),
                                                                  decoration: ShapeDecoration(
                                                                    color: Colors.white,
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                                                  ),
                                                                  child: NetworkImageWidget(
                                                                    height: Responsive.height(6, context),
                                                                    width: Responsive.width(30, context),
                                                                    imageUrl: controller.cartProducts[0].photo.toString(),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        "${controller.cartCount.value} Items".tr,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: AppThemeData.white,
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.regular,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Icon(
                                                        Icons.arrow_drop_up,
                                                        color: AppThemeData.white,
                                                        size: 16,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Center(
                                                  child: RoundedButtonFill(
                                                    width: 30,
                                                    title: "View Cart".tr,
                                                    fontSizes: 16,
                                                    textColor: AppThemeData.white,
                                                    fontFamily: AppThemeData.semiBold,
                                                    isRight: true,
                                                    icon: const Icon(
                                                      Icons.arrow_forward,
                                                      color: AppThemeData.white,
                                                    ),
                                                    onPress: () {
                                                      Get.to(const CartScreen(), transition: Transition.rightToLeftWithFade);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        } else {
                          return const SizedBox(
                            height: 0,
                            width: 0,
                          );
                        }
                      }));
        });
  }
}
