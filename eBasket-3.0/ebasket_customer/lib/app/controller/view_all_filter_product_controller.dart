import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';

class FilterProductController extends GetxController {
  RxBool isLoading = true.obs;
  //RxList<String> selectedBrandId = <String>[].obs;
  RxList<Map<String, dynamic>> selectedBrandId = <Map<String, dynamic>>[].obs;
  //RxList<String> selectedCategoryId = <String>[].obs;
  RxList<Map<String, dynamic>> selectedCategoryId = <Map<String, dynamic>>[].obs;
  RxList<ProductModel> filterProductList = <ProductModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  RxInt cartCount = 0.obs;
  HomeController homeController = Get.find<HomeController>();
 RxList<String> title = <String>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    dynamic argumentData = Get.arguments;
    productList.clear();
    filterProductList.clear();
    title.clear();
    if (argumentData != null) {
      if (argumentData['product'] != null) {
        await FireStoreUtils.getAllDeliveryProducts().then((value) {
          if (value != null) {
            productList.value = value;
            filterProductList.value = productList
                .where((e) => e.name!.toLowerCase().contains(argumentData['product'].toString().toLowerCase()) || e.name!.startsWith(argumentData['product'].toString()))
                .toList();
          }
        });
      } else if (argumentData['selectedBrandId'] != null) {
        selectedBrandId.value = argumentData['selectedBrandId'];
        for (int i = 0; i < selectedBrandId.length; i++) {
          title.add(selectedBrandId[i]['name'].toString());
          await FireStoreUtils.getProductListByBrandId(selectedBrandId[i]['id'].toString()).then((value) {
            if (value != null) {
              // filterProductList.value = (value);
              // productList.value = (value);
              filterProductList.addAll(value);
              productList.addAll(value);
            }
          });
        }
      } else if (argumentData['selectedCategoryId'] != null) {
        selectedCategoryId.value = argumentData['selectedCategoryId'];
        for (int i = 0; i < selectedCategoryId.length; i++) {
          title.add(selectedCategoryId[i]['name'].toString());
          await FireStoreUtils.getProductListByCategoryId(selectedCategoryId[i]['id'].toString()).then((value) {
            if (value != null) {
              filterProductList.addAll(value);
              productList.addAll(value);
            }
          });
        }
      } else if (argumentData['minPrice'] != null && argumentData['maxPrice'] != null) {
        title.add('${double.parse(argumentData['minPrice'].toString()).round()} - ${double.parse(argumentData['maxPrice'].toString()).round()}');
        await FireStoreUtils.getAllDeliveryProducts().then((value) {
          if (value != null) {
            for (int i = 0; i < value.length; i++) {
              if ((double.parse(value[i].price.toString()) >= double.parse(argumentData['minPrice'].toString())) &&
                  (double.parse(value[i].price.toString()) <= double.parse(argumentData['maxPrice'].toString()))) {
                filterProductList.add(value[i]);
                productList.add(value[i]);
              }
            }
          }
        });
      } else if (argumentData['minDiscount'] != null && argumentData['maxDiscount'] != null) {
        title.add('${double.parse(argumentData['minDiscount'].toString()).round()} - ${double.parse(argumentData['maxDiscount'].toString()).round()}');

        await FireStoreUtils.getAllDeliveryProducts().then((value) {
          if (value != null) {
            for (int i = 0; i < value.length; i++) {
              if ((double.parse(value[i].discount.toString()) >= double.parse(argumentData['minDiscount'].toString())) &&
                  (double.parse(value[i].discount.toString()) <= double.parse(argumentData['maxDiscount'].toString()))) {
                filterProductList.add(value[i]);
                productList.add(value[i]);
              }
            }
          }
        });
      }
    }

    update();

    isLoading.value = false;
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      filterProductList.value = productList.where((e) => e.name!.toLowerCase().contains(value.toLowerCase().toString()) || e.name!.startsWith(value.toString())).toList();
    } else {
      filterProductList.value = productList;
    }
    update();
  }
}
