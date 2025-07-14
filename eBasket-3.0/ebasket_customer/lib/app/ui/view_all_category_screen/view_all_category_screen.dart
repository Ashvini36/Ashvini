import 'package:ebasket_customer/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/ui/view_all_category_product_screen/view_all_category_product_screen.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/view_all_category_controller.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';

class ViewAllCategoryListScreen extends StatelessWidget {
  const ViewAllCategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: CategoryListController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(
              context,
              title: Text("Category".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              isBack: true,
              onBackTap: () {
                Get.back();
              },
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.categoryList.isEmpty
                    ?  controller.isServiceAvailable.value ? Constant.emptyView(image: "assets/icons/no_data.png", text: "No Data Found".tr) : EmptyData()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: GridView.builder(
                          itemCount: controller.categoryList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            CategoryModel categoryItem = controller.categoryList[index];
                            return CategoryItemWidget(
                              categoryItem: categoryItem,
                            );
                          },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            childAspectRatio: (2 / 1.5),
                          ),
                        ),
                      ),
          );
        });
  }
}

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel categoryItem;

  const CategoryItemWidget({super.key, required this.categoryItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const ViewAllCategoryProductScreen(), arguments: {"categoryId": categoryItem.id, "categoryName": categoryItem.title});
      },
      child: Center(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              child: NetworkImageWidget(
                height: Responsive.height(40, context),
                width: Responsive.width(42, context),
                imageUrl: categoryItem.photo.toString(),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: Responsive.height(40, context),
              width: Responsive.width(42, context),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.40),
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
            ),
            Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  categoryItem.title.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppThemeData.white,
                    fontSize: 20,
                    fontFamily: AppThemeData.semiBold,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
