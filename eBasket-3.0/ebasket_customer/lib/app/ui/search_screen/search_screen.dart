import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/model/brands_model.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/app/ui/view_all_filter_product_screen/view_all_filter_product_screen.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/rangleSliderThumbShape.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/search_controller.dart';
import 'package:ebasket_customer/app/model/search_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = Responsive.height(65, context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GetX(
        init: SearchScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: CommonUI.customAppBar(
                context,
                title:  Text("Find Your Grocery".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
                isBack: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: InkWell(
                      onTap: () {
                        controller.searchTextFiledController.value.text = '';
                        controller.selectedBrandId.value = [];
                        controller.selectedCategoryId.value = [];
                        controller.categorySearchList.value = controller.allCategoryList;
                        controller.brandSearchList.value = controller.allBrandList;
                        controller.discountSearchList.value = controller.allDiscountList;
                        controller.selectedStartValue.value = 0.0;
                        controller.selectedEndValue.value = 0.0;
                        //controller.selectedGrocery.value = '';
                        for (var element in controller.categorySearchList) {
                          element.checked = false;
                        }
                        for (var element in controller.brandSearchList) {
                          element.checked = false;
                        }

                        controller.update();
                      },
                      child:  Text(
                        "Clear All".tr,
                        style: TextStyle(color: AppThemeData.colorRed, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Column(children: [
                      const Divider(),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: Responsive.width(40, context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: controller.searchModel.value.searchHistory!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Responsive.width(40, context),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                        color:
                                                            controller.selectedGrocery.value.toString() == controller.searchModel.value.searchHistory![index].searchName.toString()
                                                                ? AppThemeData.groceryAppDarkBlue
                                                                : AppThemeData.white,
                                                        width: 1),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        controller.searchTextFiledController.value.text = '';
                                                        //    controller.selectedBrandId.value = [];
                                                        //   controller.selectedCategoryId.value = [];
                                                        controller.selectedGrocery.value = controller.searchModel.value.searchHistory![index].searchName.toString();
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                                                      child: Text(
                                                        controller.searchModel.value.searchHistory![index].searchName.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily: AppThemeData.regular,
                                                            color: controller.selectedGrocery.value.toString() ==
                                                                    controller.searchModel.value.searchHistory![index].searchName.toString()
                                                                ? AppThemeData.groceryAppDarkBlue
                                                                : AppThemeData.black),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                                child: Column(children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: controller.searchModel.value.category!.length,
                                      itemBuilder: (context, index) {
                                        Category category = controller.searchModel.value.category![index];
                                        return (category.title.toString() == controller.selectedGrocery.value)
                                            ? (category.title.toString() == 'Price Range')
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                                        alignment: Alignment.centerLeft,
                                                        /*child: FlutterSlider(
                                                            values: [controller.startValue.value, controller.endValue.value],
                                                            rangeSlider: true,
                                                            max: 5000,
                                                            min: 0,
                                                            jump: true,

                                                            trackBar: FlutterSliderTrackBar(
                                                              activeTrackBarHeight: 5,
                                                              inactiveTrackBarHeight: 5,
                                                              activeTrackBar: BoxDecoration(color: AppThemeData.colorSliderBarPrimary, borderRadius: BorderRadius.circular(15)),
                                                              inactiveTrackBar: BoxDecoration(color: AppThemeData.colorSliderBar, borderRadius: BorderRadius.circular(15)),
                                                            ),

                                                            tooltip: FlutterSliderTooltip(
                                                              //  alwaysShowTooltip: true,
                                                              textStyle: const TextStyle(fontSize: 17, color: AppThemeData.colorGrey),
                                                            ),

                                                            handler: FlutterSliderHandler(
                                                              decoration: const BoxDecoration(),
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(color: AppThemeData.colorSliderBarPrimary, borderRadius: BorderRadius.circular(15)),
                                                                padding: const EdgeInsets.all(5),
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(color: AppThemeData.white, borderRadius: BorderRadius.circular(15)),
                                                                ),
                                                              ),
                                                            ),
                                                            rightHandler: FlutterSliderHandler(
                                                              decoration: const BoxDecoration(),
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(color: AppThemeData.colorSliderBarPrimary, borderRadius: BorderRadius.circular(15)),
                                                                padding: const EdgeInsets.all(5),
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(color: AppThemeData.white, borderRadius: BorderRadius.circular(15)),
                                                                ),
                                                              ),
                                                            ),
                                                            disabled: false,
                                                            onDragging: (handlerIndex, lowerValue, upperValue) {
                                                              setState(() {
                                                                controller.startValue.value = lowerValue;
                                                                controller.endValue.value = upperValue;
                                                              });
                                                            },
                                                          )*/
                                                        child: SliderTheme(
                                                          data: const SliderThemeData(
                                                            rangeThumbShape: CircleThumbShape(),
                                                          ),
                                                          child: RangeSlider(
                                                            activeColor: AppThemeData.colorSliderBarPrimary,
                                                            inactiveColor: AppThemeData.colorSliderBar,
                                                            values: RangeValues(controller.startValue.value, controller.endValue.value),
                                                            labels: RangeLabels(controller.startValue.value.round().toString(), controller.endValue.value.round().toString()),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                controller.startValue.value = value.start;
                                                                controller.endValue.value = value.end;
                                                                controller.selectedStartValue.value = controller.startValue.value;
                                                                controller.selectedEndValue.value = controller.endValue.value;
                                                              });
                                                            },
                                                            min: 0.0,
                                                            max: 5000.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Obx(
                                                        () => controller.selectedStartValue.value != 0.0 || controller.selectedEndValue.value != 0.0
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(16),
                                                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                                  child: Text('${controller.selectedStartValue.value.round()} - ${controller.selectedEndValue.value.round()}'),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      )
                                                    ],
                                                  )
                                                : SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        if (category.title.toString() == 'Brand')
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: TextFieldWidget(
                                                              controller: controller.searchTextFiledController.value,
                                                              hintText: "Search".tr,
                                                              enable: true,
                                                              onChanged: (value) {
                                                                controller.getFilterData(controller.searchTextFiledController.value.text.toString(), category.title.toString());
                                                                setState(() {});
                                                                return null;
                                                              },
                                                              prefix: Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: SvgPicture.asset("assets/icons/ic_search.svg", height: 22, width: 22),
                                                              ),
                                                            ),
                                                          ),
                                                        (category.title.toString() == 'Category')
                                                            ? Obx(
                                                                () => SizedBox(
                                                                  height: screenHeight - keyboardHeight,
                                                                  child: controller.categorySearchList.isEmpty
                                                                      ? Constant.showEmptyView(message: "Category Not Found".tr)
                                                                      : ListView.builder(
                                                                          shrinkWrap: true,
                                                                          scrollDirection: Axis.vertical,
                                                                          itemCount: controller.categorySearchList.length,
                                                                          itemBuilder: (context, index) {
                                                                            CategoryModel category = controller.categorySearchList[index];
                                                                            return CheckboxListTile(
                                                                              dense: true,
                                                                              side:  BorderSide(color: AppThemeData.groceryAppDarkBlue),
                                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                                                              secondary: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                child: Image.network(category.photo.toString(), width: 40, height: 40, fit: BoxFit.cover),
                                                                              ),
                                                                              title: Text(
                                                                                category.title.toString(),
                                                                                style: const TextStyle(fontSize: 12, fontFamily: AppThemeData.regular, color: AppThemeData.black),
                                                                              ),
                                                                              value: category.checked,
                                                                              onChanged: (val) {
                                                                                setState(() {
                                                                                  category.checked = val!;
                                                                                  if (category.checked == true) {
                                                                                    //  controller.selectedCategoryId.add(category.id.toString());
                                                                                    controller.selectedCategoryId.add({
                                                                                      'id': category.id.toString(),
                                                                                      'name': category.title.toString(),
                                                                                    });
                                                                                    controller.selectedCategoryId.toSet().toList();
                                                                                  } else {
                                                                                    // controller.selectedCategoryId.remove(category.id.toString());
                                                                                    controller.selectedCategoryId
                                                                                        .removeWhere((element) => element['id'].toString() == category.id.toString());
                                                                                  }
                                                                                });
                                                                              },
                                                                              activeColor: AppThemeData.groceryAppDarkBlue,
                                                                            );
                                                                          }),
                                                                ),
                                                              )
                                                            : (category.title.toString() == 'Brand')
                                                                ? Obx(
                                                                    () => SizedBox(
                                                                      height: screenHeight - keyboardHeight,
                                                                      child: controller.brandSearchList.isEmpty
                                                                          ? Constant.showEmptyView(message: "Brand Not Found".tr)
                                                                          : ListView.builder(
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.vertical,
                                                                              itemCount: controller.brandSearchList.length,
                                                                              itemBuilder: (context, index) {
                                                                                BrandsModel brandModel = controller.brandSearchList[index];
                                                                                return CheckboxListTile(
                                                                                  dense: true,
                                                                                  side:  BorderSide(color: AppThemeData.groceryAppDarkBlue),
                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                                                                  title: Padding(
                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                    child: Text(
                                                                                      brandModel.title.toString(),
                                                                                      style: const TextStyle(
                                                                                          fontSize: 12, fontFamily: AppThemeData.regular, color: AppThemeData.black),
                                                                                    ),
                                                                                  ),
                                                                                  value: brandModel.checked,
                                                                                  onChanged: (val) {
                                                                                    setState(() {
                                                                                      brandModel.checked = val!;
                                                                                      if (brandModel.checked == true) {
                                                                                        //controller.selectedBrandId.add(brandModel.id.toString());

                                                                                        controller.selectedBrandId.add({
                                                                                          'id': brandModel.id.toString(),
                                                                                          'name': brandModel.title.toString(),
                                                                                        });
                                                                                        controller.selectedBrandId.toSet().toList();
                                                                                      } else {
                                                                                        // controller.selectedBrandId.remove(brandModel.id.toString());
                                                                                        controller.selectedBrandId
                                                                                            .removeWhere((element) => element['id'].toString() == brandModel.id.toString());
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  activeColor: AppThemeData.groceryAppDarkBlue,
                                                                                );
                                                                              }),
                                                                    ),
                                                                  )
                                                                :
                                                                //   (category.title.toString() == 'Discount') ?
                                                                Obx(
                                                                    () => SizedBox(
                                                                      height: screenHeight - keyboardHeight,
                                                                      child: controller.discountSearchList.isEmpty
                                                                          ? Constant.showEmptyView(message: "Discount Not Found".tr)
                                                                          : ListView.builder(
                                                                              shrinkWrap: true,
                                                                              padding: EdgeInsets.zero,
                                                                              scrollDirection: Axis.vertical,
                                                                              itemCount: controller.discountSearchList.length,
                                                                              itemBuilder: (context, index1) {
                                                                                CategoriesItem categoryItem = controller.discountSearchList[index1];

                                                                                return Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    RadioListTile(
                                                                                      value: index1,
                                                                                      groupValue: controller.selectedDiscount.value,
                                                                                      controlAffinity: ListTileControlAffinity.trailing,
                                                                                      activeColor: AppThemeData.groceryAppDarkBlue,
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          controller.selectedDiscount.value = int.parse(value.toString());
                                                                                          controller.minDiscount.value = categoryItem.minDiscount.toString();
                                                                                          controller.maxDiscount.value = categoryItem.maxDiscount.toString();
                                                                                        });
                                                                                      },
                                                                                      title: Text(
                                                                                          '${categoryItem.minDiscount.toString()}% to ${categoryItem.maxDiscount.toString()}%',
                                                                                          style: const TextStyle(
                                                                                              fontSize: 12, fontFamily: AppThemeData.regular, color: AppThemeData.black)),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              }),
                                                                    ),
                                                                  ),
                                                      ],
                                                    ),
                                                  )
                                            : Container();
                                      }),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemeData.white,
                                  elevation: 0.0,
                                  padding: const EdgeInsets.all(8),
                                  side:  BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 2),
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
                                    style:  TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
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
                                  side:  BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 0.4),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(60),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (controller.selectedGrocery.value == 'Brand') {
                                    if (controller.selectedBrandId.isNotEmpty) {
                                      Get.to(const ViewAllFilterProductScreen(),
                                          arguments: {
                                            "selectedBrandId": controller.selectedBrandId,
                                          },
                                          transition: Transition.rightToLeftWithFade);
                                    }
                                    // else {
                                    //   ShowToastDialog.showToast('Select Brand');
                                    // }
                                  } else if (controller.selectedGrocery.value == 'Category') {
                                    if (controller.selectedCategoryId.isNotEmpty) {
                                      Get.to(const ViewAllFilterProductScreen(),
                                          arguments: {
                                            "selectedCategoryId": controller.selectedCategoryId,
                                          },
                                          transition: Transition.rightToLeftWithFade);
                                    }
                                  } else if (controller.selectedGrocery.value == 'Price Range') {
                                    Get.to(const ViewAllFilterProductScreen(),
                                        arguments: {"minPrice": controller.startValue.toString(), "maxPrice": controller.endValue.toString()},
                                        transition: Transition.rightToLeftWithFade);
                                  } else if (controller.selectedGrocery.value == 'Discount') {
                                    Get.to(const ViewAllFilterProductScreen(),
                                        arguments: {"minDiscount": controller.minDiscount.toString(), "maxDiscount": controller.maxDiscount.toString()},
                                        transition: Transition.rightToLeftWithFade);
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: Text(
                                    'Apply'.tr,
                                    style: const TextStyle(color: AppThemeData.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]));
        });
  }
}
