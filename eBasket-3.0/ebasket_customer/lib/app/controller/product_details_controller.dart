import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/attributes_model.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/variant_info.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  var pageController = PageController(initialPage: 0, viewportFraction: 0.90);
  RxInt selectedPageIndex = 0.obs;
  Rx<ProductModel> productModel = ProductModel().obs;
  RxInt productQnt = 0.obs;
  HomeController homeController = Get.find<HomeController>();
  RxInt cartCount = 0.obs;
  RxList<String> selectedVariants = <String>[].obs;
  RxList<String> selectedIndexVariants = <String>[].obs;
  RxList<String> selectedIndexArray = <String>[].obs;
  RxList<Attributes>? attributes = <Attributes>[].obs;
  RxList<Variants>? variants = <Variants>[].obs;
  RxList<AttributesModel> attributesList = <AttributesModel>[].obs;
  //RxDouble priceTemp = 0.0.obs;
  RxInt selectedVariantIndex = 0.obs;
  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  RxDouble priceTotalValue = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();

    super.onInit();
  }

  getArgument() async {
    selectedVariantIndex.value = -1;
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      if (argumentData['productModel'] != null) {
        productModel.value = argumentData['productModel'];
        if (productModel.value.itemAttributes != null) {
          attributes!.value = productModel.value.itemAttributes!.attributes!;
          variants!.value = productModel.value.itemAttributes!.variants!;
        }
      }
    }

    await FireStoreUtils.getVendorAttribute().then((value) {
      if (value != null) {
        attributesList.value = value;
      }
      update();
    });

    isLoading.value = false;
    getData();
    update();
  }

  getData() {
    homeController.cartDatabase.value.allCartProducts.then((value) {
      final bool productIsInList = value.any((product) =>
          product.id == "${productModel.value.id!}~${product.variant_info != null ? VariantInfo.fromJson(jsonDecode(product.variant_info.toString())).variantId : ""}");


     if (productIsInList) {
        CartProduct element = value.firstWhere((product) =>
            product.id == "${productModel.value.id!}~${product.variant_info != null ? VariantInfo.fromJson(jsonDecode(product.variant_info.toString())).variantId : ""}");

      productQnt.value = element.quantity;
        if (element.discountPrice != '0') {
          priceTotalValue.value += double.parse(element.discountPrice!) * element.quantity;
        } else {
          priceTotalValue.value += double.parse(element.price) * element.quantity;
        }
      } else {
        productQnt.value = 0;
        priceTotalValue.value = 0;
      }
      update();
    });
  }
}
