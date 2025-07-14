import 'package:ebasket_customer/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  RxBool isLoading = true.obs;

  RxList<FavouriteItemModel> listFavourite = <FavouriteItemModel>[].obs;
  RxList<ProductModel> favProductList = <ProductModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  RxBool isServiceAvailable = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    listFavourite.clear();
    favProductList.clear();
    productList.clear();
    if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance)) {
      if (Constant.currentUser.id != null) {
        await FireStoreUtils.getFavouritesProductList(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            listFavourite.value = value;
          }
          update();
        });
      }
      await FireStoreUtils.getAllDeliveryProducts().then((value) {
        if (value != null) {
          for (var element in listFavourite) {
            final bool productIsInList = value.any((product) => product.id == element.productId);
            if (productIsInList) {
              ProductModel productModel = value.firstWhere((product) => product.id == element.productId);
              productList.add(productModel);
              productList.value = productList.toSet().toList();
              favProductList.value = productList;
            }
          }
        }
      });
    } else {
      isServiceAvailable.value = false;
    }

    isLoading.value = false;
    update();
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      favProductList.value = productList.where((e) => e.name!.toLowerCase().contains(value.toLowerCase().toString()) || e.name!.startsWith(value.toString())).toList();
    } else {
      favProductList.value = productList;
    }
    update();
  }
}
