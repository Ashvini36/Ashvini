import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/attributes_model.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> productSearchList = <ProductModel>[].obs;
  RxList<String> selectedBrandId = <String>[].obs;

  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  RxInt cartCount = 0.obs;
  RxString categoryId = '0'.obs;
  RxString categoryName = ''.obs;
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  RxList<FavouriteItemModel> listFav = <FavouriteItemModel>[].obs;
  HomeController homeController = Get.find<HomeController>();
  RxString type = ''.obs;
  RxList<Attributes>? attributes = <Attributes>[].obs;
  RxList<Variants>? variants = <Variants>[].obs;
  RxList<String> selectedVariants = <String>[].obs;
  RxList<String> selectedIndexVariants = <String>[].obs;
  RxList<String> selectedIndexArray = <String>[].obs;
  RxList<AttributesModel> attributesList = <AttributesModel>[].obs;
  RxInt selectedVariantIndex = 0.obs;
  RxList<String> tempProduct = <String>[].obs;
  RxList<CartProduct> tempCartProducts = <CartProduct>[].obs;

  @override
  void onInit() {
    getData();
    getFavoriteData();
    super.onInit();
  }

  getData() async {
    dynamic argumentData = Get.arguments;
    selectedVariantIndex.value = -1;
    if (argumentData['categoryId'] != null) {
      categoryId.value = argumentData['categoryId'];
      categoryName.value = argumentData['categoryName'];

      await FireStoreUtils.getProductListByCategoryId(categoryId.value).then((value) {
        if (value != null) {
          productList.value = (value);
          productSearchList.value = (value);
        }
      });
      isLoading.value = false;
    } else if (argumentData['type'] != null) {
      type.value = argumentData['type'];

      if (type.value == 'brand') {
         FireStoreUtils.getEstablishBrandProducts().then((value) {
          if (value != null) {
            for (var element in value) {
              if (element.brandID != null) {
                productList.value = value;
                productSearchList.value = value;
              }
            }
          }
        });

      } else if (type.value == 'checkoutBrand') {
        tempCartProducts.value = await homeController.cartDatabase.value.allCartProducts;
        for (int i = 0; i < tempCartProducts.length; i++) {
          tempProduct.add(tempCartProducts[i].id.toString());
        }
        // FireStoreUtils.getEstablishBrandProducts().then((value) {
        FireStoreUtils.getAllDeliveryProducts().then((value) {
          if (value != null) {
            for (var element in value) {
              if (element.brandID != null) {
                if (!tempProduct.contains('${element.id!}~')) {
                  productList.add(element);
                  productSearchList.add(element);
                  // productList.value = value;
                  // productSearchList.value = value;
                }
              }
            }
          }
        });
      } else {
        FireStoreUtils.getBestOfferProducts().then((value) {
          if (value != null) {
            productList.value = value;
            productSearchList.value = value;
          }
        });
      }

      isLoading.value = false;
    }
    await FireStoreUtils.getVendorAttribute().then((value) {
      if (value != null) {
        attributesList.value = value;
      }
      update();
    });
    update();
  }

  getFavoriteData() async {
    await FireStoreUtils.getFavouritesProductList(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        listFav.value = value;
      }
    });
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      productSearchList.value = productList.where((e) => e.name!.toLowerCase().contains(value.toLowerCase().toString()) || e.name!.startsWith(value.toString())).toList();
    } else {
      productSearchList.value = productList;
    }
    update();
  }
}
