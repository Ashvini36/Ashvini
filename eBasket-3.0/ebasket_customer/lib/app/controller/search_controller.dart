import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/brands_model.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/search_model.dart';
import 'package:ebasket_customer/constant/constant.dart';

class SearchScreenController extends GetxController {
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  Rx<SearchModel> searchModel = SearchModel().obs;
  RxBool isLoading = true.obs;
  RxInt selectedDiscount = 0.obs;

  RxDouble startValue = 0.0.obs;
  RxDouble endValue = 5000.0.obs;
  RxDouble selectedStartValue = 0.0.obs;
  RxDouble selectedEndValue = 0.0.obs;
  RxList<BrandsModel> allBrandList = <BrandsModel>[].obs;
  // RxList<String> selectedBrandId = <String>[].obs;
  RxList<Map<String, dynamic>> selectedBrandId = <Map<String, dynamic>>[].obs;
  RxList<BrandsModel> brandSearchList = <BrandsModel>[].obs;
  RxList<CategoryModel> allCategoryList = <CategoryModel>[].obs;
 // RxList<String> selectedCategoryId = <String>[].obs;
  RxList<Map<String, dynamic>> selectedCategoryId = <Map<String, dynamic>>[].obs;
  RxList<CategoryModel> categorySearchList = <CategoryModel>[].obs;
  RxString selectedGrocery = 'Price Range'.obs;
  RxString minDiscount = '5'.obs;
  RxString maxDiscount = '10'.obs;
  RxList<CategoriesItem> allDiscountList = <CategoriesItem>[].obs;
  RxList<CategoriesItem> discountSearchList = <CategoriesItem>[].obs;

  RangeValues currentRangeValues =  const RangeValues(0.0, 5000);

  @override
  void onInit() {
    // TODO: implement onInit
    loadJson();
    getData();
    super.onInit();
  }

  loadJson() async {
    await Constant.loadJson(path: Constant.searchHistoryJson).then((value) {
      searchModel.value = SearchModel.fromJson(value);
    });
    isLoading.value = false;
  }

  getData() async {
    await FireStoreUtils.getBrands().then((value) {
      if (value != null) {
        allBrandList.value = value;
        brandSearchList.value = value;
      }
    });

    await FireStoreUtils.getCategories().then((value) {
      if (value != null) {
        allCategoryList.value = value;
        categorySearchList.value = value;
      }
    });
    for (var element in searchModel.value.category!) {
      if (element.title == 'Discount') {
        allDiscountList.value = element.categoriesItem!;
        discountSearchList.value = element.categoriesItem!;
      }
    }
    update();
  }

  getFilterData(String value, String title) async {
    if (title == 'Brand') {
      if (value.toString().isNotEmpty) {
        brandSearchList.value = allBrandList.where((e) => e.title!.toLowerCase().contains(value.toLowerCase().toString()) || e.title!.startsWith(value.toString())).toList();
      } else {
        brandSearchList.value = allBrandList;
      }
      update();
    }
    if (title == 'Category') {
      if (value.toString().isNotEmpty) {
        categorySearchList.value = allCategoryList.where((e) => e.title!.toLowerCase().contains(value.toLowerCase().toString()) || e.title!.startsWith(value.toString())).toList();
      } else {
        categorySearchList.value = allCategoryList;
      }
      update();
    }
    if (title == 'Discount') {
      if (value.toString().isNotEmpty) {
        discountSearchList.value = allDiscountList
            .where((e) =>
                e.minDiscount!.toLowerCase().contains(value.toLowerCase().toString()) ||
                e.minDiscount!.startsWith(value.toString()) ||
                e.maxDiscount!.toLowerCase().contains(value.toLowerCase().toString()) ||
                e.maxDiscount!.startsWith(value.toString()))
            .toList();
      } else {
        discountSearchList.value = allDiscountList;
      }
      update();
    }
  }
}
